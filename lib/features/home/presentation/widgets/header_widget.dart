import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint/core/asset/image_paths.dart';

import '../../../../core/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.expandTextProgress,
    required this.animationController,
  });

  final double expandTextProgress;
  final AnimationController animationController;

  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
  static const _containerHeight = 44.0;
  static const _containerPadding = EdgeInsets.all(8.0);
  static const _containerBorderRadius = 10.0;
  static const _containerWidthFactor = 0.4;
  static const _containerMinWidth = 10.0;
  static const _containerAnimationIntervalStart = 0.0;
  static const _containerAnimationIntervalEnd = 0.5;
  static const _avatarRadius = 26.0;
  static const _iconTextSpacing = 5.0;
  static const _iconHeight = 20.0;

  static const _cityTextAnimationIntervalStart = 0.35;
  static const _cityTextAnimationIntervalEnd = 0.5;

  Widget _buildContainerContent(context, Animation<double> cityTextAnimation) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          ImagePaths.location,
          color: AppColor.sandstone500,
          height: _iconHeight,
        ),
        const SizedBox(width: _iconTextSpacing),
        Expanded(
          child: FadeTransition(
            opacity: cityTextAnimation,
            child: Text(
              "Saint Petersburg",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColor.sandstone500,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Container width animation (0ms - 1500ms)
    final containerAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _containerAnimationIntervalStart,
          _containerAnimationIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    final contentOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _cityTextAnimationIntervalStart,
          _cityTextAnimationIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    final cityTextAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _cityTextAnimationIntervalStart,
          _cityTextAnimationIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    final avatarAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _containerAnimationIntervalStart,
          _containerAnimationIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    return Padding(
      padding: _padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AnimatedBuilder(
              animation: containerAnimation,
              builder: (context, child) {
                final targetWidth =
                    MediaQuery.of(context).size.width * _containerWidthFactor;
                final currentWidth =
                    _containerMinWidth +
                    (targetWidth - _containerMinWidth) *
                        containerAnimation.value;

                return Container(
                  width: currentWidth,
                  height: _containerHeight,
                  padding: _containerPadding,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(_containerBorderRadius),
                  ),
                  child: child,
                );
              },
              child: AnimatedBuilder(
                animation: contentOpacityAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: contentOpacityAnimation.value,
                    child: child,
                  );
                },
                child: _buildContainerContent(context, cityTextAnimation),
              ),
            ),
          ),

          ScaleTransition(
            scale: avatarAnimation,
            child: CircleAvatar(
              radius: _avatarRadius,
              backgroundImage: AssetImage(ImagePaths.avatar),
            ),
          ),
        ],
      ),
    );
  }
}
