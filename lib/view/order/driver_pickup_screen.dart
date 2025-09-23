import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:port_karo/res/app_fonts.dart';

class DriverPickupScreen extends StatefulWidget {
  const DriverPickupScreen({super.key});

  @override
  _DriverPickupScreenState createState() => _DriverPickupScreenState();
}

class _DriverPickupScreenState extends State<DriverPickupScreen> with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints(apiKey: 'AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI');
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Sample coordinates
  static const LatLng sourceLocation = LatLng(26.8467, 80.9462);
  static const LatLng destination = LatLng(26.8500, 80.9500);

  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  bool _isPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    setCustomMapPin();
    getPolyline();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<double>(
      begin: 0.45,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _togglePanel() {
    setState(() {
      _isPanelExpanded = !_isPanelExpanded;
      if (_isPanelExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void setCustomMapPin() async {
    sourceIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  }

  void getPolyline() async {
    polylineCoordinates = [
      sourceLocation,
      const LatLng(26.8470, 80.9470),
      const LatLng(26.8480, 80.9480),
      const LatLng(26.8490, 80.9490),
      destination
    ];
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color(0xFF3366FF),
      points: polylineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              // Map Section
              Positioned.fill(
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: sourceLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  markers: _buildMapMarkers(),
                  polylines: Set<Polyline>.of(polylines.values),
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),

              // Gradient Overlay at top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Header Section
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Back Button
                      _buildGlassButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      // Time Indicator
                      _buildTimeIndicator(),
                      const Spacer(),
                      // Refresh Button
                      _buildGlassButton(
                        icon: Icons.refresh_rounded,
                        onTap: () => getPolyline(),
                      ),
                    ],
                  ),
                ),
              ),

              // Driver Floating Card
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 16,
                child: _buildDriverFloatingCard(),
              ),

              // Bottom Details Panel
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomPanel(),
              ),
            ],
          );
        },
      ),
    );
  }

  Set<Marker> _buildMapMarkers() {
    return {
      Marker(
        markerId: const MarkerId('source'),
        position: sourceLocation,
        icon: sourceIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Pickup Location'),
        anchor: const Offset(0.5, 0.5),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: destination,
        icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Destination'),
        anchor: const Offset(0.5, 0.5),
      ),
      Marker(
        markerId: const MarkerId('driver'),
        position: const LatLng(26.8480, 80.9470),
        icon: driverIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Driver - Vikash Mishra'),
        rotation: 45,
        anchor: const Offset(0.5, 0.5),
      ),
    };
  }

  Widget _buildGlassButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.black87),
        onPressed: onTap,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildTimeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time_rounded, size: 16, color: Colors.orange[700]),
          const SizedBox(width: 4),
          Text(
            '15 min',
            style: TextStyle(
              fontFamily: AppFonts.poppinsReg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverFloatingCard() {
    return AnimatedOpacity(
      opacity: _fadeAnimation.value,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Driver Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                ),
              ),
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            // Driver Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vikash Mishra',
                  style: TextStyle(
                    fontFamily: AppFonts.kanitReg,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Tata Ace · UP-32-RN-8677',
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsReg,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: MediaQuery.of(context).size.height * _slideAnimation.value,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: GestureDetector(
                  onTap: _togglePanel,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Trip Progress
              _buildTripProgress(),
              const SizedBox(height: 24),

              // Customer Info Section
              _buildCustomerInfo(),
              const SizedBox(height: 24),

              // Payment Section
              _buildPaymentSection(),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip in Progress',
          style: TextStyle(
            fontFamily: AppFonts.kanitReg,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 0.3,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Text(
          'Approximately 15 minutes remaining',
          style: TextStyle(
            fontFamily: AppFonts.poppinsReg,
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Pickup Location
          _buildLocationRow(
            icon: Icons.location_on_rounded,
            iconColor: Colors.red[400]!,
            title: 'Niranjan Sharma · 8423953286',
            subtitle: 'Naya Khera, Jankipuram Extension, Lucknow, Kh...',
            showEdit: true,
          ),
          const SizedBox(height: 12),
          // Divider
          Container(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 12),
          // Dropoff Location
          _buildLocationRow(
            icon: Icons.location_on_rounded,
            iconColor: Colors.green[400]!,
            title: 'hello · 9632586963',
            subtitle: 'nirah nir, Lucknow, Uttar Pradesh, India',
            showEdit: false,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool showEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsReg,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsReg,
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          Text(
            'Edit',
            style: TextStyle(
              fontFamily: AppFonts.poppinsReg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue[600]!,
            ),
          ),
      ],
    );
  }

  Widget _buildAddStopsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.add_road_rounded, color: Colors.blue[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Add Stops',
                style: TextStyle(
                  fontFamily: AppFonts.poppinsReg,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600]!,
                ),
              ),
            ],
          ),
          Text(
            'View Details',
            style: TextStyle(
              fontFamily: AppFonts.poppinsReg,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue[600]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment',
                style: TextStyle(
                  fontFamily: AppFonts.kanitReg,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Text(
                  'Cash',
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsReg,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹677',
                style: TextStyle(
                  fontFamily: AppFonts.kanitReg,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.green[600]!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 16, color: Colors.amber[700]),
                const SizedBox(width: 4),
                Text(
                  'You\'ll receive 12 coins on this order!',
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsReg,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber[700]!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Facing issue in this order? ',
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsReg,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                TextSpan(
                  text: 'Contact Support',
                  style: TextStyle(
                    fontFamily: AppFonts.poppinsReg,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600]!,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.red[400]!, Colors.red[600]!],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _showCancelDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel Trip',
              style: TextStyle(
                fontFamily: AppFonts.poppinsReg,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return _buildCancellationBottomSheet();
      },
    );
  }

  Widget _buildCancellationBottomSheet() {
    String? selectedReason;
    String additionalComments = '';

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'UP-32-RN-8677',
                        style: TextStyle(
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please choose a reason for cancellation 😊',
                        style: TextStyle(
                          fontFamily: AppFonts.poppinsReg,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Wrong/Inappropriate Vehicle',
                        title: 'Wrong/Inappropriate Vehicle',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Wrong/Inappropriate Vehicle' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'My reason is not listed',
                        title: 'My reason is not listed',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'My reason is not listed' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Driver asked me to cancel',
                        title: 'Driver asked me to cancel',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Driver asked me to cancel' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Changed my mind',
                        title: 'Changed my mind',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Changed my mind' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Driver issue - delaying to come',
                        title: 'Driver issue - delaying to come',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Driver issue - delaying to come' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Unable to contact driver',
                        title: 'Unable to contact driver',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Unable to contact driver' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Expected a shorter arrival time',
                        title: 'Expected a shorter arrival time',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Expected a shorter arrival time' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Driver asking for extra money',
                        title: 'Driver asking for extra money',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Driver asking for extra money' : null;
                          // });
                        },
                      ),

                      _buildReasonCheckbox(
                        value: selectedReason == 'Driver not moving',
                        title: 'Driver not moving',
                        onChanged: (value) {
                          // setState(() {
                          //   selectedReason = value ? 'Driver not moving' : null;
                          // });
                        },
                      ),

                    ],
                  ),
                ),
              ),

              // Bottom Buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Go Back',
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsReg,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedReason == null
                            ? null
                            : () {
                          _submitCancellation(
                              selectedReason!, additionalComments);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedReason == null
                              ? Colors.grey[400]
                              : Colors.red[500],
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: AppFonts.poppinsReg,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )

              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReasonCheckbox({
    required bool value,
    required String title,
    required Function(bool?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? Colors.red[400]! : Colors.grey[400]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              color: value ? Colors.red[400] : Colors.transparent,
            ),
            child: value
                ? const Icon(
              Icons.check,
              size: 16,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.poppinsReg,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCancellation(String reason, String comments) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trip cancellation submitted',
          style: TextStyle(fontFamily: AppFonts.poppinsReg),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}