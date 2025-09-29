import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/res/custom_text_field.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view_model/order_view_model.dart';
import 'package:port_karo/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class SenderAddress extends StatefulWidget {
  final String selectedLocation;
  final LatLng selectedLatLng;

  const SenderAddress({
    super.key,
    required this.selectedLocation,
    required this.selectedLatLng,
  });

  @override
  State<SenderAddress> createState() => _SenderAddressState();
}

class _SenderAddressState extends State<SenderAddress> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  late String selectedLocation;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  bool isContactDetailsSelected = false;
  bool isFullscreenMode = false;
  bool isLoadingAddress = false;

  static const LatLng defaultPosition = LatLng(26.8467, 80.9462);
  LatLng selectedLatLng = defaultPosition;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
    selectedLatLng = widget.selectedLatLng;
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (isLoadingAddress) return;

    setState(() {
      isLoadingAddress = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          selectedLocation = _formatAddress(place);
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      if (mounted) {
        Utils.showErrorMessage(context, "Could not fetch address details");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  String _formatAddress(Placemark place) {
    List<String> addressParts = [];
    if (place.street?.isNotEmpty ?? false) addressParts.add(place.street!);
    if (place.locality?.isNotEmpty ?? false) addressParts.add(place.locality!);
    if (place.subLocality?.isNotEmpty ?? false) addressParts.add(place.subLocality!);
    if (place.administrativeArea?.isNotEmpty ?? false) addressParts.add(place.administrativeArea!);
    if (place.postalCode?.isNotEmpty ?? false) addressParts.add(place.postalCode!);
    if (place.country?.isNotEmpty ?? false) addressParts.add(place.country!);

    return addressParts.isNotEmpty ? addressParts.join(", ") : "Unknown Location";
  }

  bool _isValidMobileNumber(String mobile) {
    return mobile.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(mobile);
  }

  void _confirmLocation(OrderViewModel orderViewModel) {
    if (nameController.text.trim().isEmpty) {
      Utils.showErrorMessage(context, "Please enter sender's name");
      return;
    }

    if (!_isValidMobileNumber(mobileController.text.trim())) {
      Utils.showErrorMessage(context, "Please enter a valid 10-digit mobile number");
      return;
    }

    final data = {
      "address": selectedLocation,
      "name": nameController.text.trim(),
      "phone": mobileController.text.trim(),
      "latitude": selectedLatLng.latitude,
      "longitude": selectedLatLng.longitude,
    };

    orderViewModel.setLocationData(data);

    // Pop twice to go back to previous screen
    Navigator.pop(context, data);
  }

  void _changeLocation() {
    // TODO: Implement location change functionality
    // This could open a search dialog or navigate to location search screen
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLatLng,
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _controller.complete(controller);
              mapController = controller;
            },
            onCameraMove: (position) {
              // Update the marker position when camera moves (dragging)
              setState(() {
                selectedLatLng = position.target;
              });
            },
            onCameraIdle: () async {
              // Fetch address when dragging stops
              await _getAddressFromLatLng(selectedLatLng);
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: selectedLatLng,
                draggable: false,
                infoWindow: InfoWindow(
                  title: "Selected Location",
                  snippet: selectedLocation,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            },
            myLocationEnabled: false, // Disabled current location
            myLocationButtonEnabled: false, // Disabled current location button
            zoomControlsEnabled: false,
          ),

          // Back Button
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.04,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(screenHeight * 0.015),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PortColor.white,
                  boxShadow: [
                    BoxShadow(
                      color: PortColor.gray.withOpacity(0.9),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: screenHeight * 0.025,
                  color: PortColor.black,
                ),
              ),
            ),
          ),

          // Fullscreen Toggle Button
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.04,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFullscreenMode = !isFullscreenMode;
                });
              },
              child: Container(
                width: screenHeight * 0.05,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: PortColor.white,
                  boxShadow: [
                    BoxShadow(
                      color: PortColor.gray.withOpacity(0.9),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  isFullscreenMode ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: screenHeight * 0.03,
                  color: PortColor.black,
                ),
              ),
            ),
          ),

          // Bottom Sheet or Small Location Details based on fullscreen mode
          if (!isFullscreenMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildBottomSheet(context),
            ),

          if (isFullscreenMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildLocationDetailsSmall(context),
            ),
        ],
      ),
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLocationDetails(),
                SizedBox(height: screenHeight * 0.03),

                // Time Selection Section
                _buildTimeSelectionSection(),
                SizedBox(height: screenHeight * 0.03),

                CustomTextField(
                  controller: nameController,
                  height: screenHeight * 0.055,
                  cursorHeight: screenHeight * 0.023,
                  labelText: "Sender's Name",
                  suffixIcon: const Icon(
                    Icons.perm_contact_cal_outlined,
                    color: PortColor.blue,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                CustomTextField(
                  controller: mobileController,
                  height: screenHeight * 0.055,
                  cursorHeight: screenHeight * 0.023,
                  labelText: "Sender's Mobile Number",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isContactDetailsSelected = !isContactDetailsSelected;
                      if (isContactDetailsSelected) {
                        mobileController.text = profileViewModel
                            .profileModel!.data!.phone
                            .toString();
                      } else {
                        mobileController.clear();
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        height: screenHeight * 0.025,
                        width: screenWidth * 0.056,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: PortColor.blue,
                            width: screenWidth * 0.004,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: isContactDetailsSelected
                              ? PortColor.blue
                              : Colors.transparent,
                        ),
                        child: isContactDetailsSelected
                            ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: screenHeight * 0.02,
                        )
                            : null,
                      ),
                      SizedBox(width: screenWidth * 0.028),
                      Row(
                        children: [
                          TextConst(
                            title: "Use My Mobile Number:",
                            color: PortColor.black,
                            fontFamily: AppFonts.poppinsReg,
                            size: 12,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          TextConst(
                            title: profileViewModel.profileModel!.data!.phone
                                .toString(),
                            color: PortColor.blue,
                            fontFamily: AppFonts.poppinsReg,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                TextConst(
                  title: "Save as (optional):",
                  color: PortColor.gray,
                  size: 12,
                  fontFamily: AppFonts.poppinsReg,
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildSaveOption("Home", Icons.home_filled),
                    buildSaveOption("Shop", null, Assets.assetsShop),
                    buildSaveOption("Other", Icons.favorite),
                  ],
                ),
              ],
            ),
          ),
          buildProceedButton(context),
        ],
      ),
    );
  }

