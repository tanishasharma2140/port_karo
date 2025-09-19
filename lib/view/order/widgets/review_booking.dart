import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view_model/order_view_model.dart';
import 'package:port_karo/view_model/select_vehicles_view_model.dart';
import 'package:provider/provider.dart';

class ReviewBooking extends StatefulWidget {
  final int? index;
  final String price;
  final String distance;
  const ReviewBooking({super.key, this.index, required this.price, required this.distance, });

  @override
  State<ReviewBooking> createState() => _ReviewBookingState();
}

class _ReviewBookingState extends State<ReviewBooking> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String PaymentMethod = "";
  @override
  Widget build(BuildContext context) {
     final orderViewModel = Provider.of<OrderViewModel>(context);
    // final selectVehiclesViewModel =
    // Provider.of<SelectVehiclesViewModel>(context);
    final vehicle = Provider.of<SelectVehiclesViewModel>(context).selectVehiclesModel!.data![widget.index!];
    return Scaffold(
      backgroundColor: PortColor.grey,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.009),
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
                SizedBox(width: screenWidth * 0.04),
                TextConst(
                  title: "Review Booking",
                  color: PortColor.black,
                  fontFamily: AppFonts.kanitReg,
                  size: 15,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.035, vertical: screenHeight * 0.02),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.018),
              height: screenHeight * 0.17,
              decoration: BoxDecoration(
                  color: PortColor.white,
                  borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],),

              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        vehicle.image.toString(),
                        height: screenHeight * 0.065,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Assets.assetsPortericon,
                            height: screenHeight * 0.065,
                          );
                        },
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextConst(
                              title: vehicle.name.toString(), color: PortColor.black,fontFamily: AppFonts.poppinsReg,),
                          TextConst(
                              title: "View Address detail", color: Colors.blue,fontFamily: AppFonts.poppinsReg,),
                        ],
                      ),
                      // Spacer(),
                      // TextConst(text: " 14 mins ", color: Colors.green),
                      // TextConst(text: "away", color: Colors.black),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          PortColor.lightGreen,
                          PortColor.lightGreen2,
                          PortColor.white,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.alarm,
                          size: screenHeight * 0.018,
                        ),
                        SizedBox(
                          width: screenWidth * 0.01,
                        ),
                        TextConst(
                            title: "Free",
                            color: PortColor.black.withOpacity(0.6),fontFamily: AppFonts.poppinsReg,size: 12,),
                        TextConst(title: " 70 mins ", color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                        TextConst(
                            title: "of loading and unloading tome include.",
                            color: PortColor.black.withOpacity(0.6),fontFamily: AppFonts.poppinsReg,size: 12,),
                        // Icon(
                        //   Icons.info_outline,
                        //   color: PortColor.blue,
                        //   size: screenHeight * 0.025,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child: TextConst(title: "Fare Summary", color: PortColor.black,fontFamily: AppFonts.kanitReg,),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.028),
              height: screenHeight * 0.27,
              decoration: BoxDecoration(
                color: PortColor.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextConst(
                          title: "Trip Fare",
                          color: PortColor.black.withOpacity(0.8),fontFamily: AppFonts.poppinsReg,size: 12,),
                      TextConst(
                          title: " (incl.Toll)",
                          color: PortColor.black.withOpacity(0.5),fontFamily: AppFonts.poppinsReg,size: 12),
                      const Spacer(),
                      TextConst(title: "₹${(widget.price)}", color: PortColor.black,fontFamily: AppFonts.poppinsReg,size: 12),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.012,
                  ),
                  Row(
                    children: [
                      TextConst(
                        title: "GST (18%)",
                        color: PortColor.black.withOpacity(0.8),
                        fontFamily: AppFonts.poppinsReg,
                          size: 12
                      ),
                      const Spacer(),
                      TextConst(
                        title: "₹${(double.parse(widget.price) * 0.18).toStringAsFixed(0)}",
                        color: Colors.green,
                        fontFamily: AppFonts.poppinsReg,
                          size: 12
                      ),
                    ],
                  ),

                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const Divider(),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Row(
                    children: [
                      TextConst(
                          title: "Net Fare",
                          color: PortColor.black.withOpacity(0.8),fontFamily: AppFonts.poppinsReg,size: 12),
                      const Spacer(),
                      TextConst(
                          title: "₹${(double.parse(widget.price) + (double.parse(widget.price) * 0.18)).toStringAsFixed(0)}",
                          color: PortColor.black,fontFamily: AppFonts.poppinsReg,size: 12),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  const Divider(),
                  SizedBox(
                    height: screenHeight * 0.005,
                  ),
                  Row(
                    children: [
                      TextConst(
                          title: "Amount Payable",
                          color: PortColor.black.withOpacity(0.8),fontFamily: AppFonts.poppinsReg,size: 12),
                      TextConst(
                          title: " (rounded)",
                          color: PortColor.black.withOpacity(0.5),fontFamily: AppFonts.poppinsReg,size: 12),
                      const Spacer(),
                      TextConst(title: "₹${(double.parse(widget.price) + (double.parse(widget.price) * 0.18)).toStringAsFixed(0)}",
                           color: PortColor.black,fontFamily: AppFonts.poppinsReg,size: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: screenHeight * 0.02,
          // ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: screenWidth * 0.03,
          //         vertical: screenHeight * 0.015),
          //     height: screenHeight * 0.08,
          //     decoration: BoxDecoration(
          //       color: PortColor.white,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.2),
          //           spreadRadius: 0.5,
          //           blurRadius: 3,
          //           offset: const Offset(0, 1),
          //         ),
          //       ],
          //     ),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         TextConst(text: "Goods Type", color: PortColor.gray),
          //         Row(
          //           children: [
          //             TextConst(
          //                 text: "General loose ", color: PortColor.black),
          //             Spacer(),
          //             TextConst(text: " Change ", color: Colors.blue),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child:
                TextConst(title: "Read before booking", color: PortColor.black,fontFamily: AppFonts.kanitReg,),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextConst(
                      title:
                          '• Fare doesn\'t include labour charges for loading & unloading',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title:
                          '• Fare includes 70 mins free loading/unloading time.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title:
                          '• ₹ 3.5/min for additional loading/unloading time.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title: '• Fare may change if route or location changes.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title: '• Parking charges to be paid by customer.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title: '• Fare includes toll and permit charges, if any.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                  const SizedBox(height: 8),
                  TextConst(
                      title: '• We don\'t allow overloading.',
                      color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 12,),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.007,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.035),
            child:
            TextConst(title: "Pay Mode", color: PortColor.black,fontFamily: AppFonts.kanitReg,),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
           Padding(
             padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.035),
             child: Container(
               padding: EdgeInsets.symmetric(
                   horizontal: screenWidth * 0.03,
                   vertical: screenHeight * 0.02),
               decoration: BoxDecoration(
                 color: PortColor.white,
                 borderRadius: const BorderRadius.all(Radius.circular(10)),
                 boxShadow: [BoxShadow(
                   color: Colors.grey.withOpacity(0.2),
                   spreadRadius: 0.5,
                   blurRadius: 3,
                   offset: const Offset(0, 1),
                 ),
                 ],
               ),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   GestureDetector(
                     onTap: () {
                       setState(() {
                         PaymentMethod = "1";
                       });
                     },
                     child: Row(
                       children: [
                         Expanded(
                           child: TextConst(
                             title: "Pay Via Cash",
                             color: PortColor.black,
                             fontFamily: AppFonts.poppinsReg,
                             size: 13,
                           ),
                         ),
                         if (PaymentMethod == "1")
                           const Icon(
                             Icons.check_circle,
                             color: Colors.green,
                           ),
                       ],
                     ),
                   ),
                   SizedBox(
                     height: screenHeight * 0.01,
                   ),
                   const Divider(),
                   SizedBox(
                     height: screenHeight * 0.01,
                   ),
                   GestureDetector(
                     onTap: () {
                       setState(() {
                         PaymentMethod = "2";
                       });
                     },
                     child: Row(
                       children: [
                         Expanded(
                           child: TextConst(
                             title: "Pay Via PG",
                             color: PortColor.black,
                             fontFamily: AppFonts.poppinsReg,
                             size: 13,
                           ),
                         ),
                         if (PaymentMethod == "2")
                           const Icon(
                             Icons.check_circle,
                             color: Colors.green,
                           ),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
          SizedBox(height: screenHeight*0.2,),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.025,vertical: screenHeight*0.012),
        height: screenHeight * 0.17,
        color: PortColor.white,
        child: Column(
          children: [
            Row(
              children: [
                Image(
                  image: const AssetImage(Assets.assetsRupeetwo),
                  height: screenHeight * 0.04,
                ),
                TextConst(
                    title: " Payment", color: PortColor.black),
                const Spacer(),
                TextConst(title: "₹${(double.parse(widget.price) + (double.parse(widget.price) * 0.18)).toStringAsFixed(0)}",
                     color: PortColor.black),
              ],
            ),
            SizedBox(height: screenHeight*0.014,),
            InkWell(
              onTap: (){

                if (PaymentMethod.isEmpty) {
              Utils.showErrorMessage(context, "Please select PayMode");
                }else {
                  orderViewModel.orderApi(
                      vehicle.id.toString(),
                      orderViewModel.pickupData["address"],
                      orderViewModel.dropData["address"],
                      orderViewModel.dropData["latitude"],
                      orderViewModel.dropData["longitude"],
                      orderViewModel.pickupData["latitude"],
                      orderViewModel.pickupData["longitude"],
                      orderViewModel.pickupData["name"],
                      orderViewModel.pickupData["phone"],
                      orderViewModel.dropData["name"],
                      orderViewModel.dropData["phone"],
                      widget.price,
                      widget.distance,
                      PaymentMethod,
                      context);
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: screenHeight * 0.07,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: PortColor.buttonBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: !orderViewModel.loading?
                    TextConst(
                        title: "Book ${vehicle.name.toString()}", color: PortColor.white): CupertinoActivityIndicator(radius: 16,color: PortColor.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget payment({required String text, required Color color}) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: color),
    );
  }
}
