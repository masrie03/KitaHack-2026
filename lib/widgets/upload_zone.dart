import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class UploadZone extends StatelessWidget {
  final VoidCallback? onFileSelected;
  final bool isScanning;

  const UploadZone({
    Key? key,
    this.onFileSelected,
    this.isScanning = false,
  }) : super(key: key);

  Future<void> _pickFile() async {
    // Stub for file picking logic
    // In a real app, use FilePicker.platform.pickFiles()
    if (onFileSelected != null) {
      onFileSelected!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isScanning ? null : _pickFile,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        padding: const EdgeInsets.all(6),
        color: AppColors.accentBlue.withOpacity(0.5),
        strokeWidth: 2,
        dashPattern: const [10, 6],
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.secondaryNavy.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.lightNavy,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.accentBlue,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tap to Upload PDF or Scan',
                style: AppTextStyles.subHeader.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Supported format: PDF (max 10MB)',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
