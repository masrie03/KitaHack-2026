import 'dart:async';
import 'package:flutter/material.dart';
import '../services/upload_services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/upload_zone.dart';
import '../widgets/processing_indicator.dart';
import 'analysis_highlight_screen.dart';

// 1. The StatefulWidget (The external "shell")
class ScannerParserScreen extends StatefulWidget {
  const ScannerParserScreen({Key? key}) : super(key: key);

  @override
  State<ScannerParserScreen> createState() => _ScannerParserScreenState();
}

// 2. The State (The internal "brain")
class _ScannerParserScreenState extends State<ScannerParserScreen> {
  bool _isProcessing = false;
  double _progress = 0.0;
  final UploadService _uploadService = UploadService();

  Future<void> _handleFileUpload() async {
    final file = await _uploadService.pickPDF();
    if (file == null) return;

    setState(() {
      _isProcessing = true;
      _progress = 0.3;
    });

    try {
      final result = await _uploadService.uploadToBackend(file);

      if (!mounted) return;

      setState(() => _progress = 1.0);
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisHighlightScreen(analysisData: result),
          ),
        );

        setState(() {
          _isProcessing = false;
          _progress = 0.0;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: Text("Consent AI", style: AppTextStyles.header.copyWith(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("Upload Legal Document", style: AppTextStyles.header),
                  const SizedBox(height: 8),
                  Text("Scan or upload for AI analysis", style: AppTextStyles.body),
                  const SizedBox(height: 40),
                  
                 UploadZone(
                 isScanning: _isProcessing,
  // Use () to show this function takes no arguments
                onFileSelected: () => _handleFileUpload(), 
                  ),

                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  Visibility(
                    visible: false,
                    child: _ActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: "Scan with Camera",
                      onTap: () {},
                    ),
                  ),
                  const Visibility(
                    visible: false,
                    child: SizedBox(height: 16),
                  ),
                  _ActionButton(
                    icon: Icons.folder_open_rounded,
                    label: "Choose from Files",
                    isOutlined: true,
                    onTap: _handleFileUpload, 
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Align(
              alignment: Alignment.bottomCenter,
              child: ProcessingIndicator(progress: _progress),
            ),
        ],
      ),
    );
  }
}

// 3. The Helper Widget (Keep this outside the State class)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.secondaryNavy,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined ? Border.all(color: Colors.white24) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(label, style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}