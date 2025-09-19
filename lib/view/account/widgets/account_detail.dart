import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_constant.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/res/launcher.dart';
import 'package:port_karo/view/account/widgets/help_support.dart';
import 'package:port_karo/view/account/widgets/save_address_detail.dart';
import 'package:port_karo/view/account/widgets/terms_condition.dart';
import 'package:port_karo/view/coins/coins.dart';
import 'package:port_karo/view/splash_screen.dart';
import 'package:port_karo/view_model/user_view_model.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        children: [
          SizedBox(height: screenHeight * 0.03),
          Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(10.0),
              shadowColor: PortColor.grey.withOpacity(0.5),
              color: PortColor.white,
              child: buttonLayoutUi(
                context,
                Icons.favorite_border,
                "Saved Address",
                page: const SaveAddressDetail(),
              )),
          SizedBox(height: screenHeight * 0.02),
          TextConst(title: "Benefits", color: PortColor.gray),
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: screenHeight * 0.19,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025, vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: PortColor.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: PortColor.grayLight.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                buttonLayoutUi(
                  page: const CoinsPage(),
                  context,
                  Icons.star_border_purple500_outlined,
                  "Courier Rewards",
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          color: PortColor.white,
                          border: Border.all(
                              color: PortColor.gray.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage(Assets.assetsCoin48),
                              height: screenHeight * 0.025,
                            ),
                            TextConst(title: "0", color: PortColor.black),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: PortColor.black,
                        size: screenHeight * 0.02,
                      ),
                    ],
                  ),
                ),
                buttonLayoutUi(
                  context,
                  Icons.share,
                  "Refer your Friends!",
                  trailing: GestureDetector(
                    onTap: () {
                      Launcher.shareApk(AppConstant.apkUrl, context);
                    },
                    child: Container(
                      height: screenHeight * 0.03,
                      width: screenWidth * 0.16,
                      decoration: BoxDecoration(
                        color: PortColor.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.share,
                            color: PortColor.blue,
                            size: screenHeight * 0.02,
                          ),
                          const SizedBox(width: 4.0),
                          TextConst(
                            title: "Invite",
                            color: PortColor.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextConst(title: "Support and Legal", color: PortColor.gray),
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: screenHeight * 0.19,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025, vertical: screenHeight * 0.02),
            decoration: BoxDecoration(
              color: PortColor.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: PortColor.grayLight.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                buttonLayoutUi(context, Icons.help_outline, "Help & Support",
                    page: const HelpSupport()),
                buttonLayoutUi(context, Icons.copy_all, "Terms and Condition",
                    page: const TermsCondition())
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextConst(title: "Settings", color: PortColor.gray),
          SizedBox(height: screenHeight * 0.02),
          Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: PortColor.grey.withOpacity(0.5),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              leading: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: PortColor.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: PortColor.blue,
                  size: screenHeight * 0.025,
                ),
              ),
              title: TextConst(title: "Log Out", color: PortColor.black),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: PortColor.black,
                size: screenHeight * 0.02,
              ),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: PortColor.white,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  builder: (BuildContext context) {
                    return logoutBottomSheet(context);
                  },
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          Center(
            child: TextConst(
                title: "App version ${AppConstant.appVersion}",
                color: PortColor.gray),
          ),
          SizedBox(height: screenHeight * 0.04),
        ],
      ),
    );
  }

  Widget logoutBottomSheet(context) {
    return Padding(
      padding: EdgeInsets.all(screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextConst(
              title: "Are you sure you want to log out?",
              color: PortColor.black),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: screenHeight * 0.058,
                  width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: PortColor.white,
                    border: Border.all(
                        color: PortColor.blue.withOpacity(0.75), width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: TextConst(
                        title: "No", color: PortColor.blue.withOpacity(0.75)),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              InkWell(
                onTap: () {
                  UserViewModel().remove();
                  // Navigator.pushReplacementNamed(context, RoutesName.splash);
                  // Navigator.pushNamedAndRemoveUntil(context, RoutesName.splash, (context)=>true);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()),
                      (context) => false);
                  //  Navigator.pushAndRemoveUntil(context, RoutesName.splash, (context)=>false);
                },
                child: Container(
                  height: screenHeight * 0.058,
                  width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: PortColor.blue.withOpacity(0.75),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: TextConst(title: "Yes", color: PortColor.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buttonLayoutUi(context, IconData icon, String label,
      {Widget? page, Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page!,
          ),
        );
      },
      leading: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: PortColor.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: PortColor.blue,
          size: screenHeight * 0.025,
        ),
      ),
      title: TextConst(
        title: label,
        color: PortColor.black,
        size: 12,
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: PortColor.black,
            size: screenHeight * 0.02,
          ),
    );
  }
}
