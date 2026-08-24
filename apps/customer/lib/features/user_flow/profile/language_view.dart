import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/components/global_header/global_header.dart';
import 'package:vintage_app/core/components/global_header/header_config.dart';
import 'package:vintage_app/core/components/icons/icon_box.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/images.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

class _LanguageItem {
  const _LanguageItem({
    required this.name,
    required this.nativeName,
    required this.flagAsset,
  });

  final String name;
  final String nativeName;
  final String flagAsset;
}

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  final TextEditingController _searchController = TextEditingController();

  static const List<_LanguageItem> _allLanguages = [
    _LanguageItem(
      name: 'English',
      nativeName: 'English',
      flagAsset: 'assets/images/🇺🇸.png',
    ),
    _LanguageItem(
      name: 'English (UK)',
      nativeName: 'English',
      flagAsset: 'assets/images/🇬🇧.png',
    ),
    _LanguageItem(
      name: 'Spanish',
      nativeName: 'Español',
      flagAsset: 'assets/images/🇪🇸.png',
    ),
    _LanguageItem(
      name: 'French',
      nativeName: 'Français',
      flagAsset: 'assets/images/🇫🇷.png',
    ),
    _LanguageItem(
      name: 'German',
      nativeName: 'Deutsch',
      flagAsset: 'assets/images/🇩🇪.png',
    ),
    _LanguageItem(
      name: 'Italian',
      nativeName: 'Italiano',
      flagAsset: 'assets/images/🇮🇹.png',
    ),
    _LanguageItem(
      name: 'Portuguese',
      nativeName: 'Português',
      flagAsset: 'assets/images/🇵🇹.png',
    ),
    _LanguageItem(
      name: 'Portuguese (Brazil)',
      nativeName: 'Português (Brasil)',
      flagAsset: 'assets/images/🇧🇷.png',
    ),
    _LanguageItem(
      name: 'Dutch',
      nativeName: 'Nederlands',
      flagAsset: 'assets/images/🇳🇱.png',
    ),
    _LanguageItem(
      name: 'Swedish',
      nativeName: 'Svenska',
      flagAsset: 'assets/images/🇸🇪.png',
    ),
    _LanguageItem(
      name: 'Norwegian',
      nativeName: 'Norsk',
      flagAsset: 'assets/images/🇳🇴.png',
    ),
    _LanguageItem(
      name: 'Polish',
      nativeName: 'Polski',
      flagAsset: 'assets/images/🇵🇱.png',
    ),
    _LanguageItem(
      name: 'Turkish',
      nativeName: 'Türkçe',
      flagAsset: 'assets/images/🇹🇷.png',
    ),
    _LanguageItem(
      name: 'Russian',
      nativeName: 'Русский',
      flagAsset: 'assets/images/🇷🇺.png',
    ),
    _LanguageItem(
      name: 'Arabic',
      nativeName: 'العربية',
      flagAsset: 'assets/images/🇸🇦.png',
    ),
    _LanguageItem(
      name: 'Hindi',
      nativeName: 'हिन्दी',
      flagAsset: 'assets/images/🇮🇳.png',
    ),
    _LanguageItem(
      name: 'Japanese',
      nativeName: '日本語',
      flagAsset: 'assets/images/🇯🇵.png',
    ),
    _LanguageItem(
      name: 'Korean',
      nativeName: '한국어',
      flagAsset: 'assets/images/🇰🇷.png',
    ),
    _LanguageItem(
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
      flagAsset: 'assets/images/🇨🇳.png',
    ),
    _LanguageItem(
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
      flagAsset: 'assets/images/🇹🇼.png',
    ),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onQueryChanged)
      ..dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<int> _filteredIndexes() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return List<int>.generate(_allLanguages.length, (index) => index);
    }

    return List<int>.generate(_allLanguages.length, (index) => index).where((
      index,
    ) {
      final item = _allLanguages[index];
      return item.name.toLowerCase().contains(query) ||
          item.nativeName.toLowerCase().contains(query);
    }).toList();
  }

  Widget _searchField() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.bodyBg.withValues(alpha: 0.32)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          IconBox(
            icon: AppImages.globeIcon,
            width: 20.sp,
            height: 20.sp,
            bgColor: Colors.transparent,
            iconColor: AppColors.bodyBg.withValues(alpha: 0.70),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyles.regularMedium.copyWith(color: AppColors.bodyBg),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: 'Search languages...',
                hintStyle: TextStyles.regularMedium.copyWith(
                  color: AppColors.bodyBg.withValues(alpha: 0.58),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _flagContainer(String asset) {
    return Container(
      width: 30.h,
      height: 30.h,
      alignment: Alignment.center,
      child: Image.asset(asset, width: 30.h, height: 30.h, fit: BoxFit.contain),
    );
  }

  Widget _currentSelectionCard(_LanguageItem selected) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.28),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _flagContainer(selected.flagAsset),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Selected',
                  style: TextStyles.regularMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  selected.name,
                  style: TextStyles.boldMedium.copyWith(
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageRow({
    required int index,
    required _LanguageItem item,
    required bool isLast,
  }) {
    final isSelected = index == _selectedIndex;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(color: const Color(0xFFE4E9F0), width: 1),
                ),
        ),
        child: Row(
          children: [
            _flagContainer(item.flagAsset),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyles.mediumMedium.copyWith(
                      color: AppColors.lightText,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.nativeName,
                    style: TextStyles.regularMedium.copyWith(
                      color: AppColors.greyText,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 26.w,
                height: 26.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF334155),
                  shape: BoxShape.circle,
                ),
                child: IconBox(
                  icon: AppImages.tickIcon,
                  width: 26.w,
                  height: 26.w,
                  bgColor: Colors.transparent,
                  iconColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _allLanguages[_selectedIndex];
    final filtered = _filteredIndexes();

    return Scaffold(
      appBar: SimpleHeader(
        config: HeaderConfig(
          title: Text(
            'Language',
            style: TextStyles.boldLarge.copyWith(
              color: AppColors.bodyBg,
              fontSize: 28.sp,
            ),
          ),
          bottomWidget: _searchField(),
          height: 220.h,
        ),
      ),
      backgroundColor: AppColors.subPageBg,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          child: Column(
            children: [
              _currentSelectionCard(selected),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bodyBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFFDDE3EB)),
                ),
                child: filtered.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 26.h),
                        child: Text(
                          'No language found for your search.',
                          textAlign: TextAlign.center,
                          style: TextStyles.regularMedium.copyWith(
                            color: AppColors.greyText,
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(filtered.length, (i) {
                          final index = filtered[i];
                          return _languageRow(
                            index: index,
                            item: _allLanguages[index],
                            isLast: i == filtered.length - 1,
                          );
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
