import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moniepoint/core/extensions/string_extensions.dart';
import 'package:moniepoint/features/search_real_estate/presentation/widgets/list_of_variant_button.dart';
import 'dart:ui' as ui;

import '../../../../core/theme/app_colors.dart';
import '../widgets/map_actions_fab.dart';
import '../widgets/map_custome_marker.dart';
import '../widgets/search_input_field.dart' show SearchInputField;

class SearchRealEstateView extends StatefulWidget {
  const SearchRealEstateView({super.key});

  @override
  State<SearchRealEstateView> createState() => _SearchRealEstateViewState();
}

class _SearchRealEstateViewState extends State<SearchRealEstateView>
    with SingleTickerProviderStateMixin {
  final _controller = Completer<GoogleMapController>();
  late AnimationController _animationController;
  bool _isExpanded = true;
  Set<Marker> _markers = {};

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13,
  );

  static String? _cachedDarkMapStyle;

  static final List<PropertyMarkerData> _defaultMarkerData = [
    PropertyMarkerData(price: '10,3 mn ₽', latLng: LatLng(37.435, -122.095)),
    PropertyMarkerData(price: '11 mn ₽', latLng: LatLng(37.428, -122.075)),
    PropertyMarkerData(price: '13,3 mn ₽', latLng: LatLng(37.415, -122.1)),
    PropertyMarkerData(price: '7,8 mn ₽', latLng: LatLng(37.438, -122.06)),
    PropertyMarkerData(price: '8,5 mn ₽', latLng: LatLng(37.412, -122.07)),
    PropertyMarkerData(price: '6,95 mn ₽', latLng: LatLng(37.405, -122.090)),
  ];

  Future<void> _initializeMapStyle() async {
    _cachedDarkMapStyle ??= await rootBundle.loadString("map_style".json);
  }

  void _initializeAnimationController() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
      reverseDuration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
      setState(() => _isExpanded = status != AnimationStatus.dismissed);
      _updateMarkers();
    });
  }

  Future<void> _updateMarkers() async {
    Set<Marker> newMarkers = {};

    for (int i = 0; i < _defaultMarkerData.length; i++) {
      final data = _defaultMarkerData[i];

      newMarkers.add(
        Marker(
          markerId: MarkerId('marker_$i'),
          position: data.latLng,
          icon: await createMarkerBitmap(
            price: data.price,
            isExpanded: _isExpanded,
          ),
          anchor: Offset(0.1, 1.0),
        ),
      );
    }

    setState(() {
      _markers = newMarkers;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimationController();
    _initializeMapStyle().then((_) {
      _updateMarkers();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildGoogleMap(),
          const ListOfVariantButton(),
          _buildMapActionsFab(),
          SearchInputField(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCameraPosition,
      style: _cachedDarkMapStyle,
      compassEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        if (_cachedDarkMapStyle != null) {
          controller.setMapStyle(_cachedDarkMapStyle);
        }
      },
    );
  }

  Widget _buildMapActionsFab() {
    return Positioned(
      left: 30,
      bottom: MediaQuery.of(context).size.height * 0.12,
      child: MapActionsFab(animationController: _animationController),
    );
  }
}
