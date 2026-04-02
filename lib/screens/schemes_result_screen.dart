import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/scheme_model.dart';
import '../widgets/scheme_card.dart';
import 'details_screen.dart';

/// Results screen displaying the list of matched government schemes.
/// Features search, filter chips, and scheme cards with view/apply actions.
class SchemesResultScreen extends StatefulWidget {
  final List<SchemeModel> schemes;

  const SchemesResultScreen({
    Key? key,
    required this.schemes,
  }) : super(key: key);

  @override
  State<SchemesResultScreen> createState() => _SchemesResultScreenState();
}

class _SchemesResultScreenState extends State<SchemesResultScreen>
    with SingleTickerProviderStateMixin {
  /// Search query
  String _searchQuery = '';

  /// Active filter
  String _activeFilter = 'All Schemes';

  /// Search controller
  final TextEditingController _searchController = TextEditingController();

  /// Animation controller for staggered list entry
  late AnimationController _listAnimController;

  /// Filter options
  final List<String> _filters = [
    'All Schemes',
    'Category',
    'State',
    'Benefit Type',
  ];

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listAnimController.dispose();
    super.dispose();
  }

  /// Filtered list of schemes based on search and filter
  List<SchemeModel> get _filteredSchemes {
    List<SchemeModel> result = widget.schemes;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((scheme) {
        return scheme.schemeName.toLowerCase().contains(query) ||
            scheme.benefits.toLowerCase().contains(query) ||
            scheme.matchReason.toLowerCase().contains(query) ||
            scheme.category.any((c) => c.toLowerCase().contains(query));
      }).toList();
    }

    // Sort by confidence score (highest first)
    result.sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore));

    return result;
  }

  /// Find the top match scheme
  SchemeModel? get _topMatch {
    if (widget.schemes.isEmpty) return null;
    final sorted = List<SchemeModel>.from(widget.schemes)
      ..sort((a, b) => b.confidenceScore.compareTo(a.confidenceScore));
    return sorted.first;
  }

  /// Navigate to details screen
  void _openDetails(SchemeModel scheme) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailsScreen(scheme: scheme),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  /// Handle apply now action
  void _handleApplyNow(SchemeModel scheme) {
    if (scheme.applicationLink.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.open_in_new, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Opening ${scheme.schemeName} application...'),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Application link not available yet.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFF59E0B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: _buildAppBar(),
      body: widget.schemes.isEmpty ? _buildEmptyState() : _buildBody(),
      bottomNavigationBar: widget.schemes.isNotEmpty
          ? _buildBottomNavBar()
          : null,
    );
  }

  /// Custom app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: const Color(0xFF1E293B),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Your Eligible Schemes',
        style: TextStyle(
          color: Color(0xFF1E293B),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: const Color(0xFFF1F5F9),
          height: 1,
        ),
      ),
    );
  }

  /// Main body content
  Widget _buildBody() {
    final filtered = _filteredSchemes;

    return Column(
      children: [
        // Search bar
        _buildSearchBar(),

        // Filter chips
        _buildFilterChips(),

        // Results count
        _buildResultsCount(filtered.length),

        // Scheme cards list
        Expanded(
          child: filtered.isEmpty
              ? _buildNoResultsState()
              : _buildSchemesList(filtered),
        ),
      ],
    );
  }

  /// Search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
          decoration: InputDecoration(
            hintText: 'Search schemes...',
            hintStyle: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: const Color(0xFF94A3B8),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  /// Horizontal filter chips
  Widget _buildFilterChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = _activeFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() => _activeFilter = filter);
            },
            child: AnimatedContainer(
              duration: AppConstants.Animations.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF0D9488)
                    : Colors.white,
                borderRadius: BorderRadius.circular(
                  AppConstants.BorderRadius.pill,
                ),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF0D9488)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Results count indicator
  Widget _buildResultsCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          Text(
            '$count scheme${count != 1 ? 's' : ''} found',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.tune_rounded,
            size: 18,
            color: const Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }

  /// Scheme cards list
  Widget _buildSchemesList(List<SchemeModel> schemes) {
    return AnimatedBuilder(
      animation: _listAnimController,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: schemes.length,
          itemBuilder: (context, index) {
            final scheme = schemes[index];
            final isTop = _topMatch != null &&
                scheme.schemeName == _topMatch!.schemeName &&
                index == 0;

            // Staggered animation
            final delay = (index * 0.15).clamp(0.0, 0.8);
            final itemAnimation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _listAnimController,
                curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOutCubic),
              ),
            );

            return FadeTransition(
              opacity: itemAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(itemAnimation),
                child: SchemeCard(
                  scheme: scheme,
                  isTopMatch: isTop,
                  onViewDetails: () => _openDetails(scheme),
                  onApplyNow: () => _handleApplyNow(scheme),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Empty state when no schemes at all
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(
                  Icons.inbox_rounded,
                  size: 40,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Schemes Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We couldn\'t find any eligible schemes\nfor your profile. Try adjusting your details.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Go Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0D9488),
                side: const BorderSide(color: Color(0xFF0D9488)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// No results state for search
  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 16),
          const Text(
            'No matching schemes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom navigation bar
  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', false),
              _buildNavItem(Icons.description_rounded, 'Schemes', true),
              _buildNavItem(Icons.check_circle_outline_rounded, 'Applied', false),
              _buildNavItem(Icons.person_outline_rounded, 'Profile', false),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom nav item
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? const Color(0xFF0D9488)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? const Color(0xFF0D9488)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