// Add these variables to your state class
  bool _isNowSelected = true;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Widget _buildTimeSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextConst(
          title: "Pickup Time",
          color: PortColor.black,
          fontFamily: AppFonts.poppinsReg,
          size: 16,
        ),
        SizedBox(height: screenHeight * 0.015),

        // Radio Buttons for Now/Later
        Row(
          children: [
            _buildTimeRadioButton("Now", true),
            SizedBox(width: screenWidth * 0.08),
            _buildTimeRadioButton("Later", false),
          ],
        ),
        SizedBox(height: screenHeight * 0.02),

        // Date and Time Pickers (only show when Later is selected)
        if (!_isNowSelected) _buildDateTimePickers(),
      ],
    );
  }

  Widget _buildTimeRadioButton(String title, bool isNow) {
    bool isSelected = _isNowSelected == isNow;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isNowSelected = isNow;
          if (isNow) {
            _selectedDate = null;
            _selectedTime = null;
          }
        });
      },
      child: Row(
        children: [
          Container(
            width: screenHeight * 0.024,
            height: screenHeight * 0.024,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? PortColor.blue : PortColor.gray,
                width: 2,
              ),
              color: isSelected ? PortColor.blue : Colors.transparent,
            ),
            child: isSelected
                ? Icon(
              Icons.circle,
              color: Colors.white,
              size: screenHeight * 0.012,
            )
                : null,
          ),
          SizedBox(width: screenWidth * 0.02),
          TextConst(
            title: title,
            color: isSelected ? PortColor.blue : PortColor.gray,
            fontFamily: AppFonts.poppinsReg,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        // Date Picker
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            height: screenHeight * 0.055,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            decoration: BoxDecoration(
              border: Border.all(color: PortColor.gray),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: PortColor.blue,
                  size: screenHeight * 0.02,
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: TextConst(
                    title: _selectedDate == null
                        ? "Select Date"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    color: _selectedDate == null ? PortColor.gray : PortColor.black,
                    fontFamily: AppFonts.poppinsReg,
                    size: 14,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: PortColor.gray,
                  size: screenHeight * 0.025,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

        // Time Picker
        GestureDetector(
          onTap: _selectTime,
          child: Container(
            height: screenHeight * 0.055,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            decoration: BoxDecoration(
              border: Border.all(color: PortColor.gray),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: PortColor.blue,
                  size: screenHeight * 0.02,
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: TextConst(
                    title: _selectedTime == null
                        ? "Select Time"
                        : "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                    color: _selectedTime == null ? PortColor.gray : PortColor.black,
                    fontFamily: AppFonts.poppinsReg,
                    size: 14,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: PortColor.gray,
                  size: screenHeight * 0.025,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: PortColor.blue,
            colorScheme: const ColorScheme.light(primary: PortColor.blue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: PortColor.blue,
            colorScheme: const ColorScheme.light(primary: PortColor.blue),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    buildProceedButton(context);

  }

  Widget buildLocationDetailsSmall(BuildContext context) {
    return Container(
      height: screenHeight * 0.2,
      width: screenWidth,
      decoration: const BoxDecoration(
        color: PortColor.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: const AssetImage(Assets.assetsLocation),
                  height: screenHeight * 0.035,
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: selectedLocation,
                        color: PortColor.black,
                        fontFamily: AppFonts.poppinsReg,
                        size: 13,
                      ),
                      SizedBox(height: screenHeight * 0.007),
                      if (isLoadingAddress)
                        SizedBox(
                          height: screenHeight * 0.006,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                LinearProgressIndicator(
                                  value: 0.6,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: const AlwaysStoppedAnimation(Colors.transparent), // transparent
                                ),
                                Positioned.fill(
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return  LinearGradient(
                                        colors: [PortColor.yellowDiff, PortColor.yellowAccent],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.srcIn,
                                    child: Container(
                                      color: Colors.white, // color is ignored, shader will override
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )


                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: screenHeight * 0.086,
            decoration: BoxDecoration(
              color: PortColor.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.017,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFullscreenMode = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.055,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: PortColor.subBtn,
                  ),
                  child: TextConst(
                    title: "Confirm Pickup Location",
                    color: Colors.black,
                    fontFamily: AppFonts.kanitReg,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLocationDetails() {
    return Row(
      children: [
        Image(
          image: const AssetImage(Assets.assetsLocation),
          height: screenHeight * 0.035,
        ),
        SizedBox(width: screenWidth * 0.009),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextConst(
                title: selectedLocation,
                color: PortColor.black,
                fontFamily: AppFonts.poppinsReg,
                size: 13,
              ),
              SizedBox(height: screenHeight * 0.005),
              if (isLoadingAddress)
                SizedBox(
                  height: screenHeight * 0.02,
                  child: const LinearProgressIndicator(),
                ),
            ],
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        GestureDetector(
          onTap: _changeLocation,
          child: Container(
            height: screenHeight * 0.038,
            width: screenWidth * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: PortColor.gray),
            ),
            child: Center(
              child: TextConst(
                title: "Change",
                color: PortColor.blue,
                fontFamily: AppFonts.poppinsReg,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSaveOption(String label, IconData? icon, [String? asset]) {
    return Container(
      width: screenWidth * 0.25,
      height: screenHeight * 0.036,
      decoration: BoxDecoration(
        border: Border.all(color: PortColor.gray),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: PortColor.black,
              size: screenHeight * 0.02,
            ),
          if (asset != null)
            Image(
              image: AssetImage(asset),
              height: screenHeight * 0.02,
            ),
          SizedBox(width: screenWidth * 0.01),
          TextConst(
            title: label,
            color: PortColor.black,
            fontFamily: AppFonts.poppinsReg,
            size: 12,
          ),
        ],
      ),
    );
  }

  Widget buildProceedButton(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);

    bool isMobileNumberFilled =
        mobileController.text.isNotEmpty && mobileController.text.length == 10;
    return Container(
      height: screenHeight * 0.09,
      decoration: BoxDecoration(
        color: PortColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.017,
        ),
        child: GestureDetector(
          onTap: () {
            if (nameController.text.isEmpty) {
              Utils.showErrorMessage(context, "Enter sender's name");
            } else if (mobileController.text.isEmpty) {
              Utils.showErrorMessage(context, "Enter sender's mobile number");
            } else {
              final data = {
                "address": selectedLocation,
                "name": nameController.text,
                "phone": mobileController.text,
                " latitude": selectedLatLng.latitude,
                "longitude": selectedLatLng.longitude,
              };
              orderViewModel.setLocationData(data);
              Navigator.pop(context, data);
              Navigator.pop(context);
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: screenHeight * 0.03,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isMobileNumberFilled
                  ? PortColor.subBtn
                  : const LinearGradient(
                colors: [
                  PortColor.grey,
                  PortColor.grey,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: TextConst(
              title: isMobileNumberFilled
                  ? "Confirm and proceed"
                  : "Enter Contact Details",
              color: isMobileNumberFilled ? Colors.black : PortColor.gray,
              fontFamily: AppFonts.kanitReg,
            ),
          )

        ),
      ),
    );
  }
}