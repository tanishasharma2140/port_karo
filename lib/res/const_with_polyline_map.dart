import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:port_karo/res/constant_color.dart';

class ConstWithPolylineMap extends StatefulWidget {
  final double? height;
  final ValueChanged<String>? onAddressFetched;
  final List<Map<String, dynamic>>? data;
  final int? rideStatus;
  final bool? backIconAllowed;

  const ConstWithPolylineMap({
    super.key,
    this.height,
    this.onAddressFetched,
    this.data,
    this.rideStatus,
    this.backIconAllowed = true,
  });

  @override
  State<ConstWithPolylineMap> createState() => _ConstWithPolylineMapState();
}

class _ConstWithPolylineMapState extends State<ConstWithPolylineMap> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = LatLng(26.8467, 80.9462);
  LatLng? _currentPosition;
  Marker? _currentLocationMarker;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _addBookingMarkers();
  }

  @override
  void didUpdateWidget(ConstWithPolylineMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rideStatus != widget.rideStatus || oldWidget.data != widget.data) {
      _updatePolylinesBasedOnStatus();
    }
  }

  /// Get current device location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);

    _currentLocationMarker = Marker(
      markerId: MarkerId("currentLocation"),
      position: _currentPosition!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: "You are here"),
    );

    setState(() {
      _markers.add(_currentLocationMarker!);
    });

    _fetchAddress(position.latitude, position.longitude);

    if (widget.data != null && widget.data!.isNotEmpty) {
      _drawPolylinesBasedOnStatus(widget.data!.first);
    }

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition!, zoom: 15),
      ));
    }
  }

  /// Fetch address from latitude & longitude
  Future<void> _fetchAddress(double latitude, double longitude) async {
    const String apiKey = 'AIzaSyANhzkw-SjvdzDvyPsUBDFmvEHfI9b8QqA';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final address = data['results'][0]['formatted_address'];
          widget.onAddressFetched?.call(address);
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch address: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching address: $e');
    }
  }

  /// Convert address to LatLng
  Future<LatLng?> _getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      if (kDebugMode) print('Error converting address to LatLng: $e');
    }
    return null;
  }

  /// Fetch route points from Google Directions API
  Future<List<LatLng>> _getRoutePoints(LatLng origin, LatLng destination) async {
    const String apiKey = 'AIzaSyANhzkw-SjvdzDvyPsUBDFmvEHfI9b8QqA';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final polyline = data['routes'][0]['overview_polyline']['points'];
          return _decodePolyline(polyline);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching route points: $e');
    }
    return [];
  }

  /// Decode Google Polyline string
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return polyline;
  }

  /// ✅ SAFE DOUBLE CONVERSION METHOD
  double? _safeToDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.tryParse(value);
      } catch (e) {
        print("❌ Error converting string to double: $value");
        return null;
      }
    }
    return null;
  }

  /// ✅ SAFE INT CONVERSION METHOD
  int? _safeToInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.tryParse(value);
      } catch (e) {
        print("❌ Error converting string to int: $value");
        return null;
      }
    }
    return null;
  }

  /// Ride status ke hisaab se polyline update karo
  void _updatePolylinesBasedOnStatus() {
    if (widget.data == null || widget.data!.isEmpty) return;
    final booking = widget.data!.first;
    _drawPolylinesBasedOnStatus(booking);
  }

  /// Status ke hisaab se polyline draw karo
  Future<void> _drawPolylinesBasedOnStatus(Map<String, dynamic> booking) async {
    // Clear existing polylines
    _polylines.clear();

    if (widget.rideStatus == null) return;

    LatLng? pickupLatLng;
    LatLng? dropLatLng;

    // ✅ SAFE COORDINATES EXTRACTION
    final pickupLat = _safeToDouble(booking['pickup_latitute']);
    final pickupLng = _safeToDouble(booking['pick_longitude']);
    final dropLat = _safeToDouble(booking['drop_latitute']);
    final dropLng = _safeToDouble(booking['drop_logitute']);

    print("📍 Pickup Coordinates - Lat: $pickupLat, Lng: $pickupLng");
    print("📍 Drop Coordinates - Lat: $dropLat, Lng: $dropLng");

    // Get pickup coordinates - SAFE WAY
    if (pickupLat != null && pickupLng != null) {
      pickupLatLng = LatLng(pickupLat, pickupLng);
    } else if (booking['pickup_address'] != null) {
      pickupLatLng = await _getLatLngFromAddress(booking['pickup_address'].toString());
    }

    // Get drop coordinates - SAFE WAY
    if (dropLat != null && dropLng != null) {
      dropLatLng = LatLng(dropLat, dropLng);
    } else if (booking['drop_address'] != null) {
      dropLatLng = await _getLatLngFromAddress(booking['drop_address'].toString());
    }

    print("📍 Ride Status: ${widget.rideStatus}");
    print("📍 Current Position: $_currentPosition");
    print("📍 Pickup LatLng: $pickupLatLng");
    print("📍 Drop LatLng: $dropLatLng");

    // ✅ RIDE STATUS 1-4: DRIVER CURRENT LOCATION SE PICKUP TAK POLYLINE
    if (widget.rideStatus! >= 1 && widget.rideStatus! <= 4 && _currentPosition != null && pickupLatLng != null) {
      print("🔄 Drawing Driver Current Location → Pickup Polyline");
      List<LatLng> routeToPickup = await _getRoutePoints(_currentPosition!, pickupLatLng);
      if (routeToPickup.isNotEmpty) {
        _polylines.add(Polyline(
          polylineId: PolylineId("driver_to_pickup"),
          points: routeToPickup,
          color: PortColor.gold,
          width: 5,
        ));

        // Camera position update karo - driver aur pickup dikhaye
        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                _currentPosition!.latitude < pickupLatLng.latitude ? _currentPosition!.latitude : pickupLatLng.latitude,
                _currentPosition!.longitude < pickupLatLng.longitude ? _currentPosition!.longitude : pickupLatLng.longitude,
              ),
              northeast: LatLng(
                _currentPosition!.latitude > pickupLatLng.latitude ? _currentPosition!.latitude : pickupLatLng.latitude,
                _currentPosition!.longitude > pickupLatLng.longitude ? _currentPosition!.longitude : pickupLatLng.longitude,
              ),
            ),
            100.0,
          ));
        }
      }
    }

    // ✅ RIDE STATUS 5+: PICKUP SE DROP TAK POLYLINE
    if (widget.rideStatus! >= 5 && pickupLatLng != null && dropLatLng != null) {
      print("🔄 Drawing Pickup → Drop Polyline (Status 5+)");
      List<LatLng> routeToDrop = await _getRoutePoints(pickupLatLng, dropLatLng);
      if (routeToDrop.isNotEmpty) {
        _polylines.add(Polyline(
          polylineId: PolylineId("pickup_to_drop"),
          points: routeToDrop,
          color: Colors.green,
          width: 5,
        ));

        // Camera position update karo - pickup aur drop dikhaye
        if (mapController != null) {
          mapController!.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                pickupLatLng.latitude < dropLatLng.latitude ? pickupLatLng.latitude : dropLatLng.latitude,
                pickupLatLng.longitude < dropLatLng.longitude ? pickupLatLng.longitude : dropLatLng.longitude,
              ),
              northeast: LatLng(
                pickupLatLng.latitude > dropLatLng.latitude ? pickupLatLng.latitude : dropLatLng.latitude,
                pickupLatLng.longitude > dropLatLng.longitude ? pickupLatLng.longitude : dropLatLng.longitude,
              ),
            ),
            100.0,
          ));
        }
      }
    }

    setState(() {});
  }

  /// Sirf markers add karo, polyline alag se banega
  Future<void> _addBookingMarkers() async {
    if (widget.data == null || widget.data!.isEmpty) return;

    for (var booking in widget.data!) {
      LatLng? pickupLatLng;
      LatLng? dropLatLng;

      // ✅ SAFE COORDINATES EXTRACTION FOR MARKERS
      final pickupLat = _safeToDouble(booking['pickup_latitute']);
      final pickupLng = _safeToDouble(booking['pick_longitude']);
      final dropLat = _safeToDouble(booking['drop_latitute']);
      final dropLng = _safeToDouble(booking['drop_logitute']);

      // Pickup LatLng - SAFE WAY
      if (pickupLat != null && pickupLng != null) {
        pickupLatLng = LatLng(pickupLat, pickupLng);
      } else if (booking['pickup_address'] != null) {
        pickupLatLng = await _getLatLngFromAddress(booking['pickup_address'].toString());
      }

      // Drop LatLng - SAFE WAY
      if (dropLat != null && dropLng != null) {
        dropLatLng = LatLng(dropLat, dropLng);
      } else if (booking['drop_address'] != null) {
        dropLatLng = await _getLatLngFromAddress(booking['drop_address'].toString());
      }

      // Add pickup marker
      if (pickupLatLng != null) {
        _markers.add(Marker(
          markerId: MarkerId("pickup_${booking['id']}"),
          position: pickupLatLng,
          infoWindow: InfoWindow(title: "Pickup Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ));
      }

      // Add drop marker
      if (dropLatLng != null) {
        _markers.add(Marker(
          markerId: MarkerId("drop_${booking['id']}"),
          position: dropLatLng,
          infoWindow: InfoWindow(title: "Drop Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }

      // ✅ ADD DRIVER LOCATION MARKER IF RIDE STATUS >= 1
      if (widget.rideStatus != null && widget.rideStatus! >= 1 && _currentPosition != null) {
        _markers.add(Marker(
          markerId: MarkerId("driver_location"),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: "Driver Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));
      }
    }

    // Initial polyline status ke hisaab se draw karo
    if (widget.data!.isNotEmpty) {
      _drawPolylinesBasedOnStatus(widget.data!.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height ?? MediaQuery.of(context).size.height,
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (_currentPosition != null) {
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPosition!, zoom: 12),
                ));
              }
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 10,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            markers: _markers,
            polylines: _polylines,
          ),
        ),
        if (widget.backIconAllowed == true)
          Positioned(
            top: 40.0,
            left: 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }
}