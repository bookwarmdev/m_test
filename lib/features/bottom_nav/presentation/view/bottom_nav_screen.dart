import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moniepoint/features/search_real_estate/presentation/views/search_%20real_estate_view.dart';

import '../../../../core/asset/image_paths.dart' show ImagePaths;
import '../../../home/presentation/views/home_screen.dart' show HomeScreen;
import '../widget/app_bottom_nav_bar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 2;

  static const List<Widget> _screens = [
    SearchRealEstateView(),
    SizedBox(),
    HomeScreen(),
    SizedBox(),
    SizedBox(),
  ];

  static final List<String> _navItems = [
    ImagePaths.search,
    ImagePaths.chat,
    ImagePaths.home,
    ImagePaths.heart,
    ImagePaths.profile,
  ];

  static const BoxDecoration _backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFF8F8F7),
        Color(0xFFF8F8F7),
        Color(0xFFF6DDC1),
        Color(0xFFFAD8B0),
        Color(0xFFFAD8B0),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  void _updateIndex(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _backgroundDecoration,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _screens[_currentIndex],
            Positioned(
                  bottom: 25,
                  left: 50,
                  right: 50,
                  child: AppBottomNavBar(
                    icons: _navItems,
                    onClick: _updateIndex,
                    initialIndex: _currentIndex,
                  ),
                )
                .animate(delay: 4200.ms)
                .slideY(
                  duration: 800.ms,
                  begin: 1.3,
                  end: 0,
                  curve: Curves.linear,
                ),
          ],
        ),
      ),
    );
  }
}
