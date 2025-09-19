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

  void proceedToNextStep() {
    if (pickupController.text.isNotEmpty &&
        dropController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      setState(() {
        currentStep = 1; // Move to Add Items step
      });

      // Navigate to Add Items screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddItemsScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields first")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PortColor.grey,
        body: Stack(
          children: [
            Column(
              children: [
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
                        onChanged: (val) => placeSearchApi(val),
                        focusedBorder: PortColor.buttonBlue,
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
                        focusedBorder: PortColor.buttonBlue,
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
                        prefixIcon: const Icon(Icons.calendar_month),
                        hintText: 'Shifting Date',
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
                                  ? Colors.white
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
                                  ? Colors.white
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
                        ? Colors.white
                        : PortColor.black.withOpacity(0.5),
                    fontSize: 14,
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

/// Add Items Screen
/// Add Items Screen - Updated with navigation to Schedule screen
class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  _AddItemsScreenState createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  int currentStep = 1;
  String selectedCategory = 'Living Room';
  final ScrollController _scrollController = ScrollController();

  // Sample items data with icons
  Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Living Room': [
      {'name': 'Chairs', 'selected': true, 'count': 2, 'icon': Icons.chair},
      {
        'name': 'Tables',
        'selected': true,
        'count': 1,
        'icon': Icons.table_restaurant,
      },
      {'name': 'TV/Monitor', 'selected': true, 'count': 1, 'icon': Icons.tv},
      {
        'name': 'Cabinet/Storage',
        'selected': true,
        'count': 1,
        'icon': Icons.weekend,
      },
      {'name': 'Sofa', 'selected': true, 'count': 1, 'icon': Icons.weekend},
      {
        'name': 'Home Utility',
        'selected': true,
        'count': 1,
        'icon': Icons.home,
      },
    ],
    'Bedroom': [
      {'name': 'Bed', 'selected': false, 'count': 0, 'icon': Icons.bed},
      {
        'name': 'Wardrobe',
        'selected': false,
        'count': 0,
        'icon': Icons.weekend,
      },
      {
        'name': 'Dressing Table',
        'selected': false,
        'count': 0,
        'icon': Icons.table_restaurant,
      },
    ],
    'Kitchen': [
      {
        'name': 'Refrigerator',
        'selected': false,
        'count': 0,
        'icon': Icons.kitchen,
      },
      {
        'name': 'Microwave',
        'selected': false,
        'count': 0,
        'icon': Icons.microwave,
      },
      {
        'name': 'Gas Stove',
        'selected': false,
        'count': 0,
        'icon': Icons.local_fire_department,
      },
    ],
    'Others': [
      {
        'name': 'Plants',
        'selected': false,
        'count': 0,
        'icon': Icons.local_florist,
      },
      {
        'name': 'Sports Equipment',
        'selected': false,
        'count': 0,
        'icon': Icons.sports_basketball,
      },
    ],
  };

  int get selectedItemsCount {
    int count = 0;
    categoryItems.forEach((category, items) {
      for (var item in items) {
        if (item['selected']) {
          count += (item['count'] as num).toInt();
        }
      }
    });
    return count;
  }

  void _scrollToCategory(String category) {
    final categoryIndex = categoryItems.keys.toList().indexOf(category);
    final itemHeight = screenHeight * 0.07;
    _scrollController.animateTo(
      categoryIndex * categoryItems.values.first.length * itemHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _confirmItems() {
    // Navigate to Schedule screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCategory(selectedCategory);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PortColor.bg,
      body: Column(
        children: [
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
          SizedBox(height: screenHeight * 0.02),
          SizedBox(height: screenHeight * 0.02),
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
                children: ['Living Room', 'Bedroom', 'Kitchen', 'Others']
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
                                    ? Colors.white
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
                Text(
                  '$selectedItemsCount Items added',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Show all selected items in bottom sheet
                    List<String> selectedItemNames = [];
                    categoryItems.forEach((category, items) {
                      for (var item in items) {
                        if (item['selected'] && item['count'] > 0) {
                          selectedItemNames.add(
                            "${item['name']} x${item['count']}",
                          );
                        }
                      }
                    });

                    if (selectedItemNames.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No items selected")),
                      );
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: screenHeight * 0.4,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                      screenHeight * 0.02,
                                    ),
                                    child: Text(
                                      "Selected Items",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: PortColor.black,
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: selectedItemNames.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            selectedItemNames[index],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: PortColor.black
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black12,
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      color: PortColor.button,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(width: screenWidth * 0.05),
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
                      child: TextConst(
                        title: "Confirm items",
                        fontFamily: AppFonts.poppinsReg,
                        color: PortColor.white,
                        size: 12,
                      ),
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

  Widget _buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.kanitReg,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Container(
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
          child: Column(
            children: [
              for (int i = 0; i < categoryItems[category]!.length; i++)
                Column(
                  children: [
                    _buildItemTile(categoryItems[category]![i]),
                    if (i < categoryItems[category]!.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                        indent: screenWidth * 0.05,
                        endIndent: screenWidth * 0.05,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemTile(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: item['selected'] ? PortColor.button : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          item['icon'] as IconData,
          color: item['selected'] ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      title: TextConst(
        title: item['name'],
        fontFamily: AppFonts.poppinsReg,
        size: 13,
      ),
      trailing: item['selected']
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (item['count'] > 1) {
                        item['count']--;
                      } else {
                        item['selected'] = false;
                        item['count'] = 0;
                      }
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '${item['count']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      item['count']++;
                    });
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.add, color: Colors.blue, size: 18),
                  ),
                ),
              ],
            )
          : null,

      onTap: () {
        setState(() {
          item['selected'] = !item['selected'];
          if (item['selected'] && item['count'] == 0) {
            item['count'] = 1;
          }
        });
      },
    );
  }
}

/// Schedule Screen - Based on the image provided

/// Updated StepWidget to support checkmark for completed steps
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
            fontFamily: AppFonts.kanitReg,
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
