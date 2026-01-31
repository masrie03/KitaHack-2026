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

  // MAPPING LOGIC: This converts your backend JSON to the UI Objects
List<Clause> getMappedClauses() {
    // Debug print to see the structure in the UI layer
    print("MAPPING DATA: $analysisData");

    if (analysisData == null || analysisData['clauses'] == null) {
      print("❌ No 'clauses' key found in response!");
      return mockClauses; 
    }

    final List<dynamic> rawList = analysisData['clauses'];
    
    try {
      return rawList.map((item) {
        return Clause(
          // Extracting 'category' as title from your console log
          title: item['category']?.toString() ?? 'Legal Clause', 
          // Extracting 'clause' as text from your console log
          text: item['clause']?.toString() ?? 'No text provided', 
          riskLevel: _parseRisk(item['riskLevel']?.toString()),
          plainEnglishExplanation: item['explanation']?.toString() ?? 'Analyzing...',
          recommendation: item['recommendation']?.toString() ?? 'Review carefully.',
        );
      }).toList();
    } catch (e) {
      print("❌ Mapping Error: $e");
      return mockClauses;
    }
  }

  RiskLevel _parseRisk(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
        return RiskLevel.high;
      case 'medium':
        return RiskLevel.medium;
      case 'low':
      case 'safe':
        return RiskLevel.low;
      default:
        return RiskLevel.low;
    }
  }

  // Your original Mock Data (Fallback only)
  final List<Clause> mockClauses = const [
    Clause(
      title: "Data Privacy",
      text: "Standard privacy terms...",
      riskLevel: RiskLevel.medium,
      plainEnglishExplanation: "Mock data shown because real data failed to map.",
      recommendation: "Check mapping keys.",
    ),
  ];

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
    final List<Clause> displayClauses = getMappedClauses();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Analysis Results",
          style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryNavy),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xffF5F7FA),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.primaryNavy, size: 20),
                const SizedBox(width: 8),
                Text(
                  "AI Analysis complete",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
                ),
                const Spacer(),
                Text("${displayClauses.length} items found"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: displayClauses.length,
              itemBuilder: (context, index) {
                return ClauseCard(
                  clause: displayClauses[index],
                  onTap: () => _showInsight(context, displayClauses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}