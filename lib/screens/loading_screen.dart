import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/api_service.dart';
import '../models/scheme_model.dart';
import 'schemes_result_screen.dart';

/// Loading screen — calls API and shows animated progress steps.
class LoadingScreen extends StatefulWidget {
  final int age;
  final int income;
  final String occupation;
  final String gender;
  final String state;

  const LoadingScreen({
    Key? key,
    required this.age,
    required this.income,
    required this.occupation,
    required this.gender,
    required this.state,
  }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _currentStep = 0;
  bool _hasError = false;

  final _steps = const [
    {'title': 'Retrieving government schemes', 'sub': 'Scanning national & state databases'},
    {'title': 'Evaluating eligibility', 'sub': 'Matching criteria with your profile'},
    {'title': 'Simplifying policy information', 'sub': 'Removing legal jargon'},
    {'title': 'Generating recommendations', 'sub': 'Personalizing your dashboard'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _startLoading();
  }

  Future<void> _startLoading() async {
    // Animate steps while API call runs in parallel
    final apiFuture = ApiService.getSchemes(
      age: widget.age,
      income: widget.income,
      occupation: widget.occupation,
      gender: widget.gender,
      state: widget.state,
    );

    // Animate through steps
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() => _currentStep = i + 1);
    }

    // Wait for API to finish
    try {
      final schemes = await apiFuture;
      if (!mounted) return;

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SchemesResultScreen(schemes: schemes),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _hasError = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to fetch schemes. Please try again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.xxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing AI icon
                  _buildPulsingIcon(),
                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Analyzing Schemes...',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Our AI is analyzing thousands of schemes\nto find the best ones for you.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  // Progress steps card
                  _buildStepsCard(),
                  const SizedBox(height: 36),

                  // Version badge
                  _buildVersionBadge(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPulsingIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 0.95 + (_pulseController.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: AppColors.primary, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.smart_toy_outlined, size: 48, color: AppColors.primary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final isCompleted = i < _currentStep;
          final isActive = i == _currentStep;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.xl, vertical: 14),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppColors.primary.withOpacity(0.1)
                        : isActive
                            ? AppColors.primary.withOpacity(0.08)
                            : Colors.grey[100],
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                        : isActive
                            ? const SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : Icon(Icons.circle_outlined, color: Colors.grey[350], size: 20),
                  ),
                ),
                const SizedBox(width: Spacing.lg),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _steps[i]['title']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: (isCompleted || isActive) ? FontWeight.w600 : FontWeight.w400,
                          color: (isCompleted || isActive) ? AppColors.navy : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _steps[i]['sub']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: (isCompleted || isActive) ? AppColors.textLight : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7, height: 7,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.success),
          ),
          const SizedBox(width: 8),
          Text(
            'SCHEMEASSIST AI V2.0',
            style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: Colors.grey[600], letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
