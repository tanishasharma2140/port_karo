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
      final selectVehiclesViewModel =
          Provider.of<SelectVehiclesViewModel>(context, listen: false);
      selectVehiclesViewModel.selectVehiclesApi();
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371.0;

    double dLat = _degreeToRadian(lat2 - lat1);
    double dLon = _degreeToRadian(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
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

  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final selectVehiclesViewModel =
        Provider.of<SelectVehiclesViewModel>(context);
    double pickupLat = orderViewModel.pickupData["latitude"] ?? 0.0;
    double pickupLon = orderViewModel.pickupData["longitude"] ?? 0.0;
    double dropLat = orderViewModel.dropData["latitude"] ?? 0.0;
    double dropLon = orderViewModel.dropData["longitude"] ?? 0.0;
    double distance = calculateDistance(pickupLat, pickupLon, dropLat, dropLon);
     print("distance $distance");
    return SafeArea(
        child: Scaffold(
            backgroundColor: PortColor.grey,
            body: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                  height: screenHeight * 0.07,
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
                        icon: Icon(
                          Icons.arrow_back,
                          size: screenHeight * 0.025,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      TextConst(
                        title: "Select Vehicles",
                        color: PortColor.black,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                      vertical: screenWidth * 0.04),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.023),
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
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
                                    title: orderViewModel.pickupData["name"] ??
                                        "N/A",
                                    color: PortColor.black,
                                    fontFamily: AppFonts.kanitReg,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  TextConst(
                                    title: orderViewModel.pickupData["phone"] ??
                                        "N/A",
                                    color: PortColor.gray,
                                    fontFamily: AppFonts.kanitReg,
                                    size: 12,
                                  ),
                                ],
                              ),
                              TextConst(
                                title: orderViewModel.pickupData["address"] ??
                                    "N/A",
                                color: PortColor.gray,
                                fontFamily: AppFonts.poppinsReg,
                                size: 12,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                children: [
                                  TextConst(
                                    title: orderViewModel.dropData["name"] ??
                                        "N/A",
                                    color: PortColor.black,
                                    fontFamily: AppFonts.kanitReg,
                                    size: 12,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  TextConst(
                                    title: orderViewModel.dropData["phone"] ??
                                        "N/A",
                                    color: PortColor.gray,
                                    fontFamily: AppFonts.kanitReg,
                                    size: 12,
                                  ),
                                ],
                              ),
                              TextConst(
                                title:
                                    orderViewModel.dropData["address"] ?? "N/A",
                                color: PortColor.gray,
                                fontFamily: AppFonts.poppinsReg,
                                size: 12,

                              ),
                              SizedBox(height: screenHeight * 0.014),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // ✅ Add Stop group in Container
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
                                          padding: EdgeInsets.all(screenHeight * 0.006),
                                          child: Icon(
                                            Icons.add,
                                            color: PortColor.white,
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
                              )

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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  height: screenHeight * 0.5,
                  padding: EdgeInsets.symmetric(
                    // horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: selectVehiclesViewModel.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: PortColor.blue,
                        ))
                      : selectVehiclesViewModel
                                  .selectVehiclesModel?.data?.isNotEmpty ==
                              true
                          ? ListView.builder(
                              itemCount: selectVehiclesViewModel
                                  .selectVehiclesModel?.data?.length,
                              itemBuilder: (context, index) {
                                final vehicle = selectVehiclesViewModel
                                    .selectVehiclesModel?.data![index];
                                final isSelected = selectedIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: screenHeight * 0.02),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? PortColor.blue.withOpacity(0.1)
                                          : PortColor.white,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          vehicle?.image ?? "",
                                          height: screenHeight * 0.06,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              Assets.assetsBike,
                                              height: screenHeight * 0.06,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  TextConst(
                                                    title: vehicle?.name ?? "",
                                                    color: PortColor.black,
                                                    fontFamily: AppFonts.kanitReg,
                                                  ),
                                                  Icon(
                                                    Icons.info_outline,
                                                    size: screenHeight * 0.025,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TextConst(
                                                    title:
                                                        "${vehicle?.maxWeight?.toString() ?? ""} kg",
                                                    color: PortColor.gray,
                                                    fontFamily: AppFonts.poppinsReg,
                                                    size: 12,
                                                  ),
                                                  TextConst(
                                                    title:
                                                        "${vehicle?.time?.toString() ?? ""} min",
                                                    color: PortColor.gray,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            TextConst(
                                              title:
                                                  "₹${((vehicle?.price ?? 0) * distance).toStringAsFixed(0)}",
                                              color: PortColor.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
                                      price: ((selectVehiclesViewModel
                                                      .selectVehiclesModel
                                                      ?.data![selectedIndex!]
                                                      .price ??
                                                  0) *
                                              distance)
                                          .toStringAsFixed(0),
                                      distance: distance.toStringAsFixed(0),
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
                            color: selectedIndex != null
                                ? PortColor.buttonBlue
                                : PortColor.gray,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextConst(
                            title: selectedIndex != null
                                ? "Proceed with ${selectVehiclesViewModel.selectVehiclesModel?.data![selectedIndex!].name ?? ""}"
                                : "Select a Vehicle",
                            color: PortColor.white,
                          ),
                        )),
                  ),
                ),
              ]),
            )));
  }
}
