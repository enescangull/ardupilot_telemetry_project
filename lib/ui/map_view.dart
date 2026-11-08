import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double heading;
  const MapView({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.heading,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = MapController();
  bool _follow = true;
  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    if ((widget.latitude != oldWidget.latitude ||
            widget.longitude != oldWidget.longitude) &&
        _follow == true) {
      LatLng center = LatLng(widget.latitude, widget.longitude);
      _controller.move(center, _controller.camera.zoom);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: LatLng(widget.latitude, widget.longitude),
            initialZoom: 17,
            onPositionChanged: (camera, hasGesture) {
              if (hasGesture) {
                setState(() {
                  _follow = false;
                });
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.enes.gcs',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 44,
                  height: 44,
                  point: LatLng(widget.latitude, widget.longitude),
                  child: DroneIcon(heading: widget.heading),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        if (!_follow)
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {
                setState(() {
                  _follow = true;
                  _controller.move(
                    LatLng(widget.latitude, widget.longitude),
                    _controller.camera.zoom,
                  );
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.navigation_sharp),
                  Text('Center', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class DroneIcon extends StatelessWidget {
  const DroneIcon({super.key, required this.heading});

  final double heading;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: heading * pi / 180,
      child: Icon(Icons.navigation_sharp, color: Colors.red),
    );
  }
}
