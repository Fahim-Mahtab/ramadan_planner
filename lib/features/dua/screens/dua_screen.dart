import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/dua_model.dart';
import '../providers/dua_provider.dart';
import '../widgets/dua_detail_sheet.dart';
import 'ai_dua_recommender_screen.dart';

// ── Time period for the selector ───────────────────────────────────────────────
enum _Period { day, evening, night, all }

// ── Mixed list item types ──────────────────────────────────────────────────────
class _SectionTag {
  final String label;
  final Color color;
  final IconData icon;
  const _SectionTag(this.label, this.color, this.icon);
}

// ── Period meta-data ───────────────────────────────────────────────────────────
extension _PeriodExt on _Period {
  String label(BuildContext context) {
    switch (this) {
      case _Period.day:
        return AppLocale.format(AppLocale.duaPeriodDay);
      case _Period.evening:
        return AppLocale.format(AppLocale.duaPeriodEvening);
      case _Period.night:
        return AppLocale.format(AppLocale.duaPeriodNight);
      case _Period.all:
        return AppLocale.format(AppLocale.duaPeriodAll);
    }
  }

  String headerTitle(BuildContext context) {
    switch (this) {
      case _Period.day:
        return AppLocale.format(AppLocale.duaHeaderDay);
      case _Period.evening:
        return AppLocale.format(AppLocale.duaHeaderEvening);
      case _Period.night:
        return AppLocale.format(AppLocale.duaHeaderNight);
      case _Period.all:
        return AppLocale.format(AppLocale.duaHeaderAll);
    }
  }

  String headerSubtitle(BuildContext context) {
    switch (this) {
      case _Period.day:
        return AppLocale.format(AppLocale.duaSubtitleDay);
      case _Period.evening:
        return AppLocale.format(AppLocale.duaSubtitleEvening);
      case _Period.night:
        return AppLocale.format(AppLocale.duaSubtitleNight);
      case _Period.all:
        return AppLocale.format(AppLocale.duaSubtitleAll);
    }
  }

  IconData get icon {
    switch (this) {
      case _Period.day:
        return Icons.wb_sunny_rounded;
      case _Period.evening:
        return Icons.wb_twilight_rounded;
      case _Period.night:
        return Icons.nights_stay_rounded;
      case _Period.all:
        return Icons.volunteer_activism_rounded;
    }
  }

  Color get color {
    switch (this) {
      case _Period.day:
        return const Color(0xFFF59E0B);
      case _Period.evening:
        return const Color(0xFF6366F1);
      case _Period.night:
        return const Color(0xFF3B4C8C);
      case _Period.all:
        return const Color(0xFF059669);
    }
  }

  List<Color> get gradientColors {
    switch (this) {
      case _Period.day:
        return [const Color(0xFFF59E0B), const Color(0xFFF97316)];
      case _Period.evening:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case _Period.night:
        return [const Color(0xFF1E3A5F), const Color(0xFF0A1628)];
      case _Period.all:
        return [const Color(0xFF059669), const Color(0xFF10B981)];
    }
  }
}

