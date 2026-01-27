import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum RiskLevel { high, medium, low, informational }

class Clause {
  final String title;
  final String text;
  final RiskLevel riskLevel;
  final String plainEnglishExplanation; // "What This Means"
  final String recommendation; // "Our Recommendation"

  const Clause({
    required this.title,
    required this.text,
    required this.riskLevel,
    required this.plainEnglishExplanation,
    required this.recommendation,
  });

  Color get color {
    switch (riskLevel) {
      case RiskLevel.high:
        return AppColors.error; // Red
      case RiskLevel.medium:
        return Colors.amber; // Yellow/Orange
      case RiskLevel.low:
        return AppColors.success; // Green (though mostly using blue for safe)
      case RiskLevel.informational:
        return AppColors.professionalBlue; // Blue
    }
  }

  Color get backgroundColor {
    switch (riskLevel) {
      case RiskLevel.high:
        return const Color(0xffFFF1F0);
      case RiskLevel.medium:
        return const Color(0xffFFF7E6);
      case RiskLevel.low:
      case RiskLevel.informational:
        return const Color(0xffE6F7FF);
    }
  }

  IconData get icon {
    switch (riskLevel) {
      case RiskLevel.high:
        return Icons.warning_amber_rounded;
      case RiskLevel.medium:
        return Icons.info_outline_rounded;
      case RiskLevel.low:
      case RiskLevel.informational:
        return Icons.check_circle_outline_rounded;
    }
  }
}
