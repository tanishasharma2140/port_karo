import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/res/custom_text_field.dart';
import 'package:port_karo/view/home/widgets/city_toggle.dart';
import 'package:port_karo/view/home/widgets/pickup/f_a_q_modal_sheet.dart';
import 'package:port_karo/view/home/widgets/pickup/schedule_screen.dart';

class DeliverByPackerMover extends StatefulWidget {
  const DeliverByPackerMover({super.key});

  @override
  State<DeliverByPackerMover> createState() => _DeliverByPackerMoverState();
}

class _DeliverByPackerMoverState extends State<DeliverByPackerMover> {
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final FocusNode pickupFocus = FocusNode();
  final FocusNode dropFocus = FocusNode();

  List<dynamic> searchResults = [];
  bool isPickupActive = false;
  bool isLoading = false;

  String selectedCity = "";
  String selectedDay = "";

  // Switch states
  bool pickupLiftAvailable = false;
  bool dropLiftAvailable = false;

  // Step management
  int currentStep = 0; // 0: Moving details, 1: Add items, 2: Schedule

  // Vehicle types
  final List<Map<String, dynamic>> _vehicleTypes = [
    {
      'name': 'Tata Ace',
      'capacity': 'Up to 600 kg',
      'size': '5.5 ft x 5 ft x 4.5 ft',
      'icon': Icons.local_shipping,
      'price': '₹1,564',
      'selected': false,
    },
    {
      'name': 'Tata 407',
      'capacity': 'Up to 2000 kg',
      'size': '9 ft x 6 ft x 6 ft',
      'icon': Icons.fire_truck,
      'price': '₹2,564',
      'selected': false,
    },
    {
      'name': 'Pickup Truck',
      'capacity': 'Up to 1000 kg',
      'size': '7 ft x 5 ft x 4 ft',
      'icon': Icons.directions_car,
      'price': '₹1,864',
      'selected': false,
    },
    {
      'name': 'Tempo Traveller',
      'capacity': 'Up to 1500 kg',
      'size': '8 ft x 6 ft x 5 ft',
      'icon': Icons.airport_shuttle,
      'price': '₹2,164',
      'selected': false,
    },
  ];

  @override
  void initState() {
    super.initState();

    pickupFocus.addListener(() {
      setState(() {
        isPickupActive = pickupFocus.hasFocus;
        searchResults.clear();
      });
    });

    dropFocus.addListener(() {
      setState(() {
        isPickupActive = !dropFocus.hasFocus ? true : false;
        searchResults.clear();
      });
    });
  }