// ── Screen ─────────────────────────────────────────────────────────────────────
class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> with TickerProviderStateMixin {
  late _Period _period;
  DuaCategory? _allTabCategory;
  bool _showFavoritesOnly = false;
  String _searchQuery = '';
  bool _isSearchVisible = false;
  late final AnimationController _listAnimController;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _period = _autoDetectPeriod();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  static _Period _autoDetectPeriod() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 17) return _Period.day;
    if (h >= 17 && h < 21) return _Period.evening;
    return _Period.night;
  }

  int _countFor(_Period p) {
    switch (p) {
      case _Period.day:
        return allDuas
            .where((d) =>
                d.group == DuaCategory.morning ||
                d.group == DuaCategory.daily)
            .length;
      case _Period.evening:
        return allDuas.where((d) => d.group == DuaCategory.evening).length;
      case _Period.night:
        return allDuas.where((d) => d.group == DuaCategory.night).length;
      case _Period.all:
        return allDuas.length;
    }
  }

  bool _matches(DuaModel d, String q, String langCode) =>
      d.getName(langCode).toLowerCase().contains(q) ||
      d.getTranslation(langCode).toLowerCase().contains(q) ||
      d.reference.toLowerCase().contains(q) ||
      d.arabic.contains(q);

  List<dynamic> _buildItems(DuaProvider provider, String langCode) {
    final q = _searchQuery.toLowerCase();

    switch (_period) {
      case _Period.day:
        var morning = allDuas
            .where((d) => d.group == DuaCategory.morning)
            .toList();
        var daily = allDuas
            .where((d) => d.group == DuaCategory.daily)
            .toList();
        if (q.isNotEmpty) {
          morning = morning.where((d) => _matches(d, q, langCode)).toList();
          daily = daily.where((d) => _matches(d, q, langCode)).toList();
          return [...morning, ...daily];
        }
        return [
          _SectionTag(
              AppLocale.format(AppLocale.duaSectionMorning),
              DuaCategory.morning.accentColor,
              DuaCategory.morning.categoryIcon),
          ...morning,
          _SectionTag(
              AppLocale.format(AppLocale.duaSectionDaily),
              DuaCategory.daily.accentColor,
              DuaCategory.daily.categoryIcon),
          ...daily,
        ];

      case _Period.evening:
        var list =
            allDuas.where((d) => d.group == DuaCategory.evening).toList();
        if (q.isNotEmpty) list = list.where((d) => _matches(d, q, langCode)).toList();
        return list;

      case _Period.night:
        var list =
            allDuas.where((d) => d.group == DuaCategory.night).toList();
        if (q.isNotEmpty) list = list.where((d) => _matches(d, q, langCode)).toList();
        return list;

      case _Period.all:
        var list = allDuas.toList();
        if (_showFavoritesOnly) {
          list = list.where((d) => provider.isFavorite(d.id)).toList();
        }
        if (_allTabCategory != null) {
          list = list.where((d) => d.group == _allTabCategory).toList();
        }
        if (q.isNotEmpty) {
          list = list.where((d) => _matches(d, q, langCode)).toList();
        }
        // Group by category when unfiltered
        if (_allTabCategory == null && !_showFavoritesOnly && q.isEmpty) {
          return _buildGroupedList(list, langCode);
        }
        return list;
    }
  }

  List<dynamic> _buildGroupedList(List<DuaModel> duas, String langCode) {
    const order = [
      DuaCategory.morning,
      DuaCategory.evening,
      DuaCategory.night,
      DuaCategory.daily,
      DuaCategory.ramadanSpecial,
      DuaCategory.travel,
      DuaCategory.forgiveness,
    ];
    final groups = <DuaCategory, List<DuaModel>>{};
    for (final d in duas) {
      groups.putIfAbsent(d.group, () => []).add(d);
    }
    final result = <dynamic>[];
    for (final cat in order) {
      final catDuas = groups[cat];
      if (catDuas != null && catDuas.isNotEmpty) {
        result.add(_SectionTag(
            cat.getLabel(langCode), cat.accentColor, cat.categoryIcon));
        result.addAll(catDuas);
      }
    }
    return result;
  }

  void _switchPeriod(_Period p) {
    setState(() {
      _period = p;
      _allTabCategory = null;
      _showFavoritesOnly = false;
      _searchQuery = '';
      _searchController.clear();
      _isSearchVisible = false;
    });
    _resetListAnimation();
  }

  void _resetListAnimation() {
    _listAnimController.reset();
    _listAnimController.forward();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = FlutterLocalization.instance.currentLocale?.languageCode ?? 'bn';

    return Consumer<DuaProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = _buildItems(provider, langCode);

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FloatingActionButton(
            heroTag: 'dua_ai_fab',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AIDuaRecommenderScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
          ),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(isDark, provider, langCode),
                if (_isSearchVisible) _buildSearchBar(isDark),
                _buildPeriodSelector(isDark),
                if (_period == _Period.all)
                  _buildAllTabExtras(isDark, provider, langCode),
                Expanded(
                  child: _buildContent(isDark, provider, items, langCode),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(bool isDark, DuaProvider provider, String langCode) {
    final gradientColors = isDark
        ? [AppColors.emerald950, AppColors.backgroundDark]
        : _period.gradientColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -15,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            left: -15,
            bottom: 5,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
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
                    child: Icon(
                      _period.icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _period.headerTitle(context),
                            key: ValueKey(_period),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _period.headerSubtitle(context),
                            key: ValueKey('sub_$_period'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search button
                  _HeaderIconBtn(
                    icon: _isSearchVisible
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    onTap: () {
                      setState(() {
                        _isSearchVisible = !_isSearchVisible;
                        if (!_isSearchVisible) {
                          _searchQuery = '';
                          _searchController.clear();
                          _resetListAnimation();
                        } else {
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () => _searchFocus.requestFocus(),
                          );
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  // Favorites toggle (only in All tab)
                  if (_period == _Period.all)
                    _HeaderIconBtn(
                      icon: _showFavoritesOnly
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _showFavoritesOnly ? AppColors.error : null,
                      onTap: () {
                        setState(() {
                          _showFavoritesOnly = !_showFavoritesOnly;
                          if (_showFavoritesOnly) _allTabCategory = null;
                        });
                        _resetListAnimation();
                      },
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────

  Widget _buildSearchBar(bool isDark) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
            hintText: AppLocale.format(AppLocale.duaSearchHint),
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

  // ── Period selector ────────────────────────────────────────────────────────

  Widget _buildPeriodSelector(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      height: 82,
      child: Row(
        children: [
          for (final p in _Period.values) ...[
            if (p != _Period.values.first) const SizedBox(width: 8),
            Expanded(
              child: _PeriodCard(
                period: p,
                isSelected: _period == p,
                isDark: isDark,
                count: _countFor(p),
                onTap: () => _switchPeriod(p),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── All-tab extras (category chips) ──────────────────────────────────────

  Widget _buildAllTabExtras(bool isDark, DuaProvider provider, String langCode) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: DuaCategory.values.length,
        itemBuilder: (context, index) {
          final cat = DuaCategory.values[index];
          final isSelected =
              _allTabCategory == cat && !_showFavoritesOnly;

          return GestureDetector(
            onTap: () {
              setState(() {
                _allTabCategory = isSelected ? null : cat;
                _showFavoritesOnly = false;
              });
              _resetListAnimation();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? cat.accentColor
                    : isDark
                        ? AppColors.slate800
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? cat.accentColor
                      : isDark
                          ? AppColors.slate700
                          : AppColors.slate300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cat.accentColor.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.categoryIcon,
                    size: 13,
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? AppColors.slate400
                            : AppColors.slate500,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    cat.getLabel(langCode),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  // ── Content ────────────────────────────────────────────────────────────────

  Widget _buildContent(
      bool isDark, DuaProvider provider, List<dynamic> items, String langCode) {
    if (items.isEmpty) return _buildEmptyState(isDark);

    return CustomScrollView(
      slivers: [
        // Dua of the Day card — only in All tab with no filter
        if (_period == _Period.all &&
            _allTabCategory == null &&
            !_showFavoritesOnly &&
            _searchQuery.isEmpty)
          SliverToBoxAdapter(
            child: _buildDuaOfDay(isDark, provider, langCode),
          ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                if (item is _SectionTag) {
                  return _buildSectionHeader(item, isDark);
                }
                final dua = item as DuaModel;
                final animIndex = items
                        .sublist(0, index + 1)
                        .whereType<DuaModel>()
                        .length -
                    1;
                return _AnimatedDuaTile(
                  key: ValueKey(dua.id),
                  dua: dua,
                  langCode: langCode,
                  index: animIndex,
                  listAnimController: _listAnimController,
                  isFavorite: provider.isFavorite(dua.id),
                  onFavoriteToggle: () =>
                      provider.toggleFavorite(dua.id),
                  onTap: () => DuaDetailSheet.show(context, dua),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  // ── Dua of the day ─────────────────────────────────────────────────────────

  Widget _buildDuaOfDay(bool isDark, DuaProvider provider, String langCode) {
    final dua = provider.duaOfTheDay;

    return GestureDetector(
      onTap: () => DuaDetailSheet.show(context, dua),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
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
            color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
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
                        AppLocale.format(AppLocale.duaOfTheDay),
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
                  size: 13,
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
                color: isDark
                    ? const Color(0xFFD1FAE5)
                    : AppColors.emerald900,
              ).copyWith(height: 1.7),
            ),
            const SizedBox(height: 10),
            Text(
              dua.getName(langCode),
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

  // ── Section header ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(_SectionTag tag, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: tag.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Icon(tag.icon, size: 15, color: tag.color),
          const SizedBox(width: 6),
          Text(
            tag.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: isDark ? AppColors.slate300 : AppColors.slate600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: tag.color.withValues(alpha: 0.25),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState(bool isDark) {
    final isFavEmpty = _showFavoritesOnly;
    final isSearchEmpty = _searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isFavEmpty
                  ? Icons.favorite_border_rounded
                  : Icons.search_off_rounded,
              size: 56,
              color: isDark ? AppColors.slate600 : AppColors.slate400,
            ),
            const SizedBox(height: 16),
            Text(
              isFavEmpty
                  ? AppLocale.format(AppLocale.duaNoFavorites)
                  : isSearchEmpty
                      ? AppLocale.format(AppLocale.duaNoResults)
                      : AppLocale.format(AppLocale.duaEmptyPeriod),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.slate400 : AppColors.slate500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isFavEmpty
                  ? AppLocale.format(AppLocale.duaNoFavoritesHint)
                  : AppLocale.format(AppLocale.duaNoResultsHint),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.slate500 : AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Period card ────────────────────────────────────────────────────────────────

class _PeriodCard extends StatelessWidget {
  final _Period period;
  final bool isSelected;
  final bool isDark;
  final int count;
  final VoidCallback onTap;

  const _PeriodCard({
    required this.period,
    required this.isSelected,
    required this.isDark,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = period.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: period.gradientColors,
                )
              : null,
          color: isSelected
              ? null
              : isDark
                  ? AppColors.slate800
                  : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isDark
                    ? AppColors.slate700
                    : AppColors.slate300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              period.icon,
              size: 22,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(height: 5),
            Text(
              period.label(context),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? AppColors.slate300
                        : AppColors.slate700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$count${AppLocale.format(AppLocale.duaCountSuffix)}',
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.8)
                    : isDark
                        ? AppColors.slate500
                        : AppColors.slate400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header icon button ─────────────────────────────────────────────────────────

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _HeaderIconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 20),
      ),
    );
  }
}

// ── Animated dua tile ──────────────────────────────────────────────────────────

class _AnimatedDuaTile extends StatelessWidget {
  final DuaModel dua;
  final String langCode;
  final int index;
  final AnimationController listAnimController;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _AnimatedDuaTile({
    super.key,
    required this.dua,
    required this.langCode,
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
        langCode: langCode,
        isFavorite: isFavorite,
        onFavoriteToggle: onFavoriteToggle,
        onTap: onTap,
      ),
    );
  }
}

// ── Dua tile content ───────────────────────────────────────────────────────────

class _DuaTileContent extends StatelessWidget {
  final DuaModel dua;
  final String langCode;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const _DuaTileContent({
    required this.dua,
    required this.langCode,
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
              // Left accent bar
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
              // Category icon
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
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dua.getName(langCode),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : AppColors.slate800,
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
                          color: isDark
                              ? AppColors.slate400
                              : AppColors.slate500,
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
                              dua.group.getLabel(langCode),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.menu_book_rounded,
                            size: 11,
                            color: isDark
                                ? AppColors.slate500
                                : AppColors.slate400,
                          ),
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
              // Favorite button
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
        ),
      ),
    );
  }
}
