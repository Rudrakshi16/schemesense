import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';

/// Details screen for an individual government scheme.
/// Shows full benefits, eligibility, required documents, how-to-apply steps,
/// and action buttons matching the UI design.
class DetailsScreen extends StatefulWidget {
  final SchemeModel scheme;

  const DetailsScreen({
    Key? key,
    required this.scheme,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  /// Track expanded sections
  bool _benefitsExpanded = true;
  bool _eligibilityExpanded = false;
  bool _documentsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  /// Dark navy app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.scheme.schemeName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
    );
  }

  /// Scrollable body
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jargon helper banner
          _buildJargonBanner(),

          // Benefits Summary (expandable)
          _buildExpandableSection(
            icon: '💰',
            title: 'Benefits Summary',
            content: _buildBenefitsContent(),
            isExpanded: _benefitsExpanded,
            onToggle: () {
              setState(() => _benefitsExpanded = !_benefitsExpanded);
            },
          ),

          // Eligibility Requirements (expandable)
          _buildExpandableSection(
            icon: '✅',
            title: 'Eligibility Requirements',
            content: _buildEligibilityContent(),
            isExpanded: _eligibilityExpanded,
            onToggle: () {
              setState(() => _eligibilityExpanded = !_eligibilityExpanded);
            },
          ),

          // Required Documents (expandable)
          _buildExpandableSection(
            icon: '📋',
            title: 'Required Documents',
            content: _buildDocumentsContent(),
            isExpanded: _documentsExpanded,
            onToggle: () {
              setState(() => _documentsExpanded = !_documentsExpanded);
            },
          ),

          // How to Apply section
          _buildHowToApply(),

          // Categories tags
          if (widget.scheme.category.isNotEmpty) _buildCategoriesTags(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// "Confused by jargon?" helper banner
  Widget _buildJargonBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(AppConstants.BorderRadius.lg),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.work_outline_rounded,
                color: Color(0xFFF59E0B),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Confused by jargon?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'I can explain this scheme in simple terms.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('AI Simplifier coming soon!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Explain\nSimply',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  /// Generic expandable section widget
  Widget _buildExpandableSection({
    required String icon,
    required String title,
    required Widget content,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.BorderRadius.lg),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(AppConstants.BorderRadius.lg),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: AppConstants.Animations.fast,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF94A3B8),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppConstants.Animations.normal,
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }

  /// Benefits content
  Widget _buildBenefitsContent() {
    final benefits = widget.scheme.benefits;
    if (benefits.isEmpty) {
      return const Text(
        'No benefits information available.',
        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      );
    }

    // Try to split benefits by periods or bullet-style markers
    final points = _splitBenefitsToPoints(benefits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 12),
        ...points.map((point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text('•  ', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    )),
                  ),
                  Expanded(
                    child: Text(
                      point.trim(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  /// Split benefits text into bullet points
  List<String> _splitBenefitsToPoints(String text) {
    // Split by common delimiters
    List<String> points = [];

    if (text.contains('\n')) {
      points = text.split('\n').where((s) => s.trim().isNotEmpty).toList();
    } else if (text.contains('. ')) {
      points = text.split('. ').where((s) => s.trim().isNotEmpty).toList();
      points = points.map((p) => p.endsWith('.') ? p : '$p.').toList();
    } else {
      points = [text];
    }

    return points;
  }

  /// Eligibility content
  Widget _buildEligibilityContent() {
    final reason = widget.scheme.matchReason;
    if (reason.isEmpty) {
      return const Text(
        'No eligibility details available.',
        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 12),

        // Confidence score indicator
        _buildConfidenceBar(),
        const SizedBox(height: 16),

        // Match reason
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Color(0xFF0D9488),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Confidence score bar
  Widget _buildConfidenceBar() {
    final score = widget.scheme.confidenceScore;
    final percentage = (score * 100).toStringAsFixed(0);
    final isHigh = score >= 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Match Confidence',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isHigh
                    ? const Color(0xFF0D9488)
                    : const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: score,
            minHeight: 8,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(
              isHigh
                  ? const Color(0xFF0D9488)
                  : const Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    );
  }

  /// Documents required content
  Widget _buildDocumentsContent() {
    final docs = widget.scheme.documentsRequired;
    if (docs.isEmpty) {
      return const Text(
        'No document requirements listed.',
        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: Color(0xFFF1F5F9)),
        const SizedBox(height: 12),
        ...docs.asMap().entries.map((entry) {
          final index = entry.key;
          final doc = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    doc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                ),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// How to Apply section with numbered steps
  Widget _buildHowToApply() {
    final steps = _getHowToApplySteps();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: Color(0xFF1E293B),
              ),
              SizedBox(width: 8),
              Text(
                'How to Apply',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Steps
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;

            return _buildApplyStep(
              stepNumber: index + 1,
              title: step['title']!,
              description: step['description']!,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  /// Single apply step with connector line
  Widget _buildApplyStep({
    required int stepNumber,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number and connector
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Step content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generate how-to-apply steps based on scheme
  List<Map<String, String>> _getHowToApplySteps() {
    return [
      {
        'title': 'Visit Official Portal',
        'description':
            'Navigate to the official portal via the link below.',
      },
      {
        'title': 'Registration',
        'description':
            'Select \'New Registration\' and enter your Aadhaar details.',
      },
      {
        'title': 'Upload Documents',
        'description':
            'Upload the scanned copies of required documents listed above.',
      },
    ];
  }

  /// Category tags section
  Widget _buildCategoriesTags() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.scheme.category.map((cat) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(
                    AppConstants.BorderRadius.pill,
                  ),
                  border: Border.all(
                    color: const Color(0xFF0D9488).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  cat,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D9488),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Bottom action buttons
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Save Offline button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.download_done_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text('Saved for offline access'),
                        ],
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E293B),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Offline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Open Application Link button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.scheme.applicationLink.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.open_in_new,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Opening ${widget.scheme.schemeName}...',
                              ),
                            ),
                          ],
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: const Color(0xFF0D9488),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Open Application Link',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
