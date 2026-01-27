import 'package:flutter/material.dart';
import '../models/clause.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ClauseCard extends StatelessWidget {
  final Clause clause;
  final VoidCallback onTap;

  const ClauseCard({
    Key? key,
    required this.clause,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: clause.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: clause.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: clause.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        clause.icon,
                        color: clause.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        clause.text,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors
                              .primaryNavy, // Darker text for readability on light bg
                          fontSize: 15,
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 44), // Align with text
                    Icon(
                      Icons.touch_app_rounded,
                      size: 14,
                      color: clause.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Tap for details",
                      style: AppTextStyles.caption.copyWith(
                        color: clause.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
