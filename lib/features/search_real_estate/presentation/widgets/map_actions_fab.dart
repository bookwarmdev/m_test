import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint/core/asset/image_paths.dart';
import 'package:moniepoint/core/theme/app_colors.dart';

import 'fab_button.dart';

class MapActionsFab extends StatefulWidget {
  const MapActionsFab({super.key, required this.animationController});
  final AnimationController animationController;

  @override
  State<MapActionsFab> createState() => _OverlayDialogState();
}

class _OverlayDialogState extends State<MapActionsFab>
    with TickerProviderStateMixin {
  final _overlayPortalController = OverlayPortalController();
  final _overlayPortalController2 = OverlayPortalController();
  late AnimationController _controller;
  late Animation<double> _rippleAnimation;

  int iconIndex = 0;
  late Animation<double> _animation;
  late double _begin, _end;
  bool _onHideBorder = false;

  final options = [
    'Cosy areas',
    'Price',
    'Infrastructure',
    'Without any layer',
  ];

  final _navIconKeys = [GlobalKey(), GlobalKey()];

  double? _overlayTopPosition;
  double? _overlayLeftPosition;

  @override
  void initState() {
    _begin = 20;
    _end = 15;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    );

    _rippleAnimation = Tween<double>(
      begin: _begin,
      end: _end,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hideBorder();
        _controller.reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hideBorder() {
    setState(() {
      _onHideBorder = false;
    });
  }

  void _onDisplayBorder() {
    setState(() {
      _onHideBorder = true;
    });
  }

  void _calculateOverlayPosition(int index) {
    final RenderBox renderBox =
        _navIconKeys[index].currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _overlayTopPosition = position.dy - 150;
      _overlayLeftPosition = position.dx - 2;
    });
  }

  void _onTap(int index) {
    _onDisplayBorder();
    _controller.forward();
    _calculateOverlayPosition(index);
    setState(() {
      widget.animationController.forward();
      if (index == 0) {
        _overlayPortalController.show();
      } else {
        _overlayPortalController2.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            ...List.generate(
              2,
              (index) => OverlayPortal(
                controller:
                    [
                      _overlayPortalController,
                      _overlayPortalController2,
                    ][index],
                overlayChildBuilder: (context) {
                  return Positioned(
                    top: _overlayTopPosition,
                    left: _overlayLeftPosition,
                    child: Transform.scale(
                      scale: _animation.value,
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: 200, // Fixed width for the menu
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(
                            24,
                          ), // Increased corner radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            options.length,
                            (idx) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.animationController.reverse();
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  spacing: 12,
                                  children: [
                                    SvgPicture.asset(
                                      [
                                        ImagePaths.shield,
                                        ImagePaths.wallet,
                                        ImagePaths.trash,
                                        ImagePaths.layer,
                                      ][idx],
                                      height: 20,
                                      width: 20,
                                      colorFilter: ColorFilter.mode(
                                        idx == 1
                                            ? AppColor.amber600
                                            : AppColor.obsidian950.withValues(
                                              alpha: 0.4,
                                            ),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      options[idx],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            idx == 1
                                                ? AppColor.amber600
                                                : AppColor.obsidian950
                                                    .withValues(alpha: 0.7),
                                        fontWeight:
                                            idx == 1
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    FabButton(
                          key: _navIconKeys[index],
                          onTap: () {
                            _onTap(index);
                            setState(() {
                              iconIndex = index;
                            });
                          },
                          showRipple: iconIndex == index,
                          onHideBorder: _onHideBorder,
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            color: AppColor.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border:
                                !_onHideBorder
                                    ? null
                                    : Border.all(
                                      color: AppColor.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      width: 1,
                                    ),
                          ),
                          strokeWidth: 3,
                          index: index,
                          rippleAnimation: _rippleAnimation,
                          child: Transform.rotate(
                            angle: index == 0 ? 0 : 1.0,
                            child: SvgPicture.asset(
                              index == 0
                                  ? ImagePaths.layer
                                  : ImagePaths.mapArrow,
                              colorFilter: ColorFilter.mode(
                                AppColor.white.withValues(alpha: 0.8),
                                BlendMode.srcIn,
                              ),
                              fit: BoxFit.none,
                              height: 8,
                              width: 8,
                            ),
                          ),
                        )
                        .animate(delay: 200.ms)
                        .scale(duration: 1500.ms, curve: Curves.easeOut),
                    if (index == 0) ...[const SizedBox(height: 12)],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
