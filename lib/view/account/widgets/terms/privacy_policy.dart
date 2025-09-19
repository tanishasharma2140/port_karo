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
      child: Scaffold(
        backgroundColor: PortColor.grey,
        body: Column(
          children: [
            Container(
              height: screenHeight * 0.06,
              width: screenWidth,
              decoration: BoxDecoration(
                color: PortColor.white,
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
