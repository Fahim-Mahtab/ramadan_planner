import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import '../widgets/dua_detail_sheet.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with TickerProviderStateMixin {
  DuaCategory? _selectedCategory;
  bool _showFavoritesOnly = false;
  String _searchQuery = '';
  bool _isSearchVisible = false;
  late final AnimationController _listAnimController;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

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
    _listAnimController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<DuaModel> _filteredDuas(DuaProvider provider) {
    var list = allDuas.toList();

    if (_showFavoritesOnly) {
      list = list.where((d) => provider.isFavorite(d.id)).toList();
    }

    if (_selectedCategory != null) {
      list = list.where((d) => d.group == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((d) =>
              d.categoryBangla.toLowerCase().contains(q) ||
              d.bangla.toLowerCase().contains(q) ||
              d.reference.toLowerCase().contains(q) ||
              d.arabic.contains(q))
          .toList();
    }

    return list;
  }

  void _resetListAnimation() {
    _listAnimController.reset();
    _listAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<DuaProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredList = _filteredDuas(provider);
        final showDuaOfDay = _selectedCategory == null &&
            !_showFavoritesOnly &&
            _searchQuery.isEmpty;

        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(isDark, provider)),
              if (_isSearchVisible)
                SliverToBoxAdapter(child: _buildSearchBar(isDark)),
              SliverToBoxAdapter(child: _buildCategoryChips(isDark)),
              if (showDuaOfDay)
                SliverToBoxAdapter(
                    child: _buildDuaOfDay(isDark, provider)),
              if (filteredList.isEmpty)
                SliverFillRemaining(child: _buildEmptyState(isDark))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dua = filteredList[index];
                        return _AnimatedDuaTile(
                          key: ValueKey(dua.id),
                          dua: dua,
                          index: index,
                          listAnimController: _listAnimController,
                          isFavorite: provider.isFavorite(dua.id),
                          onFavoriteToggle: () =>
                              provider.toggleFavorite(dua.id),
                          onTap: () => DuaDetailSheet.show(context, dua),
                        );
                      },
                      childCount: filteredList.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark, DuaProvider provider) {
    final favCount = provider.favorites.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.emerald950,
                  AppColors.backgroundDark,
                ]
              : [
                  const Color(0xFF059669),
                  const Color(0xFF10B981),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.volunteer_activism_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'দোয়া সমূহ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${allDuas.length}টি দোয়া • ${favCount > 0 ? '$favCountটি প্রিয়' : 'প্রিয় দোয়া যোগ করুন'}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearchVisible = !_isSearchVisible;
                        if (!_isSearchVisible) {
                          _searchQuery = '';
                          _searchController.clear();
                          _resetListAnimation();
                        } else {
                          Future.delayed(const Duration(milliseconds: 100),
                              () => _searchFocus.requestFocus());
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        _isSearchVisible
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          onChanged: (v) {
            setState(() => _searchQuery = v);
            _resetListAnimation();
          },
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : AppColors.slate800,
          ),
          decoration: InputDecoration(
            hintText: 'দোয়া খুঁজুন...',
            hintStyle: TextStyle(
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? AppColors.slate400 : AppColors.slate500,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(bool isDark) {
    final categories = [
      (null, 'সকল', Icons.apps_rounded),
      ...DuaCategory.values.map(
          (c) => (c as DuaCategory?, c.banglaLabel, c.categoryIcon)),
    ];

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 1) {
            final isSelected = _showFavoritesOnly;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _showFavoritesOnly = !_showFavoritesOnly;
                  if (_showFavoritesOnly) _selectedCategory = null;
                });
                _resetListAnimation();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.error
                      : isDark
                          ? AppColors.slate800
                          : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.error
                        : isDark
                            ? AppColors.slate700
                            : AppColors.slate300,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: isSelected
                          ? Colors.white
                          : isDark
                              ? AppColors.slate400
                              : AppColors.slate500,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'প্রিয়',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : isDark
                                ? AppColors.slate300
                                : AppColors.slate600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final catIndex = index > 1 ? index - 1 : index;
          final (cat, label, icon) = categories[catIndex];
          final isSelected =
              !_showFavoritesOnly && _selectedCategory == cat;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
                _showFavoritesOnly = false;
              });
              _resetListAnimation();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (cat?.accentColor ?? AppColors.primary)
                    : isDark
                        ? AppColors.slate800
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (cat?.accentColor ?? AppColors.primary)
                      : isDark
                          ? AppColors.slate700
                          : AppColors.slate300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (cat?.accentColor ?? AppColors.primary)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? AppColors.slate400
                            : AppColors.slate500,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isDark
                              ? AppColors.slate300
                              : AppColors.slate600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDuaOfDay(bool isDark, DuaProvider provider) {
    final dua = provider.duaOfTheDay;

    return GestureDetector(
      onTap: () => DuaDetailSheet.show(context, dua),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.gold.withValues(alpha: 0.15),
                    AppColors.emerald900.withValues(alpha: 0.2),
                  ]
                : [
                    const Color(0xFFFFFBEB),
                    const Color(0xFFFEF3C7),
                  ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded,
                          size: 13, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(
                        'আজকের দোয়া',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.gold.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              dua.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.arabicTextStyle(
                fontSize: 20,
                color: isDark ? const Color(0xFFD1FAE5) : AppColors.emerald900,
              ).copyWith(height: 1.7),
            ),
            const SizedBox(height: 10),
            Text(
              dua.categoryBangla,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.slate700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dua.reference,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.slate400 : AppColors.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _showFavoritesOnly
                ? Icons.favorite_border_rounded
                : Icons.search_off_rounded,
            size: 56,
            color: isDark ? AppColors.slate600 : AppColors.slate400,
          ),
          const SizedBox(height: 16),
          Text(
            _showFavoritesOnly
                ? 'কোনো প্রিয় দোয়া নেই'
                : 'কোনো দোয়া পাওয়া যায়নি',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.slate400 : AppColors.slate500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _showFavoritesOnly
                ? 'হৃদয় আইকনে ট্যাপ করে প্রিয় দোয়া যোগ করুন'
                : 'অন্য কিছু দিয়ে খোঁজার চেষ্টা করুন',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.slate500 : AppColors.slate400,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _AnimatedDuaTile extends StatelessWidget {
  final DuaModel dua;
  final int index;
  final AnimationController listAnimController;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _AnimatedDuaTile({
    super.key,
    required this.dua,
    required this.index,
    required this.listAnimController,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.06).clamp(0.0, 0.6);
    final end = (delay + 0.4).clamp(0.0, 1.0);

    final animation = CurvedAnimation(
      parent: listAnimController,
      curve: Interval(delay, end, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - animation.value)),
          child: child,
        ),
      ),
      child: _DuaTileContent(
        dua: dua,
        isFavorite: isFavorite,
        onFavoriteToggle: onFavoriteToggle,
        onTap: onTap,
      ),
    );
  }
}

class _DuaTileContent extends StatelessWidget {
  final DuaModel dua;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _DuaTileContent({
    required this.dua,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = dua.group.accentColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.slate800.withValues(alpha: 0.6)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.slate700.withValues(alpha: 0.5)
                : AppColors.slate100,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withValues(alpha: 0.12),
                ),
                child: Icon(dua.icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dua.categoryBangla,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.slate800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dua.arabic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.arabicTextStyle(
                          fontSize: 14,
                          color:
                              isDark ? AppColors.slate400 : AppColors.slate500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dua.group.banglaLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.menu_book_rounded,
                              size: 11,
                              color: isDark
                                  ? AppColors.slate500
                                  : AppColors.slate400),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              dua.reference,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.slate500
                                    : AppColors.slate400,
                              ),
                            ),
                          ),
                          if (dua.tasbihTarget > 0) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.loop_rounded,
                                size: 11, color: AppColors.gold),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          size: 20,
                          color: isFavorite
                              ? AppColors.error
                              : isDark
                                  ? AppColors.slate500
                                  : AppColors.slate400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
