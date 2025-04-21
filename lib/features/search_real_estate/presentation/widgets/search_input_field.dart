import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/asset/image_paths.dart';
import '../../../../core/theme/app_colors.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({super.key});

  static const _padding = EdgeInsets.symmetric(horizontal: 35);
  static final _borderRadius = BorderRadius.circular(40);
  static const _animationDuration = Duration(milliseconds: 1210);
  static const _animationDelay = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topOffset = MediaQuery.of(context).size.height * 0.08;

    return Positioned(
      top: topOffset,
      width: screenWidth,
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            _buildSearchField(context)
                .animate(delay: _animationDelay)
                .fade(duration: _animationDuration)
                .scale(duration: _animationDuration, curve: Curves.easeOut),
            const SizedBox(width: 10),
            _buildFilterButton()
                .animate(delay: _animationDelay)
                .fade(duration: _animationDuration)
                .scale(duration: _animationDuration, curve: Curves.easeOut),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(context) {
    return Flexible(
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColor.obsidian950,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Saint Petersburg',
            fillColor: AppColor.white,
            filled: true,
            prefixIcon: SvgPicture.asset(
              ImagePaths.mapSearch,
              height: 30,
              width: 30,
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 45,
              minHeight: 30,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: AppColor.white,
      child: SvgPicture.asset(
        ImagePaths.filter,
        height: 18,
        colorFilter: ColorFilter.mode(AppColor.obsidian950, BlendMode.srcIn),
      ),
    );
  }
}
