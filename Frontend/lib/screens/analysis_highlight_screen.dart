import 'package:flutter/material.dart';
import '../models/clause.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/clause_card.dart';
import '../widgets/insight_bottom_sheet.dart';

class AnalysisHighlightScreen extends StatelessWidget {
  // We add this variable so the Scanner screen has a place to "plug in" the data
  final dynamic analysisData;

  const AnalysisHighlightScreen({
    Key? key,
    this.analysisData, // Making it optional (?) so it doesn't break anything
  }) : super(key: key);

  // Your original Mock Data
  final List<Clause> clauses = const [
    Clause(
      title: "Data Privacy & Access",
      text:
          "This agreement grants the Company unlimited access to your personal data, including but not limited to contact information, browsing history, location data, and biometric information.",
      riskLevel: RiskLevel.high,
      plainEnglishExplanation:
          "This clause gives the company permission to collect almost any data about you, including sensitive things like where you are and your physical characteristics (biometrics).",
      recommendation:
          "This is highly invasive. We recommend requesting this clause be removed or significantly limited to only data necessary for the service.",
    ),
    Clause(
      title: "Dispute Resolution",
      text:
          "The parties agree to resolve disputes through binding arbitration rather than court proceedings.",
      riskLevel: RiskLevel.medium,
      plainEnglishExplanation:
          "You cannot sue the company in a regular court or join a class action lawsuit. You must use a private arbitrator.",
      recommendation:
          "This limits your legal rights. If possible, opt-out of arbitration or negotiate for the right to sue for small claims.",
    ),
    Clause(
      title: "Entire Agreement",
      text:
          "This document constitutes the entire agreement between the parties and supersedes all prior negotiations and understandings.",
      riskLevel: RiskLevel.low,
      plainEnglishExplanation:
          "This is a standard legal clause that ensures the written agreement is the complete and final version, preventing reliance on verbal promises.",
      recommendation:
          "This is a standard protective clause. Ensure all important terms are included in the written document.",
    ),
    Clause(
      title: "Modification of Terms",
      text:
          "The Company reserves the right to modify these terms at any time without prior notice. Continued use of the service constitutes acceptance of modified terms.",
      riskLevel: RiskLevel.high,
      plainEnglishExplanation:
          "They can change the rules whenever they want without telling you, and if you keep using the app, you automatically agree to the new rules.",
      recommendation:
          "This is unfair. You should ask for a requirement that they notify you of material changes via email.",
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
          "Document Analysis",
          style: AppTextStyles.subHeader.copyWith(color: AppColors.primaryNavy),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_copy_outlined, color: AppColors.primaryNavy),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primaryNavy),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.primaryNavy),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xffF5F7FA),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.primaryNavy, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Analysis Complete",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const Spacer(),
                Text(
                  "${clauses.length} clauses analyzed",
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),

          // List of Clauses
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: clauses.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Terms of Service Agreement",
                          style: AppTextStyles.header.copyWith(
                            color: AppColors.primaryNavy,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Last updated: January 2026",
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  );
                }

                return ClauseCard(
                  clause: clauses[index - 1],
                  onTap: () => _showInsight(context, clauses[index - 1]),
                );
              },
            ),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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
                        side: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Modify Consent",
                        style: AppTextStyles.button.copyWith(color: AppColors.primaryNavy),
                      ),
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