import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';

/// Details screen — full scheme info with expandable sections and apply button.
class DetailsScreen extends StatefulWidget {
  final SchemeModel scheme;

  const DetailsScreen({Key? key, required this.scheme}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _benefitsExpanded = true;
  bool _eligibilityExpanded = false;
  bool _docsExpanded = false;

  bool get _isFullMatch =>
      widget.scheme.matchType.toLowerCase().contains('full');

  Color get _matchColor => _isFullMatch ? AppColors.primary : AppColors.warning;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ─── App Bar ─────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.navy,
      title: Text(
        widget.scheme.schemeName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // ─── Body ────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI helper banner
          _buildAIBanner(),
          const SizedBox(height: Spacing.md),

          // Benefits section (expandable)
          _buildExpandable(
            emoji: '💰',
            title: 'Benefits Summary',
            expanded: _benefitsExpanded,
            onToggle: () => setState(() => _benefitsExpanded = !_benefitsExpanded),
            child: _buildBenefitsContent(),
          ),
          const SizedBox(height: Spacing.sm),

          // Eligibility section (expandable)
          _buildExpandable(
            emoji: '✅',
            title: 'Eligibility Requirements',
            expanded: _eligibilityExpanded,
            onToggle: () => setState(() => _eligibilityExpanded = !_eligibilityExpanded),
            child: _buildEligibilityContent(),
          ),
          const SizedBox(height: Spacing.sm),

          // Documents section (expandable)
          _buildExpandable(
            emoji: '📋',
            title: 'Required Documents',
            expanded: _docsExpanded,
            onToggle: () => setState(() => _docsExpanded = !_docsExpanded),
            child: _buildDocumentsContent(),
          ),
          const SizedBox(height: Spacing.xl),

          // How to apply
          _buildHowToApply(),
          const SizedBox(height: Spacing.xl),

          // Categories
          if (widget.scheme.category.isNotEmpty) _buildCategories(),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }

  // ─── AI Banner ───────────────────────────────────────────────────────────

  Widget _buildAIBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.smart_toy_outlined, color: AppColors.warning, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confused by jargon?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navy)),
                SizedBox(height: 2),
                Text('I can explain this scheme in simple terms.',
                    style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('AI Simplifier coming soon!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Explain\nSimply',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.3)),
          ),
        ],
      ),
    );
  }

  // ─── Expandable Section ──────────────────────────────────────────────────

  Widget _buildExpandable({
    required String emoji,
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textLight, size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: child,
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  // ─── Section Content ─────────────────────────────────────────────────────

  Widget _buildBenefitsContent() {
    if (widget.scheme.benefits.isEmpty) {
      return const Text('No benefits information available.',
          style: TextStyle(fontSize: 13, color: AppColors.textLight));
    }

    final points = widget.scheme.benefits.contains('\n')
        ? widget.scheme.benefits.split('\n').where((s) => s.trim().isNotEmpty).toList()
        : widget.scheme.benefits.split('. ').where((s) => s.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFFF1F5F9), height: 1),
        const SizedBox(height: 12),
        ...points.map((p) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Expanded(
                    child: Text(
                      p.trim().endsWith('.') ? p.trim() : '${p.trim()}.',
                      style: const TextStyle(fontSize: 14, color: AppColors.textMedium, height: 1.5),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildEligibilityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFFF1F5F9), height: 1),
        const SizedBox(height: 12),

        // Confidence bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Match Confidence',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
            Text(
              '${(widget.scheme.confidenceScore * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _matchColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: widget.scheme.confidenceScore.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(_matchColor),
          ),
        ),
        const SizedBox(height: 14),

        // Match type chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _matchColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _isFullMatch ? '✅  Full Match' : '⚡  Partial Match',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _matchColor),
          ),
        ),
        const SizedBox(height: 12),

        // Match reason
        if (widget.scheme.matchReason.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.scheme.matchReason,
                    style: const TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentsContent() {
    final docs = widget.scheme.documentsRequired;
    if (docs.isEmpty) {
      return const Text('No documents listed.',
          style: TextStyle(fontSize: 13, color: AppColors.textLight));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFFF1F5F9), height: 1),
        const SizedBox(height: 12),
        ...docs.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(e.value,
                        style: const TextStyle(fontSize: 14, color: AppColors.textMedium)),
                  ),
                  const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.textLight),
                ],
              ),
            )),
      ],
    );
  }

  // ─── How to Apply ────────────────────────────────────────────────────────

  Widget _buildHowToApply() {
    final steps = [
      {'title': 'Visit Official Portal', 'desc': 'Navigate to the official portal via the link below.'},
      {'title': 'Registration', 'desc': 'Select \'New Registration\' and enter your Aadhaar details.'},
      {'title': 'Upload Documents', 'desc': 'Upload scanned copies of the required documents listed above.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 18, color: AppColors.navy),
            SizedBox(width: 8),
            Text('How to Apply',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.navy)),
          ],
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((e) {
          final isLast = e.key == steps.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number + connector
                Column(
                  children: [
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: Text('${e.key + 1}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: AppColors.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.value['title']!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                        const SizedBox(height: 3),
                        Text(e.value['desc']!,
                            style: const TextStyle(fontSize: 13, color: AppColors.textLight, height: 1.4)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ─── Categories ──────────────────────────────────────────────────────────

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: widget.scheme.category.map((c) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Text(c,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
              )).toList(),
        ),
      ],
    );
  }

  // ─── Bottom Bar ──────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Save Offline
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.download_done_rounded, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Saved for offline access'),
                        ],
                      ),
                      backgroundColor: AppColors.navy,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Offline',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),

            // Open Application Link
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.open_in_new, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Opening ${widget.scheme.schemeName}...')),
                        ],
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  // TODO: url_launcher → widget.scheme.applicationLink
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Open Application Link',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
