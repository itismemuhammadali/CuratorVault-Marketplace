import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vintage_app/core/theme/app_colors.dart';
import 'package:vintage_app/core/theme/text_styles.dart';

enum AppItemCardLayout { grid, list }

enum AppItemCardBadge { hot, trendy, cool }

enum AppItemCardGridActionPosition { topRight, bottomRight }

class AppItemCard extends StatelessWidget {
  final AppItemCardLayout layout;

  final String title;
  final String? subtitle;
  final String? locationText;
  final String? dateTimeText;
  final String? priceText;

  final Color? priceColor;

  /// 0.0 - 1.0 (e.g., 0.94 for 94%)
  final double? confidence;

  final String? imageAsset;
  final bool verified;
  final AppItemCardBadge? badge;

  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  /// Used when [gridActionIcon] is null.
  final Color? favoriteIconColor;
  final Color? unfavoriteIconColor;

  /// Grid-only action icon (e.g., eye). If null, uses the favorite icon.
  final IconData? gridActionIcon;
  final VoidCallback? onGridActionTap;
  final AppItemCardGridActionPosition gridActionPosition;

  /// Grid-only image aspect ratio.
  final double gridImageAspectRatio;

  /// Grid-only layout options.
  final bool gridShowDivider;
  final bool gridShowConfidenceOverlay;
  final bool gridShowConfidenceBar;

  /// Grid-only title max lines.
  final int gridTitleMaxLines;

  /// Grid-only title style override.
  final TextStyle? gridTitleStyle;

  /// Grid-only confidence bar width (when [gridShowConfidenceBar] is true).
  /// If null, uses full available width.
  final double? gridConfidenceBarWidth;

  /// Only used in [AppItemCardLayout.list].
  final bool showViewButton;
  final String viewLabel;
  final VoidCallback? onViewTap;

  /// List-only sizing. When [listHeight] is set, the whole list card becomes
  /// fixed-height and the image will fill that height.
  final double? listHeight;
  final double? listImageWidth;

  const AppItemCard({
    super.key,
    required this.layout,
    required this.title,
    this.subtitle,
    this.locationText,
    this.dateTimeText,
    this.priceText,
    this.priceColor,
    this.confidence,
    this.imageAsset,
    this.verified = false,
    this.badge,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
    this.favoriteIconColor,
    this.unfavoriteIconColor,
    this.gridActionIcon,
    this.onGridActionTap,
    this.gridActionPosition = AppItemCardGridActionPosition.topRight,
    this.gridImageAspectRatio = 1.2,
    this.gridShowDivider = false,
    this.gridShowConfidenceOverlay = true,
    this.gridShowConfidenceBar = false,
    this.gridTitleMaxLines = 2,
    this.gridTitleStyle,
    this.gridConfidenceBarWidth,
    this.showViewButton = true,
    this.viewLabel = 'View',
    this.onViewTap,
    this.listHeight,
    this.listImageWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isList = layout == AppItemCardLayout.list;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: isList
                  ? AppColors.shadowColor.withValues(alpha: 0.12)
                  : AppColors.shadowColor,
              blurRadius: isList ? 14.r : 20.r,
              offset: Offset(0, isList ? 6.h : 8.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: layout == AppItemCardLayout.grid
            ? _GridLayout(cardRadius: 16.r, parent: this)
            : _ListLayout(cardRadius: 16.r, parent: this),
      ),
    );
  }
}

class _GridLayout extends StatelessWidget {
  final double cardRadius;
  final AppItemCard parent;

  const _GridLayout({required this.cardRadius, required this.parent});

