import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/res/launcher.dart';
import 'package:port_karo/view_model/help_and_support_view_model.dart';
import 'package:provider/provider.dart';

class HelpSupport extends StatefulWidget {
  const HelpSupport({super.key});

  @override
  State<HelpSupport> createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final helpAndSupportViewModel =
          Provider.of<HelpAndSupportViewModel>(context, listen: false);
      helpAndSupportViewModel.helpSupportApi();
      //print("helpSupport");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final helpAndSupportViewModel = Provider.of<HelpAndSupportViewModel>(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 14),
              height: screenHeight * 0.096,
              width: screenWidth,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset:  Offset(0, 3),
                  ),
                ],
                color: PortColor.white,
              ),
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.04),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: PortColor.black,
                      size: screenHeight * 0.025,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.25),
                  TextConst(
                    title: "Contact Support",
                    color: PortColor.black,
                  ),
                ],
              ),
            ),
            Padding(

              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.023,
              ),
              child: TextConst(
                title: "Need help with your orders?",
                color: PortColor.black.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                width: screenWidth * 0.88,
                decoration: BoxDecoration(
                  color: PortColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Container(
                    width: screenWidth * 0.88,
                    decoration: BoxDecoration(
                      color: PortColor.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(),
                          leading: Image.asset(Assets.assetsBiketruck),
                          title: TextConst(
                            title: 'Trucks and 2 Wheelers',
                            color: PortColor.black,
                          ),
                          trailing: GestureDetector(
                            onTap: () =>
                                Launcher.launchDialPad(context, '9876543210'),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: const BoxDecoration(
                                color: PortColor.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.call_outlined,
                                color: PortColor.gold,
                                size: screenHeight * 0.025,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(),
                          leading: Image.asset(Assets.assetsDeliveryman),
                          title: TextConst(
                            title: 'Packers and Movers',
                            color: PortColor.black,
                          ),
                          trailing: GestureDetector(
                            onTap: () =>
                                Launcher.launchDialPad(context, '1234567890'),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: const BoxDecoration(
                                color: PortColor.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.call_outlined,
                                color: PortColor.gold,
                                size: screenHeight * 0.025,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(),
                          leading: Image.asset(Assets.assetsMap),
                          title: TextConst(
                            title: 'All India Parcel',
                            color: PortColor.black,
                          ),
                          trailing: GestureDetector(
                            onTap: () =>
                                Launcher.launchDialPad(context, '1122334455'),
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: const BoxDecoration(
                                color: PortColor.grey,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.call_outlined,
                                color: PortColor.gold,
                                size: screenHeight * 0.025,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                height: screenHeight * 0.08,
                width: screenWidth * 0.88,
                decoration: BoxDecoration(
                  color: PortColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    TextConst(
                      title: "Any Other question?\nCall or Mail us !",
                      color: PortColor.black,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Launcher.launchEmail(
                          context, 'foundercodetechteam@gmail.com'),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: PortColor.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mail_outline,
                          color: PortColor.gold,
                          size: screenHeight * 0.025,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    GestureDetector(
                      onTap: () =>
                          Launcher.launchDialPad(context, '1122334455'),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: const BoxDecoration(
                          color: PortColor.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.call_outlined,
                          color: PortColor.gold,
                          size: screenHeight * 0.025,
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
    );
  }
}
