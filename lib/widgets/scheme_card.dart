import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';

/// Reusable scheme card widget matching the UI design.
/// Shows scheme name, match %, category, benefits, and action buttons.
class SchemeCard extends StatelessWidget {
  final SchemeModel scheme;
  final bool isTopMatch;
  final VoidCallback onViewDetails;
  final VoidCallback onApplyNow;

  const SchemeCard({
    Key? key,
    required this.scheme,
    this.isTopMatch = false,
    required this.onViewDetails,
    required this.onApplyNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.BorderRadius.xl),
        border: Border.all(
          color: isTopMatch
              ? const Color(0xFF0D9488).withOpacity(0.3)
              : const Color(0xFFE2E8F0),
          width: isTopMatch ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isTopMatch
                ? const Color(0xFF0D9488).withOpacity(0.06)
                : Colors.black.withOpacity(0.03),
            blurRadius: isTopMatch ? 16 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Match badge
          if (isTopMatch) _buildTopMatchBanner(),

          // Card header with icon, name, and match score
          _buildCardHeader(context),

          // Divider
          Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFF1F5F9),
            indent: AppConstants.Spacing.xl,
            endIndent: AppConstants.Spacing.xl,
          ),

          // Benefits section
          _buildBenefitsSection(context),

          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  /// Top match banner ribbon
  Widget _buildTopMatchBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.BorderRadius.xl - 1),
          topRight: Radius.circular(AppConstants.BorderRadius.xl - 1),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            'TOP MATCH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Card header: icon + name + subtitle + match percentage
  Widget _buildCardHeader(BuildContext context) {
    final matchPercentage = (scheme.confidenceScore * 100).toStringAsFixed(0);
    final bool isFullMatch = scheme.matchType.toLowerCase() == 'full';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.Spacing.xl,
        AppConstants.Spacing.lg,
        AppConstants.Spacing.xl,
        AppConstants.Spacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scheme type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                _getSchemeIcon(),
                color: const Color(0xFF0D9488),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.Spacing.md),

          // Name and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme.schemeName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  scheme.category.isNotEmpty
                      ? scheme.category.first
                      : scheme.matchType,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.Spacing.sm),

          // Match percentage badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isFullMatch
                  ? const Color(0xFF0D9488).withOpacity(0.1)
                  : const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.BorderRadius.sm),
            ),
            child: Text(
              '$matchPercentage% Match',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isFullMatch
                    ? const Color(0xFF0D9488)
                    : const Color(0xFFD97706),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Benefits section
  Widget _buildBenefitsSection(BuildContext context) {
    if (scheme.benefits.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.Spacing.xl,
        AppConstants.Spacing.md,
        AppConstants.Spacing.xl,
        AppConstants.Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KEY BENEFITS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D9488),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            scheme.benefits,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF475569),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Action buttons row
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.Spacing.xl,
        AppConstants.Spacing.sm,
        AppConstants.Spacing.xl,
        AppConstants.Spacing.lg,
      ),
      child: Row(
        children: [
          // View Details text button
          InkWell(
            onTap: onViewDetails,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF0D9488),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Apply Now button
          SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: onApplyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get appropriate icon based on scheme category
  IconData _getSchemeIcon() {
    final name = scheme.schemeName.toLowerCase();
    final cats = scheme.category.map((c) => c.toLowerCase()).toList();

    if (name.contains('kisan') ||
        name.contains('farm') ||
        cats.any((c) => c.contains('agriculture'))) {
      return Icons.agriculture_rounded;
    } else if (name.contains('startup') ||
        name.contains('business') ||
        cats.any((c) => c.contains('business'))) {
      return Icons.rocket_launch_rounded;
    } else if (name.contains('scholarship') ||
        name.contains('education') ||
        cats.any((c) => c.contains('education'))) {
      return Icons.school_rounded;
    } else if (name.contains('health') ||
        name.contains('medical') ||
        cats.any((c) => c.contains('health'))) {
      return Icons.health_and_safety_rounded;
    } else if (name.contains('housing') ||
        name.contains('awas') ||
        cats.any((c) => c.contains('housing'))) {
      return Icons.home_rounded;
    } else if (name.contains('pension') ||
        name.contains('insurance') ||
        cats.any((c) => c.contains('finance'))) {
      return Icons.account_balance_wallet_rounded;
    } else if (name.contains('skill') ||
        name.contains('employment') ||
        cats.any((c) => c.contains('employment'))) {
      return Icons.work_rounded;
    } else if (name.contains('women') ||
        name.contains('mahila') ||
        cats.any((c) => c.contains('women'))) {
      return Icons.female_rounded;
    }
    return Icons.account_balance_rounded;
  }
}
