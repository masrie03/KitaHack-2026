import 'package:flutter/material.dart';
import '../models/clause.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class InsightBottomSheet extends StatelessWidget {
  final Clause clause;

  const InsightBottomSheet({
    Key? key,
    required this.clause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white, // Clean white background for reading
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.professionalBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons
                      .check_circle_rounded, // Use check for general "Analyzed" feel or match clause type
                  color: AppColors.professionalBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clause.title, // "General Terms" or specific clause name
                      style: AppTextStyles.subHeader.copyWith(
                        color: AppColors.primaryNavy,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: clause.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        clause.riskLevel.name.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: clause.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Risk Score Indicator (Static for demo)
          Row(
            children: [
              Text(
                "Risk Score:",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primaryNavy,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              ...List.generate(10, (index) {
                // Example: 2/10 risk
                int riskScore = 2; // Default low risk example
                if (clause.riskLevel == RiskLevel.high) riskScore = 8;
                if (clause.riskLevel == RiskLevel.medium) riskScore = 5;

                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < riskScore
                        ? AppColors.professionalBlue
                        : Colors.grey[300],
                  ),
                );
              }),
              const SizedBox(width: 8),
              Text(
                "${clause.riskLevel == RiskLevel.high ? 8 : (clause.riskLevel == RiskLevel.medium ? 5 : 2)}/10",
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.professionalBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // What This Means
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffF0F7FF), // Very light blue
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.professionalBlue.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        size: 20, color: AppColors.professionalBlue),
                    const SizedBox(width: 8),
                    Text(
                      "What This Means",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  clause.plainEnglishExplanation,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.secondaryNavy,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recommendation (heading removed)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5), // Light grey
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              clause.recommendation,
              style: AppTextStyles.body.copyWith(
                color: AppColors.secondaryNavy,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Got It",
                style: AppTextStyles.button,
              ),
            ),
          ),
          const SizedBox(height: 20), // Bottom safe area
        ],
      ),
    );
  }
}