  Future<void> placeSearchApi(String searchCon) async {
    if (searchCon.isEmpty) return;

    setState(() => isLoading = true);

    Uri uri =
    Uri.https("maps.googleapis.com", 'maps/api/place/autocomplete/json', {
      "input": selectedCity.isNotEmpty
          ? "$searchCon, $selectedCity"
          : searchCon,
      "key": "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI",
      "components": "country:in",
    });

    try {
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body)['predictions'];
        if (mounted) {
          setState(() {
            searchResults = resData;
          });
        }
      }
    } catch (e) {
      print("Error fetching places: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<LatLng> fetchLatLng(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", 'maps/api/place/details/json', {
      "place_id": placeId,
      "key": "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI",
    });

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final location = result['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      return const LatLng(0.0, 0.0);
    }
  }

  Future<void> pickDate() async {
    DateTime today = DateTime.now();
    DateTime lastDate = today.add(const Duration(days: 20));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: PortColor.button,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: PortColor.button),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
        selectedDay = "";
      });
    }
  }

  void selectDay(String day) {
    DateTime today = DateTime.now();
    if (day == "Today") {
      dateController.text = "${today.day}/${today.month}/${today.year}";
    } else if (day == "Tomorrow") {
      final tomorrow = today.add(const Duration(days: 1));
      dateController.text =
      "${tomorrow.day}/${tomorrow.month}/${tomorrow.year}";
    }
    setState(() {
      selectedDay = day;
    });
  }

  void _showVehicleTypeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: PortColor.bg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: PortColor.black,
                          size: screenHeight * 0.025,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      TextConst(
                        title: "Select Vehicle Type",
                        color: PortColor.black,
                        fontFamily: AppFonts.kanitReg,
                        fontWeight: FontWeight.w600,
                        size: 16,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title: "Choose the right vehicle for your move",
                          fontFamily: AppFonts.kanitReg,
                          color: Colors.grey.shade600,
                          size: 14,
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Vehicle Types List
                        Column(
                          children: _vehicleTypes.asMap().entries.map((entry) {
                            final index = entry.key;
                            final vehicle = entry.value;
                            return _buildVehicleTypeItem(
                              vehicle['name'],
                              vehicle['capacity'],
                              vehicle['size'],
                              vehicle['icon'],
                              vehicle['price'],
                              vehicle['selected'],
                              index,
                              setModalState,
                            );
                          }).toList(),
                        ),

                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),
                ),

                // Confirm Button
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      final selectedVehicle = _vehicleTypes.firstWhere(
                            (vehicle) => vehicle['selected'] == true,
                        orElse: () => {},
                      );

                      if (selectedVehicle.isNotEmpty) {
                        Navigator.pop(context);
                        // Navigate to Add Items screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddItemsScreen()),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                      decoration: BoxDecoration(
                        color: _vehicleTypes.any((vehicle) => vehicle['selected'] == true)
                            ? PortColor.button
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TextConst(
                          title: "Confirm Vehicle",
                          fontFamily: AppFonts.kanitReg,
                          color: _vehicleTypes.any((vehicle) => vehicle['selected'] == true)
                              ? PortColor.black
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleTypeItem(
      String name,
      String capacity,
      String size,
      IconData icon,
      String price,
      bool isSelected,
      int index,
      StateSetter setModalState,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: GestureDetector(
        onTap: () {
          setModalState(() {
            for (var i = 0; i < _vehicleTypes.length; i++) {
              _vehicleTypes[i]['selected'] = (i == index);
            }
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          decoration: BoxDecoration(
            color: isSelected ? PortColor.gold.withOpacity(0.2) : PortColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? PortColor.gold : PortColor.gray.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Vehicle Icon
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: isSelected ? PortColor.gold : PortColor.gold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? PortColor.white : PortColor.gold,
                  size: screenHeight * 0.025,
                ),
              ),

              SizedBox(width: screenWidth * 0.03),

              // Vehicle Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(
                      title: name,
                      fontFamily: AppFonts.kanitReg,
                      fontWeight: FontWeight.w600,
                      size: 16,
                      color: PortColor.black,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    TextConst(
                      title: capacity,
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.grey.shade600,
                      size: 12,
                    ),
                    SizedBox(height: screenHeight * 0.002),
                    TextConst(
                      title: size,
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.grey.shade600,
                      size: 12,
                    ),
                  ],
                ),
              ),

              // Price and Selection Indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextConst(
                    title: price,
                    fontFamily: AppFonts.kanitReg,
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: PortColor.black,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    width: screenWidth * 0.05,
                    height: screenWidth * 0.05,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? PortColor.gold : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected ? PortColor.gold : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                      Icons.check,
                      color: PortColor.white,
                      size: screenWidth * 0.03,
                    )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void proceedToNextStep() {
    if (pickupController.text.isNotEmpty &&
        dropController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      _showVehicleTypeModal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields first")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.grey,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: topPadding,),
                // Header + Steps
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.02,
                  ),
                  height: screenHeight * 0.17,
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    border: Border(
                      bottom: BorderSide(
                        color: PortColor.gray,
                        width: screenWidth * 0.002,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PortColor.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              color: PortColor.black,
                              size: screenHeight * 0.02,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          TextConst(
                            title: "Packer and Mover",
                            color: PortColor.black,
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return const FAQModalSheet();
                                },
                              );
                            },
                            child: TextConst(
                              title: "FAQs",
                              color: PortColor.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StepWidget(
                            icon: currentStep > 0
                                ? Icons.check
                                : Icons.location_on,
                            text: 'Moving details',
                            isActive: true,
                            isCompleted: currentStep > 0,
                          ),
                          const DottedLine(),
                          StepWidget(
                            icon: Icons.inventory,
                            text: 'Add items',
                            isActive: currentStep >= 1,
                            isCompleted: currentStep > 1,
                          ),
                          const DottedLine(),
                          StepWidget(
                            icon: Icons.receipt,
                            text: 'Schedule',
                            isActive: currentStep >= 2,
                            isCompleted: currentStep > 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // City Toggle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: CityToggle(),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Pickup Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: pickupController,
                        focusNode: pickupFocus,
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                        onChanged: (val) => placeSearchApi(val),
                        focusedBorder: PortColor.gold,
                        height: screenHeight * 0.055,
                        cursorHeight: screenHeight * 0.022,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: PortColor.white,
                              size: screenHeight * 0.02,
                            ),
                          ),
                        ),
                        hintText: 'Pick up Location',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                      ),
                      if (pickupController.text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextConst(
                                  title: "Service lift available at pickup",
                                  color: PortColor.black.withOpacity(0.7),
                                  fontFamily: AppFonts.kanitReg,
                                  size: 13,
                                ),
                              ),
                              Switch(
                                value: pickupLiftAvailable,
                                activeColor: PortColor.button,
                                onChanged: (val) {
                                  setState(() {
                                    pickupLiftAvailable = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.035),

                // Drop Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: dropController,
                        focusNode: dropFocus,
                        onChanged: (val) => placeSearchApi(val),
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                        focusedBorder: PortColor.gold,
                        height: screenHeight * 0.055,
                        cursorHeight: screenHeight * 0.022,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: PortColor.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_downward_rounded,
                              color: PortColor.white,
                              size: screenHeight * 0.02,
                            ),
                          ),
                        ),
                        hintText: 'Drop Location',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                      ),
                      if (dropController.text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextConst(
                                  title: "Service lift available at drop",
                                  color: PortColor.black.withOpacity(0.7),
                                  fontFamily: AppFonts.kanitReg,
                                  size: 13,
                                ),
                              ),
                              Switch(
                                value: dropLiftAvailable,
                                activeColor: PortColor.button,
                                onChanged: (val) {
                                  setState(() {
                                    dropLiftAvailable = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.035),

                // Date Picker field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: GestureDetector(
                    onTap: pickDate,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        controller: dateController,
                        prefixIcon: const Icon(Icons.calendar_month,size: 17,),
                        hintText: 'Shifting Date',
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.017),

                // Today & Tomorrow Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => selectDay("Today"),
                        child: Container(
                          height: screenHeight * 0.046,
                          width: screenWidth * 0.28,
                          decoration: BoxDecoration(
                            color: selectedDay == "Today"
                                ? PortColor.button
                                : PortColor.white,
                            border: Border.all(
                              color: selectedDay == "Today"
                                  ? PortColor.button
                                  : PortColor.gray.withOpacity(0.75),
                              width: screenWidth * 0.004,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "Today",
                              color: selectedDay == "Today"
                                  ? Colors.black
                                  : PortColor.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => selectDay("Tomorrow"),
                        child: Container(
                          height: screenHeight * 0.046,
                          width: screenWidth * 0.28,
                          decoration: BoxDecoration(
                            color: selectedDay == "Tomorrow"
                                ? PortColor.button
                                : PortColor.white,
                            border: Border.all(
                              color: selectedDay == "Tomorrow"
                                  ? PortColor.button
                                  : PortColor.gray.withOpacity(0.75),
                              width: screenWidth * 0.004,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Center(
                            child: TextConst(
                              title: "Tomorrow",
                              color: selectedDay == "Tomorrow"
                                  ? Colors.black
                                  : PortColor.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Suggestions overlay
            if (searchResults.isNotEmpty || isLoading)
              Positioned(
                top: isPickupActive ? screenHeight * 0.34 : screenHeight * 0.43,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
                child: Container(
                  height: screenHeight * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final place = searchResults[index];
                      return Column(
                        children: [
                          ListTile(
                            title: TextConst(
                              title: place['description'],
                              color: PortColor.black.withOpacity(0.7),
                            ),
                            onTap: () async {
                              LatLng latLng = await fetchLatLng(
                                place['place_id'],
                              );
                              setState(() {
                                if (isPickupActive) {
                                  pickupController.text =
                                  place['description'];
                                } else {
                                  dropController.text =
                                  place['description'];
                                }
                                searchResults.clear();
                              });
                              print(
                                "Selected: ${place['description']} - $latLng",
                              );
                            },
                          ),
                          if (index < searchResults.length - 1)
                            Divider(
                              color: PortColor.gray,
                              thickness: 0.5,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        bottomSheet: Container(
          height: screenHeight * 0.1,
          color: PortColor.white,
          child: Center(
            child: GestureDetector(
              onTap: proceedToNextStep,
              child: Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.symmetric(
                  horizontal: screenHeight * 0.009,
                  vertical: screenHeight * 0.014,
                ),
                decoration: BoxDecoration(
                  color:
                  (pickupController.text.isNotEmpty &&
                      dropController.text.isNotEmpty &&
                      dateController.text.isNotEmpty)
                      ? PortColor.button
                      : PortColor.gray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Check Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                    (pickupController.text.isNotEmpty &&
                        dropController.text.isNotEmpty &&
                        dateController.text.isNotEmpty)
                        ? Colors.black
                        : PortColor.black.withOpacity(0.5),
                    fontSize: 14,
                    fontFamily: AppFonts.kanitReg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final bool isCompleted;

  const StepWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.isActive,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive ? PortColor.button : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive ? Colors.white : Colors.grey,
            size: 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
              fontFamily: AppFonts.kanitReg
          ),
        ),
      ],
    );
  }
}

/// DottedLine
class DottedLine extends StatelessWidget {
  final int dotCount;
  final double dotWidth;
  final double dotHeight;
  final double spacing;

  const DottedLine({
    super.key,
    this.dotCount = 16,
    this.dotWidth = 2,
    this.dotHeight = 1,
    this.spacing = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(dotCount, (index) {
        return Container(
          width: dotWidth,
          height: dotHeight,
          color: PortColor.gray,
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
        );
      }),
    );
  }
}

/// Add Items Screen
/// Add Items Screen - Updated with navigation to Schedule screen
/// Add Items Screen - Updated with dropdown quantity selection


class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  int currentStep = 1;
  String selectedCategory = 'Living Room';
  final ScrollController _scrollController = ScrollController();

  // Add debounce timer to prevent blinking
  Timer? _scrollTimer;
  bool _isScrolling = false;

  // Category keys list for easy access
  final List<String> _categories = ['Living Room', 'Bedroom', 'Kitchen', 'Others'];

  // Sample items data with expanded state and quantities
  Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Living Room': [
      {
        'name': 'Chairs',
        'expanded': false,
        'subItems': [
          {'name': 'Plastic/Folding Chair', 'count': 0},
          {'name': 'Dining Table Chairs', 'count': 0},
          {'name': 'Office Chair', 'count': 0},
          {'name': 'Recliner', 'count': 0},
        ]
      },
      {
        'name': 'Tables',
        'expanded': false,
        'subItems': [
          {'name': 'Coffee Table', 'count': 0},
          {'name': 'Dining Table', 'count': 0},
          {'name': 'Study Table', 'count': 0},
          {'name': 'Side Table', 'count': 0},
        ]
      },
      {
        'name': 'TV/Monitor',
        'expanded': false,
        'subItems': [
          {'name': 'LED TV', 'count': 0},
          {'name': 'LCD TV', 'count': 0},
          {'name': 'Computer Monitor', 'count': 0},
          {'name': 'Home Theater', 'count': 0},
        ]
      },
      {
        'name': 'Cabinet/Storage',
        'expanded': false,
        'subItems': [
          {'name': 'Bookshelf', 'count': 0},
          {'name': 'Showcase', 'count': 0},
          {'name': 'Storage Cabinet', 'count': 0},
          {'name': 'TV Unit', 'count': 0},
        ]
      },
    ],
    'Bedroom': [
      {
        'name': 'Bed',
        'expanded': false,
        'subItems': [
          {'name': 'Single Bed', 'count': 0},
          {'name': 'Double Bed', 'count': 0},
          {'name': 'King Size Bed', 'count': 0},
          {'name': 'Bunk Bed', 'count': 0},
        ]
      },
      {
        'name': 'Wardrobe',
        'expanded': false,
        'subItems': [
          {'name': 'Single Door', 'count': 0},
          {'name': 'Double Door', 'count': 0},
          {'name': 'Sliding Door', 'count': 0},
          {'name': 'Walk-in Wardrobe', 'count': 0},
        ]
      },
      {
        'name': 'Dressing Table',
        'expanded': false,
        'subItems': [
          {'name': 'Wooden Dressing', 'count': 0},
          {'name': 'Modern Dressing', 'count': 0},
          {'name': 'Wall Mounted', 'count': 0},
        ]
      },
    ],
    'Kitchen': [
      {
        'name': 'Refrigerator',
        'expanded': false,
        'subItems': [
          {'name': 'Single Door', 'count': 0},
          {'name': 'Double Door', 'count': 0},
          {'name': 'Side by Side', 'count': 0},
        ]
      },
      {
        'name': 'Microwave',
        'expanded': false,
        'subItems': [
          {'name': 'Solo Microwave', 'count': 0},
          {'name': 'Grill Microwave', 'count': 0},
          {'name': 'Convection Microwave', 'count': 0},
        ]
      },
      {
        'name': 'Gas Stove',
        'expanded': false,
        'subItems': [
          {'name': '2 Burner', 'count': 0},
          {'name': '3 Burner', 'count': 0},
          {'name': '4 Burner', 'count': 0},
        ]
      },
    ],
    'Others': [
      {
        'name': 'Plants',
        'expanded': false,
        'subItems': [
          {'name': 'Small Plants', 'count': 0},
          {'name': 'Medium Plants', 'count': 0},
          {'name': 'Large Plants', 'count': 0},
        ]
      },
      {
        'name': 'Sports Equipment',
        'expanded': false,
        'subItems': [
          {'name': 'Treadmill', 'count': 0},
          {'name': 'Exercise Bike', 'count': 0},
          {'name': 'Weights', 'count': 0},
        ]
      },
    ],
  };

  int get selectedItemsCount {
    int count = 0;
    categoryItems.forEach((category, items) {
      for (var item in items) {
        for (var subItem in item['subItems']) {
          count += (subItem['count'] as int);
        }
      }
    });
    return count;
  }

  List<Map<String, dynamic>> get selectedItemsList {
    List<Map<String, dynamic>> selected = [];
    categoryItems.forEach((category, items) {
      for (var item in items) {
        for (var subItem in item['subItems']) {
          if (subItem['count'] > 0) {
            selected.add({
              'category': category,
              'mainItem': item['name'],
              'subItem': subItem['name'],
              'count': subItem['count'],
            });
          }
        }
      }
    });
    return selected;
  }

  @override
  void initState() {
    super.initState();

    // Add scroll listener to detect which category is visible
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCategory(selectedCategory);
    });
  }

  void _onScroll() {
    // Cancel previous timer
    _scrollTimer?.cancel();

    // Set scrolling flag
    _isScrolling = true;

    // Set new timer to delay the category update (debounce)
    _scrollTimer = Timer(const Duration(milliseconds: 50), () {
      if (!_scrollController.hasClients || !mounted) return;

      final scrollOffset = _scrollController.offset;

      // Define approximate section heights
      final Map<String, double> sectionHeights = {
        'Living Room': _calculateSectionHeight('Living Room'),
        'Bedroom': _calculateSectionHeight('Bedroom'),
        'Kitchen': _calculateSectionHeight('Kitchen'),
        'Others': _calculateSectionHeight('Others'),
      };

      double accumulatedHeight = 0;
      String? newSelectedCategory;

      for (final category in _categories) {
        final sectionHeight = sectionHeights[category] ?? 0;

        // Check if current scroll position is within this category's section
        if (scrollOffset >= accumulatedHeight - 50 &&
            scrollOffset < accumulatedHeight + sectionHeight - 50) {
          newSelectedCategory = category;
          break;
        }

        accumulatedHeight += sectionHeight;
      }

      // Only update if category actually changed and we're not in the middle of programmatic scroll
      if (newSelectedCategory != null && newSelectedCategory != selectedCategory) {
        setState(() {
          selectedCategory = newSelectedCategory!;
        });
      }

      _isScrolling = false;
    });
  }

  double _calculateSectionHeight(String category) {
    final items = categoryItems[category]!;
    double height = screenHeight * 0.08; // Category header height

    for (var item in items) {
      height += screenHeight * 0.07; // Main item height
      if (item['expanded']) {
        height += (item['subItems'].length * screenHeight * 0.06); // Sub items height
      }
    }

    height += screenHeight * 0.03; // Padding
    return height;
  }

  void _scrollToCategory(String category) {
    // Cancel any ongoing scroll detection
    _scrollTimer?.cancel();

    final categoryIndex = _categories.indexOf(category);
    if (categoryIndex == -1) return;

    double scrollOffset = 0;

    // Calculate scroll position for the selected category
    for (int i = 0; i < categoryIndex; i++) {
      final cat = _categories[i];
      scrollOffset += _calculateSectionHeight(cat);
    }

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _confirmItems() {
    if (selectedItemsCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one item")),
      );
      return;
    }

    // Navigate to Schedule screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleScreen()),
    );
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          children: [
            SizedBox(height: topPadding),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03,
                vertical: screenHeight * 0.02,
              ),
              height: screenHeight * 0.17,
              decoration: BoxDecoration(
                color: PortColor.white,
                border: Border(
                  bottom: BorderSide(
                    color: PortColor.gray,
                    width: screenWidth * 0.002,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: PortColor.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: PortColor.black,
                          size: screenHeight * 0.02,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      TextConst(
                        title: "Packer and Mover",
                        color: PortColor.black,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StepWidget(
                        icon: Icons.check,
                        text: 'Moving details',
                        isActive: true,
                        isCompleted: true,
                      ),
                      const DottedLine(),
                      StepWidget(
                        icon: Icons.inventory,
                        text: 'Add items',
                        isActive: true,
                        isCompleted: false,
                      ),
                      const DottedLine(),
                      StepWidget(
                        icon: Icons.receipt,
                        text: 'Schedule',
                        isActive: false,
                        isCompleted: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search item',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      fontFamily: AppFonts.kanitReg,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: screenHeight * 0.04,
                decoration: BoxDecoration(
                  color: PortColor.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _categories
                      .map(
                        (category) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        _scrollToCategory(category);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                        ),
                        decoration: BoxDecoration(
                          color: selectedCategory == category
                              ? PortColor.button
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: selectedCategory == category
                                  ? Colors.black
                                  : Colors.black,
                              fontFamily: AppFonts.kanitReg,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Instruction Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                'Add items to get the exact quote, you can edit this later',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontFamily: AppFonts.kanitReg,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                children: [
                  _buildCategorySection('Living Room'),
                  SizedBox(height: screenHeight * 0.03),
                  _buildCategorySection('Bedroom'),
                  SizedBox(height: screenHeight * 0.03),
                  _buildCategorySection('Kitchen'),
                  SizedBox(height: screenHeight * 0.03),
                  _buildCategorySection('Others'),
                ],
              ),
            ),

            // Bottom Summary Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$selectedItemsCount Items added',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: PortColor.black,
                        ),
                      ),
                      if (selectedItemsCount > 0)
                        GestureDetector(
                          onTap: _showSelectedItems,
                          child: Text(
                            'View all',
                            style: TextStyle(
                              color: PortColor.button,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showSelectedItems,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenHeight * 0.012,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: PortColor.button),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: PortColor.button,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: GestureDetector(
                      onTap: _confirmItems,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: PortColor.button,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Check price",
                          style: TextStyle(
                            fontFamily: AppFonts.kanitReg,
                            color: PortColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectedItems() {
    if (selectedItemsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items selected")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: screenHeight * 0.7,
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Selected Items",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: PortColor.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedItemsList.length,
                  itemBuilder: (context, index) {
                    final item = selectedItemsList[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: PortColor.button,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconForItem(item['mainItem']),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['subItem'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: PortColor.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  item['mainItem'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: PortColor.button.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'x${item['count']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: PortColor.button,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  color: PortColor.button,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Total Items: $selectedItemsCount",
                    style: TextStyle(
                      fontFamily: AppFonts.kanitReg,
                      color: PortColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySection(String category) {
    final items = categoryItems[category]!;
    final totalItemsInCategory = items.fold<int>(0, (sum, item) {
      return sum + (item['subItems'] as List<Map<String, dynamic>>).fold<int>(0, (subSum, subItem) => subSum + (subItem['count'] as int));
    });

    return Column(
      key: Key(category),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.kanitReg,
                fontWeight: FontWeight.w600,
                color: PortColor.black,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            if (totalItemsInCategory > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: PortColor.button,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  '$totalItemsInCategory items added',
                  style: TextStyle(
                    fontSize: 10,
                    color: PortColor.black,
                    fontFamily: AppFonts.kanitReg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++)
                Column(
                  children: [
                    _buildExpandableItem(items[i], category),
                    if (i < items.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableItem(Map<String, dynamic> item, String category) {
    final subItems = item['subItems'] as List<Map<String, dynamic>>;
    final totalSubItems = subItems.fold<int>(0, (sum, subItem) => sum + (subItem['count'] as int));

    return Column(
      children: [
        // Main Item Header
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.005,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: totalSubItems > 0 ? PortColor.button : Colors.grey.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              _getIconForItem(item['name']),
              color: totalSubItems > 0 ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
          title: Text(
            item['name'],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: PortColor.black,
              fontFamily: AppFonts.kanitReg,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (totalSubItems > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: PortColor.button.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalSubItems',
                    style: TextStyle(
                      color: PortColor.button,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(width: screenWidth * 0.02),
              Icon(
                item['expanded'] ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              item['expanded'] = !item['expanded'];
            });
          },
        ),

        // Expanded Sub-items
        if (item['expanded'])
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.12,
              right: screenWidth * 0.04,
              bottom: screenHeight * 0.01,
            ),
            child: Column(
              children: [
                for (int i = 0; i < subItems.length; i++)
                  Column(
                    children: [
                      _buildSubItemTile(subItems[i]),
                      if (i < subItems.length - 1)
                        Divider(
                          height: screenHeight * 0.02,
                          thickness: 0.5,
                          color: Colors.grey.shade200,
                        ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSubItemTile(Map<String, dynamic> subItem) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subItem['name'],
              style: TextStyle(
                fontSize: 13,
                color: PortColor.black.withOpacity(0.8),
                fontFamily: AppFonts.kanitReg,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          // Quantity Selector
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Decrease Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (subItem['count'] > 0) {
                        subItem['count']--;
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: subItem['count'] > 0 ? Colors.red.shade50 : Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                    child: Icon(
                      Icons.remove,
                      size: 16,
                      color: subItem['count'] > 0 ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
                // Count Display
                Container(
                  width: 40,
                  height: 30,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      '${subItem['count']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: PortColor.black,
                      ),
                    ),
                  ),
                ),
                // Increase Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      subItem['count']++;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForItem(String itemName) {
    switch (itemName) {
      case 'Chairs':
        return Icons.chair;
      case 'Tables':
        return Icons.table_restaurant;
      case 'TV/Monitor':
        return Icons.tv;
      case 'Cabinet/Storage':
        return Icons.weekend;
      case 'Bed':
        return Icons.bed;
      case 'Wardrobe':
        return Icons.weekend;
      case 'Dressing Table':
        return Icons.table_restaurant;
      case 'Refrigerator':
        return Icons.kitchen;
      case 'Microwave':
        return Icons.microwave;
      case 'Gas Stove':
        return Icons.local_fire_department;
      case 'Plants':
        return Icons.local_florist;
      case 'Sports Equipment':
        return Icons.sports_basketball;
      default:
        return Icons.category;
    }
  }
}

// class StepWidget extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final bool isActive;
//   final bool isCompleted;
//
//   const StepWidget({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.isActive,
//     this.isCompleted = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 30,
//           height: 30,
//           decoration: BoxDecoration(
//             color: isActive ? PortColor.button : Colors.grey[300],
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             isCompleted ? Icons.check : icon,
//             color: isActive ? Colors.white : Colors.grey,
//             size: 15,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           text,
//           style: TextStyle(
//               color: isActive ? Colors.black : Colors.grey,
//               fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//               fontSize: 10,
//               fontFamily: AppFonts.kanitReg
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class DottedLine extends StatelessWidget {
//   final int dotCount;
//   final double dotWidth;
//   final double dotHeight;
//   final double spacing;
//
//   const DottedLine({
//     super.key,
//     this.dotCount = 16,
//     this.dotWidth = 2,
//     this.dotHeight = 1,
//     this.spacing = 3,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(dotCount, (index) {
//         return Container(
//           width: dotWidth,
//           height: dotHeight,
//           color: PortColor.gray,
//           margin: EdgeInsets.symmetric(horizontal: spacing / 2),
//         );
//       }),
//     );
//   }
// }


