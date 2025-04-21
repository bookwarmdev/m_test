import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moniepoint/core/theme/app_colors.dart';
import 'dart:ui' as ui;

class PropertyMarkerData {
  final String price;
  final LatLng latLng;

  const PropertyMarkerData({required this.price, required this.latLng});
}

class AnimatedCustomMarker extends StatefulWidget {
  final String price;
  final bool isExpanded;
  final VoidCallback onTap;

  const AnimatedCustomMarker({
    super.key,
    required this.price,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<AnimatedCustomMarker> createState() => _AnimatedCustomMarkerState();
}

class _AnimatedCustomMarkerState extends State<AnimatedCustomMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BoxDecoration get _markerDecoration => BoxDecoration(
    color: AppColor.amber600,
    borderRadius: BorderRadius.circular(widget.isExpanded ? 20 : 24),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.bottomLeft,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              alignment: Alignment.bottomLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: widget.isExpanded ? 200 : 100,
                height: widget.isExpanded ? 100 : 100,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.isExpanded ? 16 : 8,
                  vertical: 12,
                ),
                decoration: _markerDecoration,
                child:
                    widget.isExpanded
                        ? Center(
                          child: Text(
                            widget.price,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        )
                        : Center(
                          child: Icon(
                            Icons.apartment_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Method to create BitmapDescriptor from the widget state
Future<BitmapDescriptor> createMarkerBitmap({
  required String price,
  required bool isExpanded,
}) async {
  final pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = AppColor.amber600;

  // Set dimensions based on expanded state
  final double width = isExpanded ? 200 : 100;
  final double height = isExpanded ? 100 : 100;
  final double radius = isExpanded ? 20 : 24;

  // Draw the marker shape
  final Path path = Path();
  path.addRRect(
    RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, width, height),
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    ),
  );
  canvas.drawPath(path, paint);

  // Add content based on expanded state
  if (isExpanded) {
    // Add price text
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: price,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (width - textPainter.width) / 2,
        (height - textPainter.height) / 2,
      ),
    );
  } else {
    // Add icon
    const IconData icon = Icons.apartment_rounded;
    final TextPainter iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontFamily: icon.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (width - iconPainter.width) / 2,
        (height - iconPainter.height) / 2,
      ),
    );
  }

  // Convert to an image
  final img = await pictureRecorder.endRecording().toImage(
    width.toInt(),
    height.toInt(),
  );
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
