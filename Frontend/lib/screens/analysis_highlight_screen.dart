import 'package:flutter/material.dart';
import '../models/clause.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/clause_card.dart';
import '../widgets/insight_bottom_sheet.dart';

class AnalysisHighlightScreen extends StatelessWidget {
  final dynamic analysisData;

  const AnalysisHighlightScreen({
    Key? key,
    required this.analysisData,
  }) : super(key: key);

  /// --- REAL DATA MAPPING & FILTERING ---
  List<Clause> getRealClauses() {
    if (analysisData == null || analysisData['clauses'] == null) {
      return []; // Return empty instead of mock data
    }

    final List<dynamic> rawList = analysisData['clauses'];

    try {
      // 1. Filter out the "Not found" / "N/A" noise from the Cuad-v1 benchmark
      return rawList.where((item) {
        final String clauseText = item['clause']?.toString().toLowerCase() ?? '';
        final String riskLevel = item['risk_level']?.toString().toLowerCase() ?? '';

        bool isNotFound = clauseText.contains("not found") || 
                         clauseText.contains("not applicable") ||
                         clauseText.contains("not explicitly stated");
        
        bool isMismatch = riskLevel.contains("n/a") || riskLevel.contains("mismatch");

        return !isNotFound && !isMismatch;
      }).map((item) {
        // 2. Map the actual backend keys to your Clause model
        final rawRisk = item['risk_level'] ?? item['riskLevel'] ?? item['risk'];
        
        return Clause(
          title: item['category']?.toString() ?? 'Insurance Clause',
          text: item['clause']?.toString() ?? '',
          riskLevel: _parseRisk(rawRisk?.toString()),
          plainEnglishExplanation: item['explanation']?.toString() ?? 'Analyzing details...',
          recommendation: item['recommendation']?.toString() ?? 'Review carefully.',
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ Mapping Error: $e");
      return [];
    }
  }

  RiskLevel _parseRisk(String? level) {
    if (level == null) return RiskLevel.low;
    final normalized = level.toLowerCase().trim();
    if (normalized.contains('high')) return RiskLevel.high;
    if (normalized.contains('medium') || normalized.contains('mod')) return RiskLevel.medium;
    return RiskLevel.low;
  }

  /// --- UI SUMMARY HEADER ---
  Widget _buildSummaryHeader(List<Clause> clauses) {
    final highCount = clauses.where((c) => c.riskLevel == RiskLevel.high).length;
    final medCount = clauses.where((c) => c.riskLevel == RiskLevel.medium).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("High Risk", highCount, Colors.red),
          _summaryItem("Medium Risk", medCount, Colors.orange),
          _summaryItem("Identified", clauses.length, AppColors.primaryNavy),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text("$count", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void _showInsight(BuildContext context, Clause clause) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InsightBottomSheet(clause: clause),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Clause> realClauses = getRealClauses();
    final String fileName = analysisData?['filename'] ?? "Document Analysis";

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Analysis Results", style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryNavy)),
      ),
      body: Column(
        children: [
          // Dynamic Summary Header
          if (realClauses.isNotEmpty) _buildSummaryHeader(realClauses),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              // +1 for the Header Title item
              itemCount: realClauses.isEmpty ? 1 : realClauses.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: AppTextStyles.header.copyWith(
                            color: AppColors.primaryNavy,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Medical Takaful Assessment", style: AppTextStyles.caption),
                      ],
                    ),
                  );
                }

                if (realClauses.isEmpty) {
                  return const Center(child: Text("No relevant medical clauses found."));
                }

                final currentClause = realClauses[index - 1];
                return ClauseCard(
                  clause: currentClause,
                  onTap: () => _showInsight(context, currentClause),
                );
              },
            ),
          ),

          // Action Buttons
          if (realClauses.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Accept Fully", style: AppTextStyles.button),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: AppColors.primaryNavy),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Modify", style: AppTextStyles.button.copyWith(color: AppColors.primaryNavy)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}