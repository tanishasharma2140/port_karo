import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view/payment/widgets/payment_porter_credit.dart';
import 'package:port_karo/view_model/add_wallet_view_model.dart';
import 'package:provider/provider.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final TextEditingController _controller = TextEditingController();
  bool isProceedEnabled = false;
  bool isBottomSheetVisible = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateProceedButton() {
    setState(() {
      isProceedEnabled =
          _controller.text.isNotEmpty && int.tryParse(_controller.text) != null;
    });
  }

  void _addAmount(int amount) {
    int currentAmount = int.tryParse(_controller.text) ?? 0;
    int newAmount = currentAmount + amount;
    _controller.text = newAmount.toString();
    _updateProceedButton();
  }

  Widget _quickAddButton(String label, int amount) {
    return GestureDetector(
      onTap: () => _addAmount(amount),
      child: Container(
        height: screenHeight * 0.04,
        width: screenWidth * 0.14,
        decoration: BoxDecoration(
          color: PortColor.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: TextConst(
            title: label,
            color: PortColor.blue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addWalletViewModel = Provider.of<AddWalletViewModel>(context);

    return PopScope(
      onPopInvokedWithResult: (val, res) {
        if (isBottomSheetVisible) {
          setState(() {
            isBottomSheetVisible = false;
          });
        }
      },
      child: Stack(
        children: [
          /// Main Body
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: ListView(
              children: [
                TextConst(title: "Payment", color: PortColor.black,fontFamily: AppFonts.kanitReg,size: 16,),
                SizedBox(height: screenHeight * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const PaymentPorterCredit(),
                              ),
                            );
                          },
                          child: TextConst(
                            title: "Courier credits",
                            color: PortColor.black,
                            fontFamily: AppFonts.poppinsReg,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBottomSheetVisible = true;
                            });
                          },
                          child: Container(
                            height: screenHeight * 0.04,
                            width: screenWidth * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: PortColor.gray.withOpacity(0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextConst(
                                title: 'Add Money',
                                color: PortColor.blue,
                                fontFamily: AppFonts.poppinsReg,
                                size: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    TextConst(title: "Balance ₹0", color: PortColor.gray,size: 13,),
                    Divider(thickness: screenWidth * 0.001),
                  ],
                ),
              ],
            ),
          ),

          /// Bottom Sheet
          if (isBottomSheetVisible)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * 0.26,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: PortColor.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: PortColor.gray.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      TextConst(title: "Add Money", color: PortColor.black),
                      SizedBox(height: screenHeight * 0.014),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorColor: PortColor.gray,
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _updateProceedButton(),
                              decoration: InputDecoration(
                                hintText: 'Enter Amount',
                                hintStyle:
                                const TextStyle(color: PortColor.gray),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: PortColor.gray),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: PortColor.gray),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: PortColor.gray, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _quickAddButton("+500", 500),
                          SizedBox(width: screenWidth * 0.04),
                          _quickAddButton("+1000", 1000),
                          SizedBox(width: screenWidth * 0.04),
                          _quickAddButton("+2000", 2000),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.055),
                      GestureDetector(
                        onTap: isProceedEnabled
                            ? () {
                          double enteredAmount =
                              double.tryParse(_controller.text) ?? 0;
                          if (enteredAmount >= 10) {
                            addWalletViewModel.addWalletApi(
                                context, _controller.text);
                          } else {
                            Utils.showErrorMessage(
                                context, "Enter Amount At-least ₹10");
                          }
                        }
                            : null,
                        child: Container(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.88,
                          decoration: BoxDecoration(
                            color: isProceedEnabled
                                ? PortColor.blue
                                : PortColor.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: !addWalletViewModel.loading
                                ? TextConst(
                              title: "Proceed",
                              color: isProceedEnabled
                                  ? PortColor.white
                                  : PortColor.gray,
                            )
                                : const CircularProgressIndicator(
                              color: PortColor.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
