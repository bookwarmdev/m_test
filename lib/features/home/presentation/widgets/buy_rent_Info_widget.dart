import 'package:flutter/material.dart';
import 'package:moniepoint/core/extensions/string_extensions.dart';
import 'package:moniepoint/core/theme/app_colors.dart';

class BuyRentInfoWidget extends StatelessWidget {
  const BuyRentInfoWidget({super.key, required this.animationController});

  final AnimationController animationController;

  static const _padding = EdgeInsets.symmetric(horizontal: 16);
  static const _cardSpacing = 46.0;
  static const _cardHeight = 180.0;
  static const _cardWidthFactor = 0.45;
  static const _cardBorderRadius = 25.0;
  static const _cardShadowBlurRadius = 10.0;
  static const _cardShadowSpreadRadius = 2.0;
  static const _greetingAnimationIntervalStart = 0.4;
  static const _greetingAnimationIntervalEnd = 0.6;
  static const _cardAnimationIntervalStart = 0.5;
  static const _cardAnimationIntervalEnd = 0.6;
  static const _countAnimationIntervalStart = 0.6;
  static const _countAnimationIntervalEnd = 0.9;
  static const _descriptionSlideIntervalStart = 0.6;
  static const _descriptionSlideIntervalEnd = 0.9;
  static const _descriptionFadeIntervalStart = 0.63;
  static const _descriptionFadeIntervalEnd = 0.9;

  @override
  Widget build(BuildContext context) {
    final greetingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _greetingAnimationIntervalStart,
          _greetingAnimationIntervalEnd,
          curve: Curves.linear,
        ),
      ),
    );

    final cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _cardAnimationIntervalStart,
          _cardAnimationIntervalEnd,
          curve: Curves.easeOut,
        ),
      ),
    );

    final countAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          _countAnimationIntervalStart,
          _countAnimationIntervalEnd,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeTransition(
            opacity: greetingAnimation,
            child: Text(
              'Hi, Marina',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 22,
                color: AppColor.sandstone500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _buildDescription(context),
          const SizedBox(height: _cardSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatisticsCard(
                title: "BUY",
                count: 1034,
                isSquare: false,
                containerAnimation: cardAnimation,
                countAnimation: countAnimation,
              ),
              _StatisticsCard(
                title: "RENT",
                count: 2212,
                isSquare: true,
                containerAnimation: cardAnimation,
                countAnimation: countAnimation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              _descriptionSlideIntervalStart,
              _descriptionSlideIntervalEnd,
              curve: Curves.easeOut,
            ),
          ),
        );

        final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(
              _descriptionFadeIntervalStart,
              _descriptionFadeIntervalEnd,
              curve: Curves.easeIn,
            ),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      child: Text(
        "let's select your \nperfect place",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: 1.2,
          fontSize: 36,
          color: AppColor.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  const _StatisticsCard({
    required this.title,
    required this.count,
    required this.isSquare,
    required this.containerAnimation,
    required this.countAnimation,
  });

  final String title;
  final int count;
  final bool isSquare;
  final Animation<double> containerAnimation;
  final Animation<double> countAnimation;

  @override
  Widget build(BuildContext context) {
    final textColor = isSquare ? AppColor.sandstone500 : AppColor.white;
    final backgroundColor = isSquare ? AppColor.white : AppColor.amber600;

    return ScaleTransition(
      scale: containerAnimation,
      child: Container(
        height: BuyRentInfoWidget._cardHeight,
        width: MediaQuery.of(context).size.width * BuyRentInfoWidget._cardWidthFactor,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          borderRadius:
              isSquare ? BorderRadius.circular(BuyRentInfoWidget._cardBorderRadius) : null,
          boxShadow: [
            if (!isSquare)
              BoxShadow(
                color: Colors.black12,
                blurRadius: BuyRentInfoWidget._cardShadowBlurRadius,
                spreadRadius: BuyRentInfoWidget._cardShadowSpreadRadius,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor, fontSize: 16.0),
              ),
            ),
            const Spacer(),
            // Count and "Offers" text
            AnimatedBuilder(
              animation: countAnimation,
              builder: (context, child) {
                final currentCount = (count * countAnimation.value).toInt();
                final formattedCount = currentCount.toString().formattedNumber;
                return Column(
                  children: [
                    Text(
                      formattedCount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontSize: 42.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child!,
                  ],
                );
              },
              child: Text(
                "Offers",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
