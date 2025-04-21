import 'package:flutter/material.dart';
import '../../../../core/asset/image_paths.dart';
import '../widgets/buy_rent_Info_widget.dart';
import '../widgets/estate_gallery_widget.dart';
import '../widgets/header_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandTextAnimation;
  late final Animation<double> _circleRowOpacityAnimation;
  late final Animation<double> _gallerySlideAnimation;
  final _scrollController = ScrollController();
  bool _hasPrecachedImages = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    _expandTextAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
      ),
    );

    _circleRowOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    _gallerySlideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasPrecachedImages) {
      try {
        precacheImage(AssetImage(ImagePaths.place1), context);
        precacheImage(AssetImage(ImagePaths.place2), context);
        precacheImage(AssetImage(ImagePaths.place3), context);
        precacheImage(AssetImage(ImagePaths.place4), context);
        _hasPrecachedImages = true;
      } catch (e) {
        debugPrint('Error pre-caching image: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final headerInfoHeight = maxHeight * 0.6;

          return Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Column(
                    children: [
                      HeaderWidget(
                        expandTextProgress: _expandTextAnimation.value,
                        animationController: _controller,
                      ),
                      SizedBox(
                        height:
                            _circleRowOpacityAnimation.value > 0.5 ? 18 : 20,
                      ),
                      BuyRentInfoWidget(animationController: _controller),
                    ],
                  );
                },
              ),

              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  if (_gallerySlideAnimation.value >= 1) {
                    return const SizedBox.shrink();
                  }

                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(height: headerInfoHeight - 10),
                      ),

                      SliverToBoxAdapter(
                        child: Transform.translate(
                          offset: Offset(0, _gallerySlideAnimation.value * 200),
                          child: EstateGalleryWidget(
                            animationController: _controller,
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
