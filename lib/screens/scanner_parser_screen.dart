import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/upload_zone.dart';
import '../widgets/processing_indicator.dart';
import '../widgets/glass_card.dart';

class ScannerParserScreen extends StatefulWidget {
  const ScannerParserScreen({Key? key}) : super(key: key);

  @override
  State<ScannerParserScreen> createState() => _ScannerParserScreenState();
}

class _ScannerParserScreenState extends State<ScannerParserScreen> {
  bool _isProcessing = false;
  double _progress = 0.0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startProcessing() {
    setState(() {
      _isProcessing = true;
      _progress = 0.0;
    });

    // Simulate AI parsing
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.02;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
          // Navigate to next screen or show success
          Future.delayed(const Duration(milliseconds: 500), () {
             // Reset for demo
             setState(() {
               _isProcessing = false;
               _progress = 0.0;
             });
             
             ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(
                 content: Text("Document successfully parsed!"),
                 backgroundColor: AppColors.success,
               ),
             );
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      appBar: AppBar(
        title: Text(
          "Consent AI",
          style: AppTextStyles.header.copyWith(fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background subtle gradient
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentBlue.withOpacity(0.05),
        
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Upload Legal Document",
                    style: AppTextStyles.header,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Scan or upload your document for AI analysis",
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 40),
                  
                  // Main Upload Area
                  UploadZone(
                    isScanning: _isProcessing,
                    onFileSelected: _startProcessing,
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.camera_alt_rounded,
                          label: "Scan with Camera",
                          color: AppColors.secondaryNavy,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.folder_open_rounded,
                          label: "Choose from Files",
                          isOutlined: true,
                          onTap: _startProcessing,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Info Card
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Supported Formats",
                              style: AppTextStyles.caption.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("• PDF documents (max 10MB)", style: AppTextStyles.caption),
                        Text("• Clear, readable text", style: AppTextStyles.caption),
                        Text("• Legal contracts and consent forms", style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // Processing Overlay
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isOutlined;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : (color ?? AppColors.secondaryNavy),
          borderRadius: BorderRadius.circular(16),
          border: isOutlined 
              ? Border.all(color: AppColors.textSecondary.withOpacity(0.5))
              : null,
          boxShadow: isOutlined ? null : [
            BoxShadow(
              color: const Color(0xff007AFF).withOpacity(0.3), // Blue shadow for primary actions? Or keep plain
              blurRadius: 0, 
              offset: const Offset(0,0), // Minimal shadow for flat design
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.button,
            ),
          ],
        ),
      ),
    );
  }
}
