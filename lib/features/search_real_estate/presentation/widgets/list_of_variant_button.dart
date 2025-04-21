import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moniepoint/core/theme/app_colors.dart';

class ListOfVariantButton extends StatelessWidget {
  const ListOfVariantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.12,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 35),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColor.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    color: AppColor.white.withValues(alpha: 0.8),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'List of variants',
                    style: TextStyle(
                      color: AppColor.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate(delay: 200.ms).scale(duration: 1400.ms, curve: Curves.easeOut);
  }
}
