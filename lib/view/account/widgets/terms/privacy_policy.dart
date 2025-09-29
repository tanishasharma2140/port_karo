import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view_model/privacy_policy_view_model.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}
class _PrivacyPolicyState extends State<PrivacyPolicy> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final privacyPolicyViewModel =
      Provider.of<PrivacyPolicyViewModel>(context, listen: false);
      privacyPolicyViewModel.privacyPolicyApi();
      print("I am the....don");
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 17),
              height: screenHeight * 0.085,
              width: screenWidth,
              decoration: BoxDecoration(
                color: PortColor.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.06,
                  ),

                  SizedBox(
                    width: screenWidth * 0.24,
                  ),
                  TextConst(
                    title: "Privacy and Policy",
                    color: PortColor.black,
                  ),
                  SizedBox(
                    width: screenWidth * 0.22,
                  ),
                  InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.dangerous_outlined))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