  @override
  Widget build(BuildContext context) {
    final showProgress =
        parent.gridShowConfidenceBar && parent.confidence != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardImage(
          radius: cardRadius,
          imageAsset: parent.imageAsset,
          badge: parent.badge,
          verified: parent.verified,
          confidence: parent.confidence,
          isFavorite: parent.isFavorite,
          onFavoriteTap: parent.onFavoriteTap,
          favoriteIconColor: parent.favoriteIconColor,
          unfavoriteIconColor: parent.unfavoriteIconColor,
          actionIcon: parent.gridActionIcon,
          onActionTap: parent.onGridActionTap,
          actionPosition: parent.gridActionPosition,
          showConfidenceOverlay: parent.gridShowConfidenceOverlay,
          imageAspectRatio: parent.gridImageAspectRatio,
        ),
        Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parent.title,
                maxLines: parent.gridTitleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: parent.gridTitleStyle ?? TextStyles.boldSmall,
              ),
              if (parent.gridShowDivider) ...[
                SizedBox(height: 10.h),
                Container(
                  height: 1,
                  color: AppColors.greyText.withValues(alpha: 0.12),
                ),
              ] else if ((parent.locationText ?? parent.subtitle) != null) ...[
                SizedBox(height: 8.h),
                _LocationRow(text: parent.locationText ?? parent.subtitle!),
              ],
              if (parent.priceText != null || showProgress) ...[
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (parent.priceText != null)
                      Expanded(
                        child: Text(
                          parent.priceText!,
                          style: TextStyles.boldSmall.copyWith(
                            color: parent.priceColor ?? AppColors.redButton,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (showProgress)
                      Text(
                        '${(parent.confidence!.clamp(0.0, 1.0) * 100).round()}%',
                        style: TextStyles.regularExtraSmall.copyWith(
                          color: AppColors.redButton,
                        ),
                      ),
                  ],
                ),
              ],
              if (showProgress) ...[
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: parent.gridConfidenceBarWidth ?? 92.w,
                    child: _ConfidenceBar(value: parent.confidence!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ListLayout extends StatelessWidget {
  final double cardRadius;
  final AppItemCard parent;

  const _ListLayout({required this.cardRadius, required this.parent});

  @override
  Widget build(BuildContext context) {
    final showMeta = parent.dateTimeText != null || parent.subtitle != null;

    final metaParts = <String>[
      if (parent.dateTimeText != null && parent.dateTimeText!.trim().isNotEmpty)
        parent.dateTimeText!.trim(),
      if (parent.subtitle != null && parent.subtitle!.trim().isNotEmpty)
        parent.subtitle!.trim(),
    ];

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: parent.listImageWidth ?? 112.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CardImageContent(imageAsset: parent.imageAsset),
                if (parent.confidence != null)
                  Positioned(
                    left: 8.w,
                    bottom: 8.w,
                    child: _ConfidencePill(value: parent.confidence!),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (parent.badge != null)
                        _BadgePill(badge: parent.badge!)
                      else
                        const SizedBox.shrink(),
                      const Spacer(),
                      _ListHeartButton(
                        isFavorite: parent.isFavorite,
                        onTap: parent.onFavoriteTap,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    parent.title,
                    maxLines: showMeta ? 2 : 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.boldSmall,
                  ),
                  if (showMeta) ...[
                    SizedBox(height: 6.h),
                    Text(
                      metaParts.join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regularExtraSmall.copyWith(
                        color: AppColors.greyText,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  if (parent.priceText != null)
                    Expanded(
                      child: Text(
                        parent.priceText!,
                        style: TextStyles.boldSmall.copyWith(
                          color: AppColors.redButton,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  if (parent.showViewButton)
                    _ViewButton(
                      label: parent.viewLabel,
                      onTap: parent.onViewTap ?? parent.onTap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.all(14.w),
      child: parent.listHeight != null
          ? SizedBox(height: parent.listHeight, child: row)
          : IntrinsicHeight(child: row),
    );
  }
}

class _CardImage extends StatelessWidget {
  final double radius;
  final String? imageAsset;
  final AppItemCardBadge? badge;
  final bool verified;
  final double? confidence;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final Color? favoriteIconColor;
  final Color? unfavoriteIconColor;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;
  final AppItemCardGridActionPosition actionPosition;
  final bool showConfidenceOverlay;
  final double imageAspectRatio;

  const _CardImage({
    required this.radius,
    required this.imageAsset,
    required this.badge,
    required this.verified,
    required this.confidence,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.favoriteIconColor,
    required this.unfavoriteIconColor,
    required this.actionIcon,
    required this.onActionTap,
    required this.actionPosition,
    required this.showConfidenceOverlay,
    required this.imageAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: imageAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CardImageContent(imageAsset: imageAsset),
          if (badge != null)
            Positioned(
              left: 12.w,
              top: 12.w,
              child: _BadgePill(badge: badge!),
            ),
          Positioned(
            right: 12.w,
            top: actionPosition == AppItemCardGridActionPosition.topRight
                ? 12.w
                : null,
            bottom: actionPosition == AppItemCardGridActionPosition.bottomRight
                ? 12.w
                : null,
            child: _FavoriteButton(
              isFavorite: isFavorite,
              onTap: onActionTap ?? onFavoriteTap,
              size: 36.w,
              icon: actionIcon,
              favoriteColor: favoriteIconColor,
              unfavoriteColor: unfavoriteIconColor,
            ),
          ),
          if (verified)
            Positioned(left: 12.w, bottom: 12.w, child: const _VerifiedPill()),
          if (showConfidenceOverlay && confidence != null)
            Positioned(
              left: 12.w,
              bottom: 12.w,
              child: _StatusPill(
                text: '${(confidence!.clamp(0.0, 1.0) * 100).round()}%',
              ),
            ),
        ],
      ),
    );
  }
}

class _CardImageContent extends StatelessWidget {
  final String? imageAsset;

  const _CardImageContent({required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    if (imageAsset == null || imageAsset!.trim().isEmpty) {
      return Container(color: AppColors.authBackBg);
    }

    return Image.asset(imageAsset!, fit: BoxFit.cover);
  }
}

class _BadgePill extends StatelessWidget {
  final AppItemCardBadge badge;

  const _BadgePill({required this.badge});

  @override
  Widget build(BuildContext context) {
    final label = switch (badge) {
      AppItemCardBadge.hot => 'Hot',
      AppItemCardBadge.trendy => 'Trendy',
      AppItemCardBadge.cool => 'Cool',
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.redButton,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.show_chart_rounded, size: 14.sp, color: Colors.white),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyles.boldExtraSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;

  const _StatusPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8.w,
            width: 8.w,
            decoration: const BoxDecoration(
              color: AppColors.greenSuccess,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyles.boldExtraSmall.copyWith(
              color: AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.greenSuccess,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 7.w,
            width: 7.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Verified',
            style: TextStyles.boldExtraSmall.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String text;

  const _LocationRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 16.sp,
          color: AppColors.greyText,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.regularExtraSmall.copyWith(
              color: AppColors.greyText,
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;
  final double size;
  final IconData? icon;
  final Color? favoriteColor;
  final Color? unfavoriteColor;

  const _FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    required this.size,
    this.icon,
    this.favoriteColor,
    this.unfavoriteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: size,
          width: size,
          child: Icon(
            icon ?? (isFavorite ? Icons.favorite : Icons.favorite_border),
            color: icon != null
                ? AppColors.greyText
                : (isFavorite
                      ? (favoriteColor ?? AppColors.redButton)
                      : (unfavoriteColor ?? AppColors.greyText)),
            size: (size * 0.55).clamp(16.0, 22.0),
          ),
        ),
      ),
    );
  }
}

class _ConfidencePill extends StatelessWidget {
  final double value;

  const _ConfidencePill({required this.value});

  @override
  Widget build(BuildContext context) {
    final percentText = '${(value.clamp(0.0, 1.0) * 100).round()}%';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        percentText,
        style: TextStyles.boldExtraSmall.copyWith(color: AppColors.redButton),
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final double value;

  const _ConfidenceBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: Container(
        height: 4.h,
        color: AppColors.greyText.withValues(alpha: 0.12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: clamped,
            child: Container(color: AppColors.redButton),
          ),
        ),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _ViewButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyles.boldExtraSmall.copyWith(color: AppColors.redButton),
        ),
      ),
    );
  }
}

class _ListHeartButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _ListHeartButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 20.r,
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 18.sp,
          color: AppColors.redButton,
        ),
      ),
    );
  }
}
