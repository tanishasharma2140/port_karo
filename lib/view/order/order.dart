import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view_model/user_history_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userHistoryViewModel =
      Provider.of<UserHistoryViewModel>(context, listen: false);
      userHistoryViewModel.userHistoryApi();
    });
  }

  String formatDateTime(String dateTimeStr) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userHistoryViewModel = Provider.of<UserHistoryViewModel>(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, left: 7),
          height: screenHeight * 0.088,
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextConst(title: "  Orders", color: PortColor.black,fontFamily: AppFonts.kanitReg, size: 14,),
          ),
        ),
        // Expanded to fill remaining screen
        Expanded(
          child: userHistoryViewModel.userHistoryModel != null &&
              userHistoryViewModel.userHistoryModel!.data!.isNotEmpty
              ? orderListUi()
              : noOrderFoundUi(),
        ),
      ],
    );
  }

  Widget orderListUi() {
    final userHistoryViewModel = Provider.of<UserHistoryViewModel>(context);
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: userHistoryViewModel.userHistoryModel!.data!.length,
      itemBuilder: (context, index) {
        final history = userHistoryViewModel.userHistoryModel!.data![index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.018),
              child: TextConst(title: "Past", color: PortColor.gray),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01),
              color: PortColor.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Image(
                        image: AssetImage(Assets.assetsBookingtruck),
                        height: 50,
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextConst(
                              title: history.vehicleType ?? "",
                              color: PortColor.black),
                          TextConst(
                            title: formatDateTime(history.datetime.toString()),
                            color: PortColor.gray,
                            fontFamily: AppFonts.poppinsReg,
                            size: 12,
                          ),
                        ],
                      ),
                      const Spacer(),
                      TextConst(
                          title: ("₹ ${history.amount?.toString() ?? ""}"),
                          color: PortColor.black),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: PortColor.gray,
                        size: screenHeight * 0.02,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.02),
                      decoration: BoxDecoration(
                        color: PortColor.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
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
                                        15,
                                            (index) => Container(
                                          width: screenWidth * 0.003,
                                          height: screenHeight * 0.0025,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          color: PortColor.gray,
                                        )),
                                  ),
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: PortColor.red,
                                    size: screenHeight * 0.024,
                                  ),
                                ],
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextConst(
                                        title: history.senderName ?? "",
                                        color: PortColor.black,
                                        fontFamily: AppFonts.kanitReg,
                                      ),
                                      SizedBox(width: screenWidth * 0.015),
                                      TextConst(
                                        title: history.senderPhone.toString(),
                                        color: PortColor.gray,
                                        fontFamily: AppFonts.poppinsReg,
                                        size: 13,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.7,
                                    child: TextConst(
                                      title: history.pickupAddress ?? "",
                                      color: PortColor.gray,
                                      fontFamily: AppFonts.poppinsReg,
                                      size: 12,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Row(
                                    children: [
                                      TextConst(
                                          title: history.reciverName ?? "",
                                          color: PortColor.black,
                                        fontFamily: AppFonts.kanitReg,
                                      ),
                                      SizedBox(width: screenWidth * 0.015),
                                      TextConst(
                                          title:
                                          history.reciverPhone.toString(),
                                          color: PortColor.gray,
                                        fontFamily: AppFonts.poppinsReg,
                                        size: 13,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.7,
                                    child: TextConst(
                                      title: history.dropAddress ?? "",
                                      color: PortColor.gray,
                                      fontFamily: AppFonts.poppinsReg,
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.08),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextConst(
                                    title: "Payment Status: ",
                                    color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                                TextConst(
                                    title: history.paymentStatus == 0
                                        ? "Pending"
                                        : history.paymentStatus == 1
                                        ? "Success"
                                        : history.paymentStatus == 2
                                        ? "Failed"
                                        : '',
                                    color: PortColor.gray,fontFamily: AppFonts.poppinsReg,size: 12,),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.006),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.08),
                            child: Row(
                              children: [
                                TextConst(title: "Pay Mode: ", color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                                TextConst(
                                  title: history.paymode == 1
                                      ? "Cash on Delivery"
                                      : history.paymode == 2
                                      ? "Online Payment"
                                      : "Nothing",
                                  color: PortColor.gray,
                                  fontFamily: AppFonts.poppinsReg,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.009),
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth * 0.02),
                        const Image(image: AssetImage(Assets.assetsRedcross)),
                        TextConst(title: "Cancelled", color: PortColor.red,fontFamily: AppFonts.kanitReg,),
                        const Spacer(),
                        Container(
                          alignment: Alignment.center,
                          height: screenHeight * 0.04,
                          width: screenWidth * 0.42,
                          decoration: BoxDecoration(
                            color: PortColor.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextConst(title: 'Book Again',color: PortColor.white,fontFamily: AppFonts.kanitReg,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget noOrderFoundUi() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.15),
            Container(
              height: screenHeight * 0.2,
              width: screenHeight * 0.2,
              decoration: const BoxDecoration(
                color: PortColor.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(Assets.assetsBox),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            TextConst(title: "No Orders !", color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 14,),
            SizedBox(height: screenHeight * 0.01),
            TextConst(
              title: 'Order history limited to last 2 years',
              color: PortColor.gray,
              fontFamily: AppFonts.poppinsReg,
              size: 12,
            ),
            TextConst(
              title: 'For older orders, contact our support team.',
              color: PortColor.gray,
              fontFamily: AppFonts.poppinsReg,
              size: 12,
            ),
            SizedBox(height: screenHeight * 0.025),
            InkWell(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: screenHeight * 0.05,
                width: screenWidth * 0.4,
                decoration: BoxDecoration(
                  color: PortColor.buttonBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextConst(title: 'Book Now',color: PortColor.white,fontFamily: AppFonts.kanitReg,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
