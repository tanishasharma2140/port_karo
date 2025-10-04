import 'dart:math';
import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view/order/widgets/review_booking.dart';
import 'package:port_karo/view_model/order_view_model.dart';
import 'package:port_karo/view_model/select_vehicles_view_model.dart';
import 'package:port_karo/view_model/service_type_view_model.dart';
import 'package:provider/provider.dart';

class SelectVehicles extends StatefulWidget {
  const SelectVehicles({super.key});

  @override
  State<SelectVehicles> createState() => _SelectVehiclesState();
}

class _SelectVehiclesState extends State<SelectVehicles> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final serviceTypeViewModel = Provider.of<ServiceTypeViewModel>(context, listen: false);
      final selectVehiclesViewModel = Provider.of<SelectVehiclesViewModel>(context, listen: false);
      final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

      double pickupLat = double.tryParse(orderViewModel.pickupData["latitude"].toString()) ?? 0.0;
      double pickupLon = double.tryParse(orderViewModel.pickupData["longitude"].toString()) ?? 0.0;
      double dropLat = double.tryParse(orderViewModel.dropData["latitude"].toString()) ?? 0.0;
      double dropLon = double.tryParse(orderViewModel.dropData["longitude"].toString()) ?? 0.0;

      double distance = calculateDistance(pickupLat, pickupLon, dropLat, dropLon);

      debugPrint("distance $distance");

      selectVehiclesViewModel.selectVehiclesApi(
        serviceTypeViewModel.selectedVehicleId!,
        distance.toString(),
      ).then((_) {
        // API call complete hone के बाद selected vehicle को set करें
        _setDefaultSelectedVehicle(selectVehiclesViewModel);
      });
    });
  }

  // Method to set default selected vehicle based on selected_status
  void _setDefaultSelectedVehicle(SelectVehiclesViewModel viewModel) {
    if (viewModel.selectVehicleModel?.data != null) {
      for (int i = 0; i < viewModel.selectVehicleModel!.data!.length; i++) {
        if (viewModel.selectVehicleModel!.data![i].selectedStatus == 1) {
          setState(() {
            selectedIndex = i;
          });
          break;
        }
      }
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0;

    double dLat = _degreeToRadian(lat2 - lat1);
    double dLon = _degreeToRadian(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degreeToRadian(lat1)) *
                cos(_degreeToRadian(lat2)) *
                sin(dLon / 2) *
                sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }

  // Helper method to get recommended vehicles
  List<dynamic> getRecommendedVehicles(SelectVehiclesViewModel viewModel) {
    return viewModel.selectVehicleModel?.data?.where((vehicle) => vehicle.selectedStatus == 1).toList() ?? [];
  }

  // Helper method to get other vehicles
  List<dynamic> getOtherVehicles(SelectVehiclesViewModel viewModel) {
    return viewModel.selectVehicleModel?.data?.where((vehicle) => vehicle.selectedStatus != 1).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final selectVehiclesViewModel = Provider.of<SelectVehiclesViewModel>(context);

    double pickupLat = orderViewModel.pickupData["latitude"] ?? 0.0;
    double pickupLon = orderViewModel.pickupData["longitude"] ?? 0.0;
    double dropLat = orderViewModel.dropData["latitude"] ?? 0.0;
    double dropLon = orderViewModel.dropData["longitude"] ?? 0.0;
    double distance = calculateDistance(pickupLat, pickupLon, dropLat, dropLon);

    print("distance $distance");

    // Get recommended and other vehicles
    final recommendedVehicles = getRecommendedVehicles(selectVehiclesViewModel);
    final otherVehicles = getOtherVehicles(selectVehiclesViewModel);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 18),
              height: screenHeight * 0.09,
              width: screenWidth,
              decoration: BoxDecoration(
                color: PortColor.white,
                boxShadow: [
                  BoxShadow(
                    color: PortColor.gray.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: screenHeight * 0.025),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  TextConst(title: "Select Vehicles", color: PortColor.black),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.045,
                vertical: screenWidth * 0.04,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.023,
                ),
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  color: PortColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: screenWidth * 0.04,
                          height: screenHeight * 0.01,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Column(
                          children: List.generate(
                            12,
                                (index) => Container(
                              width: screenWidth * 0.003,
                              height: screenHeight * 0.0025,
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              color: PortColor.gray,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.location_on_rounded,
                          color: PortColor.red,
                          size: screenHeight * 0.024,
                        ),
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextConst(
                                title: orderViewModel.pickupData["name"] ?? "N/A",
                                color: PortColor.black,
                                fontFamily: AppFonts.kanitReg,
                                size: 12,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              TextConst(
                                title: orderViewModel.pickupData["phone"] ?? "N/A",
                                color: PortColor.gray,
                                fontFamily: AppFonts.kanitReg,
                                size: 12,
                              ),
                            ],
                          ),
                          TextConst(
                            title: orderViewModel.pickupData["address"] ?? "N/A",
                            color: PortColor.gray,
                            fontFamily: AppFonts.poppinsReg,
                            size: 12,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              TextConst(
                                title: orderViewModel.dropData["name"] ?? "N/A",
                                color: PortColor.black,
                                fontFamily: AppFonts.kanitReg,
                                size: 12,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              TextConst(
                                title: orderViewModel.dropData["phone"] ?? "N/A",
                                color: PortColor.gray,
                                fontFamily: AppFonts.kanitReg,
                                size: 12,
                              ),
                            ],
                          ),
                          TextConst(
                            title: orderViewModel.dropData["address"] ?? "N/A",
                            color: PortColor.gray,
                            fontFamily: AppFonts.poppinsReg,
                            size: 12,
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: PortColor.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.all(
                                        screenHeight * 0.001,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: PortColor.blackLight,
                                        size: screenHeight * 0.02,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    TextConst(
                                      title: "ADD STOP",
                                      color: PortColor.black,
                                      fontFamily: AppFonts.poppinsReg,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: PortColor.blue,
                                      size: screenHeight * 0.025,
                                    ),
                                    SizedBox(width: screenWidth * 0.01),
                                    TextConst(
                                      title: "EDIT LOCATION",
                                      color: PortColor.black,
                                      fontFamily: AppFonts.poppinsReg,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: Container(
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
              Container(
                height: screenHeight * 0.5,
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                ),
                child: selectVehiclesViewModel.loading
                    ? const Center(
                  child: CircularProgressIndicator(color: PortColor.blue),
                )
                    : selectVehiclesViewModel.selectVehicleModel?.data?.isNotEmpty == true
                    ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recommended Section - Only show if there are recommended vehicles
                      if (recommendedVehicles.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: TextConst(
                            title: "Recommended",
                            color: PortColor.black,
                            fontFamily: AppFonts.kanitReg,
                            size: 16,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recommendedVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = recommendedVehicles[index];
                            // Check if this vehicle should be selected based on selected_status
                            final shouldBeSelected = vehicle.selectedStatus == 1;
                            // Use the actual index from main list
                            final mainIndex = selectVehiclesViewModel.selectVehicleModel?.data?.indexOf(vehicle) ?? index;
                            final isSelected = selectedIndex == mainIndex;

                            return _buildVehicleItem(
                              vehicle: vehicle,
                              isSelected: isSelected || shouldBeSelected,
                              index: mainIndex,
                              distance: distance,
                              isRecommended: true,
                              onTap: () {
                                setState(() {
                                  selectedIndex = mainIndex;
                                });
                              },
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],

                      // Others Section
                      if (otherVehicles.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                          child: TextConst(
                            title: "Others",
                            color: PortColor.black,
                            fontFamily: AppFonts.kanitReg,
                            size: 16,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: otherVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = otherVehicles[index];
                            // Check if this vehicle should be selected based on selected_status
                            final shouldBeSelected = vehicle.selectedStatus == 1;
                            // Use the actual index from main list
                            final mainIndex = selectVehiclesViewModel.selectVehicleModel?.data?.indexOf(vehicle) ?? (recommendedVehicles.length + index);
                            final isSelected = selectedIndex == mainIndex;

                            return _buildVehicleItem(
                              vehicle: vehicle,
                              isSelected: isSelected || shouldBeSelected,
                              index: mainIndex,
                              distance: distance,
                              isRecommended: false,
                              onTap: () {
                                setState(() {
                                  selectedIndex = mainIndex;
                                });
                              },
                            );
                          },
                        ),
                      ],

                      if (recommendedVehicles.isEmpty && otherVehicles.isEmpty)
                        const Center(child: Text("No vehicles Available")),
                    ],
                  ),
                )
                    : const Center(child: Text("No vehicles Available")),
              ),
              Container(
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
                  child: InkWell(
                    onTap: selectedIndex != null
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewBooking(
                            index: selectedIndex,
                            price: ((double.tryParse(
                                selectVehiclesViewModel
                                    .selectVehicleModel
                                    ?.data![selectedIndex!]
                                    .amount
                                    .toString() ??
                                    "0") ??
                                0) *
                                distance)
                                .toInt()
                                .toString(),
                            distance: distance.toInt().toString(),
                          ),
                        ),
                      );
                    }
                        : null,
                    child: Container(
                      alignment: Alignment.center,
                      height: screenHeight * 0.03,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: selectedIndex != null
                            ? PortColor.subBtn
                            : LinearGradient(
                          colors: [PortColor.darkPurple, PortColor.darkPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: TextConst(
                        title: selectedIndex != null
                            ? "Proceed with ${selectVehiclesViewModel.selectVehicleModel?.data![selectedIndex!].vehicleName ?? ""}"
                            : "Select a Vehicle",
                        color: PortColor.black,
                        fontFamily: AppFonts.kanitReg,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleItem({
    required dynamic vehicle,
    required bool isSelected,
    required int index,
    required double distance,
    required bool isRecommended,
    required VoidCallback onTap,
  }) {
    // Use the correct property names from your API response
    final vehicleName = vehicle?.vehicleName ?? "";
    final bodyDetails = vehicle?.bodyDetails ?? "";
    final bodyType = vehicle?.bodyType ?? "";
    final amount = vehicle?.amount ?? 0;
    final vehicleImage = vehicle?.vehicleImage ?? "";
    final selectedStatus = vehicle?.selectedStatus ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: screenHeight * 0.02,
          left: screenWidth * 0.04,
          right: screenWidth * 0.04,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? PortColor.blue.withOpacity(0.1) : PortColor.white,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: PortColor.blue, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: isSelected
            ? Column(
          children: [
            // Image centered at top for selected state
            Center(
              child: Image.network(
                vehicleImage,
                height: screenHeight * 0.08, // Larger image for selected state
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    Assets.assetsBike,
                    height: screenHeight * 0.08,
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextConst(
                            title: vehicleName,
                            color: PortColor.black,
                            fontFamily: AppFonts.kanitReg,
                            size: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Row(
                        children: [
                          TextConst(
                            title: bodyDetails,
                            color: PortColor.gray,
                            fontFamily: AppFonts.poppinsReg,
                            size: 11,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextConst(
                      title: "₹${(((double.tryParse(amount.toString()) ?? 0) * distance).toInt())}",
                      color: PortColor.black,
                      fontFamily: AppFonts.kanitReg,
                      size: 16,
                    ),
                    if (isRecommended)
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.005),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.003,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextConst(
                          title: "Recommended",
                          color: Colors.green,
                          size: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              vehicleImage,
              height: screenHeight * 0.05,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  Assets.assetsBike,
                  height: screenHeight * 0.06,
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextConst(
                        title: vehicleName,
                        color: PortColor.black,
                        fontFamily: AppFonts.kanitReg,
                        size: 14,
                      ),
                      if (selectedStatus == 1)
                        Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.02),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.003,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextConst(
                            title: "Auto Selected",
                            color: Colors.orange,
                            size: 10,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      TextConst(
                        title: bodyDetails,
                        color: PortColor.gray,
                        fontFamily: AppFonts.poppinsReg,
                        size: 11,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextConst(
                  title: "₹${(((double.tryParse(amount.toString()) ?? 0) * distance).toInt())}",
                  color: PortColor.black,
                  fontFamily: AppFonts.kanitReg,
                  size: 16,
                ),
                if (isRecommended)
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.005),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.003,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextConst(
                      title: "Recommended",
                      color: Colors.green,
                      size: 10,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}