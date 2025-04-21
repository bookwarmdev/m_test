import 'package:flutter/material.dart';
import 'package:moniepoint/core/asset/image_paths.dart';
import 'package:moniepoint/core/theme/app_colors.dart';
import 'place_card_widget.dart';

class EstateGalleryWidget extends StatelessWidget {
  const EstateGalleryWidget({super.key, required this.animationController});

  final AnimationController animationController;

  static const _containerPadding = 6.0;
  static const _topPlaceHeightFactor = 0.22;
  static const _leftPlaceHeightFactor = 0.4;
  static const _rightPlaceHeightFactor = 0.195;
  static const _spacingBetweenPlaces = 10.0;
  static const _rightColumnSpacingFactor = 0.01;
  static const _containerBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  @override
  Widget build(BuildContext context) {
    const rowPlaceWidthFactor = 0.45;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(_containerPadding),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: _containerBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlaceCard(
            context,
            "Gladkova St., 25",
            _topPlaceHeightFactor,
            1.0,
            ImagePaths.place2,
          ),
          const SizedBox(height: _spacingBetweenPlaces),
          Row(
            children: [
              Expanded(
                child: _buildPlaceCard(
                  context,
                  "Trefoleva St., 43",
                  _leftPlaceHeightFactor,
                  rowPlaceWidthFactor,
                  ImagePaths.place3,
                ),
              ),
              const SizedBox(width: _spacingBetweenPlaces),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPlaceCard(
                      context,
                      "Gubina St., 11",
                      _rightPlaceHeightFactor,
                      rowPlaceWidthFactor,
                      ImagePaths.place4,
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height *
                          _rightColumnSpacingFactor,
                    ),
                    _buildPlaceCard(
                      context,
                      "Sedova St., 22",
                      _rightPlaceHeightFactor,
                      rowPlaceWidthFactor,
                      ImagePaths.place1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(
    BuildContext context,
    String title,
    double heightFactor,
    double sliderWidth,
    String image,
  ) {
    return PlaceCardWidget(
      text: title,
      imgHeight: MediaQuery.of(context).size.height * heightFactor,
      imgPath: image,
      sliderWidth: sliderWidth,
      animationController: animationController,
    );
  }
}
