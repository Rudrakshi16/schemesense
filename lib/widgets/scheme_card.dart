import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';

/// Reusable scheme card widget.
/// Shows name, match badge, confidence bar, benefits, and action buttons.
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

  bool get _isFullMatch => scheme.matchType.toLowerCase().contains('full');

  Color get _matchColor => _isFullMatch ? AppColors.primary : AppColors.warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTopMatch ? AppColors.primary.withOpacity(0.4) : AppColors.border,
          width: isTopMatch ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Top Match" banner
          if (isTopMatch) _buildTopMatchBanner(),

          // Header: icon + name + match badge
          _buildHeader(),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9),
              indent: 20, endIndent: 20),

          // Confidence bar
          _buildConfidenceBar(),

          // Benefits
          if (scheme.benefits.isNotEmpty) _buildBenefits(),

          // Match reason
          if (scheme.matchReason.isNotEmpty) _buildMatchReason(),

          // Buttons row
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildTopMatchBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF14B8A6)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: 13),
          SizedBox(width: 4),
          Text(
            'TOP MATCH',
            style: TextStyle(
              color: Colors.white, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scheme Icon
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.account_balance_rounded,
                  color: AppColors.primary, size: 22),
            ),
          ),
          const SizedBox(width: Spacing.md),

          // Name + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme.schemeName,
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.navy, height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (scheme.category.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    scheme.category.first,
                    style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Spacing.sm),

          // Match type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _matchColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _isFullMatch ? 'Full Match' : 'Partial Match',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: _matchColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar() {
    final pct = (scheme.confidenceScore * 100).toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Match Confidence',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: Colors.grey[500]),
              ),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: _matchColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: scheme.confidenceScore.clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(_matchColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY BENEFITS',
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700,
              color: AppColors.primary, letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            scheme.benefits,
            style: const TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchReason() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.textLight),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              scheme.matchReason,
              style: const TextStyle(fontSize: 12, color: AppColors.textLight, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        children: [
          // View Details
          GestureDetector(
            onTap: onViewDetails,
            child: const Row(
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.chevron_right_rounded, color: AppColors.primary, size: 18),
              ],
            ),
          ),
          const Spacer(),

          // Apply Now
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: onApplyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Apply Now',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
