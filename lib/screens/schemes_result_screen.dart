import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';
import '../widgets/scheme_card.dart';
import 'details_screen.dart';

/// Results screen — displays matched schemes as a searchable, filterable list.
class SchemesResultScreen extends StatefulWidget {
  final List<SchemeModel> schemes;

  const SchemesResultScreen({Key? key, required this.schemes}) : super(key: key);

  @override
  State<SchemesResultScreen> createState() => _SchemesResultScreenState();
}

class _SchemesResultScreenState extends State<SchemesResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _activeFilter = 'All';

  final List<String> _filters = ['All', 'Full Match', 'Partial Match'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Sort by confidence (highest first) + apply search/filter
  List<SchemeModel> get _filtered {
    List<SchemeModel> list = List.from(widget.schemes)
      ..sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore));

    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((s) =>
          s.schemeName.toLowerCase().contains(q) ||
          s.benefits.toLowerCase().contains(q) ||
          s.category.any((c) => c.toLowerCase().contains(q))).toList();
    }

    if (_activeFilter == 'Full Match') {
      list = list.where((s) => s.matchType.toLowerCase().contains('full')).toList();
    } else if (_activeFilter == 'Partial Match') {
      list = list.where((s) => !s.matchType.toLowerCase().contains('full')).toList();
    }

    return list;
  }

  /// The scheme with the highest confidence score
  SchemeModel? get _topMatch {
    if (widget.schemes.isEmpty) return null;
    return (List.from(widget.schemes)
          ..sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore)))
        .first;
  }

  void _openDetails(SchemeModel scheme) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailsScreen(scheme: scheme)),
    );
  }

  void _applyNow(SchemeModel scheme) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening application for ${scheme.schemeName}...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // TODO: Use url_launcher to open scheme.applicationLink
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: widget.schemes.isEmpty ? _buildEmptyState() : _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.navy),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Your Eligible Schemes',
        style: TextStyle(color: AppColors.navy, fontSize: 17, fontWeight: FontWeight.w700),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('AI',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFF1F5F9)),
      ),
    );
  }

  Widget _buildBody() {
    final filtered = _filtered;
    return Column(
      children: [
        const SizedBox(height: Spacing.md),
        _buildSearchBar(),
        const SizedBox(height: Spacing.sm),
        _buildFilterChips(),
        _buildResultsCount(filtered.length),
        Expanded(
          child: filtered.isEmpty
              ? _buildNoResultsState()
              : _buildList(filtered),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search schemes...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textLight, size: 22),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textLight),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = _filters[i];
          final active = _activeFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                    color: active ? AppColors.primary : AppColors.border),
              ),
              child: Text(
                f,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.textMedium,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Text(
            '$count scheme${count != 1 ? 's' : ''} found',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<SchemeModel> schemes) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      itemCount: schemes.length,
      itemBuilder: (context, i) {
        final scheme = schemes[i];
        final isTop = _topMatch != null &&
            scheme.schemeName == _topMatch!.schemeName &&
            i == 0;
        return SchemeCard(
          scheme: scheme,
          isTopMatch: isTop,
          onViewDetails: () => _openDetails(scheme),
          onApplyNow: () => _applyNow(scheme),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.inbox_rounded, size: 36, color: AppColors.textLight),
            ),
            const SizedBox(height: Spacing.xl),
            const Text('No Schemes Found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: Spacing.sm),
            Text(
              'We couldn\'t find any eligible schemes for your profile.\nTry adjusting your details.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xxl),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Go Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded, size: 44, color: AppColors.textLight),
          const SizedBox(height: 12),
          const Text('No matching schemes',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
          const SizedBox(height: 6),
          Text('Try a different search term',
              style: TextStyle(fontSize: 13, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', false),
              _navItem(Icons.description_rounded, 'Schemes', true),
              _navItem(Icons.check_circle_outline_rounded, 'Applied', false),
              _navItem(Icons.person_outline_rounded, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: active ? AppColors.primary : AppColors.textLight),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? AppColors.primary : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
