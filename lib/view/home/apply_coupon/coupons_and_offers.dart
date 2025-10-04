import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view_model/apply_coupon_view_model.dart';
import 'package:port_karo/view_model/coupon_list_view_model.dart';
import 'package:port_karo/view_model/service_type_view_model.dart';
import 'package:port_karo/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class CouponsAndOffers extends StatefulWidget {
  final String price;
  const CouponsAndOffers({super.key, required this.price});

  @override
  State<CouponsAndOffers> createState() => _CouponsAndOffersState();
}

class _CouponsAndOffersState extends State<CouponsAndOffers> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserViewModel userViewModel = UserViewModel();
      String? userId = await userViewModel.getUser();
      final serviceTypeViewModel = Provider.of<ServiceTypeViewModel>(
        context,
        listen: false,
      );
      final couponListVm = Provider.of<CouponListViewModel>(
        context,
        listen: false,
      );
      couponListVm.couponListApi(
        userId.toString(),
        serviceTypeViewModel.selectedVehicleId!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final applyCoupon = Provider.of<ApplyCouponViewModel>(context);
    return Scaffold(
      backgroundColor: PortColor.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPadding),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.transparent,
                        child: Icon(Icons.arrow_back, size: 16),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TextConst(
                      title: "Coupons & Offers",
                      color: PortColor.black,
                      fontFamily: AppFonts.kanitReg,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 36),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _couponController,
                            decoration: const InputDecoration(
                              hintText: 'Enter code here',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          applyCoupon.applyCouponApi(
                            _couponController.text,
                            widget.price,
                            context,
                          );
                        },
                        child: Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Entered code apply logic
                            },
                            child: Text(
                              'APPLY',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.kanitReg,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              "More Offers:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

          /// Coupons List OR Loader
          Expanded(
            child: Consumer<CouponListViewModel>(
              builder: (context, couponList, _) {
                if (couponList.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (couponList.couponListModel == null ||
                    couponList.couponListModel!.data == null ||
                    couponList.couponListModel!.data!.isEmpty) {
                  return const Center(child: Text("No Coupons Available"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: couponList.couponListModel!.data!.length,
                  itemBuilder: (context, index) {
                    final couponListOffer =
                        couponList.couponListModel!.data![index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: PortColor.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              /// Coupon Code box
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(5),
                                dashPattern: const [6, 3],
                                color: Colors.grey.shade400,
                                strokeWidth: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  color: Colors.grey.shade50,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.percent,
                                        size: 16,
                                        color: Colors.black54,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        height: 13,
                                        width: 1,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Flex(
                                              direction: Axis.vertical,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                4,
                                                (index) => SizedBox(
                                                  height: 2,
                                                  child: Container(
                                                    color: index.isEven
                                                        ? Colors.grey
                                                        : Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        couponListOffer.couponCode!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontFamily: AppFonts.kanitReg,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Spacer(),

                              /// Apply Button
                              GestureDetector(
                                onTap: couponListOffer.claimStatus == 1
                                    ? () {
                                        applyCoupon.applyCouponApi(
                                          couponListOffer.couponCode,
                                          widget.price,
                                          context,
                                        );
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: couponListOffer.claimStatus == 1
                                        ? PortColor.gold
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "APPLY",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: couponListOffer.claimStatus == 1
                                          ? Colors.black
                                          : Colors.black38,
                                      fontFamily: AppFonts.kanitReg,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          /// Title
                          Text(
                            couponListOffer.offerTitle!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: AppFonts.kanitReg,
                            ),
                          ),
                          const SizedBox(height: 4),

                          /// Description
                          Text(
                            couponListOffer.offerName!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontFamily: AppFonts.kanitReg,
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// Valid Date
                          Text(
                            "valid till: ${couponListOffer.validDate}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: AppFonts.kanitReg,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
