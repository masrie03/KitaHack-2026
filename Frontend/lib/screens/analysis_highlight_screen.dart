import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../models/clause.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/clause_card.dart';
import '../widgets/insight_bottom_sheet.dart';

class AnalysisHighlightScreen extends StatefulWidget {
  final dynamic analysisData;

  const AnalysisHighlightScreen({
    Key? key,
    required this.analysisData,
  }) : super(key: key);

  @override
  State<AnalysisHighlightScreen> createState() => _AnalysisHighlightScreenState();
}

class _AnalysisHighlightScreenState extends State<AnalysisHighlightScreen> {
  // --- Translation State ---
  final GoogleTranslator _translator = GoogleTranslator();
  bool _isBM = false;
  bool _isTranslating = false;
  List<Clause> _translatedClauses = [];

  /// --- REAL DATA MAPPING & FILTERING ---
  List<Clause> getRealClauses() {
    if (widget.analysisData == null || widget.analysisData['clauses'] == null) {
      return [];
    }

    final List<dynamic> rawList = widget.analysisData['clauses'];

    try {
      return rawList.where((item) {
        final String clauseText = item['clause']?.toString().toLowerCase() ?? '';
        final String riskLevel = item['risk_level']?.toString().toLowerCase() ?? '';

        bool isNotFound = clauseText.contains("not found") || 
                         clauseText.contains("not applicable") ||
                         clauseText.contains("not explicitly stated");
        
        bool isMismatch = riskLevel.contains("n/a") || riskLevel.contains("mismatch");

        return !isNotFound && !isMismatch;
      }).map((item) {
        final rawRisk = item['risk_level'] ?? item['riskLevel'] ?? item['risk'];
        
        return Clause(
          title: item['category']?.toString() ?? 'Legal Clause',
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

  /// --- TRANSLATION FUNCTION ---
  Future<void> _toggleLanguage(List<Clause> originalClauses) async {
    if (_isBM) {
      setState(() => _isBM = false);
      return;
    }

    if (_translatedClauses.isNotEmpty && _translatedClauses.length == originalClauses.length) {
      setState(() => _isBM = true);
      return;
    }

    setState(() => _isTranslating = true);

    try {
      List<Clause> translated = [];
      for (var clause in originalClauses) {
        var titleT = await _translator.translate(clause.title, to: 'ms');
        var textT = await _translator.translate(clause.text, to: 'ms');
        var explanationT = await _translator.translate(clause.plainEnglishExplanation, to: 'ms');
        var recT = await _translator.translate(clause.recommendation, to: 'ms');

        translated.add(Clause(
          title: titleT.text,
          text: textT.text,
          riskLevel: clause.riskLevel,
          plainEnglishExplanation: explanationT.text,
          recommendation: recT.text,
        ));
      }

      setState(() {
        _translatedClauses = translated;
        _isBM = true;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() => _isTranslating = false);
      debugPrint("Translation Error: $e");
    }
  }

  /// --- UI COMPONENTS ---
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
          _summaryItem("High Risk", highCount, Colors.white),
          _summaryItem("Medium Risk", medCount, Colors.white),
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
    final List<Clause> englishClauses = getRealClauses();
    final List<Clause> displayClauses = _isBM ? _translatedClauses : englishClauses;
    final String fileName = widget.analysisData?['filename'] ?? "Document Analysis";

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryNavy),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Analysis Results", style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryNavy)),
            actions: [
              // Language Toggle
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: _isTranslating ? null : () => _toggleLanguage(englishClauses),
                  icon: const Icon(Icons.translate, 
                  size: 18,
                  color:AppColors.primaryNavy ),
                  label: Text(_isBM ? "EN" : "BM", style: TextStyle(color: AppColors.primaryNavy)),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              if (displayClauses.isNotEmpty) _buildSummaryHeader(displayClauses),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: displayClauses.isEmpty ? 1 : displayClauses.length + 1,
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
                            Text(_isBM ? "Analisis dokumen yang telah diterjemahkan ke dalam Bahasa Melayu." : "Analysis of the document, translated into Bahasa Malaysia.",
                                 style: AppTextStyles.caption),
                          ],
                        ),
                      );
                    }

                    if (displayClauses.isEmpty) {
                      return const Center(child: Text("No relevant clauses found."));
                    }

                    final currentClause = displayClauses[index - 1];
                    return ClauseCard(
                      clause: currentClause,
                      onTap: () => _showInsight(context, currentClause),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Loading Overlay for Translation
        if (_isTranslating)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Menterjemah...", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}