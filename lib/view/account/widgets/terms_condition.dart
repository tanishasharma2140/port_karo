import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view/account/widgets/terms/privacy_policy.dart';

import 'terms/terms_and_condition.dart';
class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
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
                    width: screenWidth * 0.04,
                  ),
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
                  SizedBox(
                    width: screenWidth * 0.2,
                  ),
                  TextConst(
                    title: "Terms and Condition",
                    color: PortColor.black,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.036,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04,vertical: screenHeight*0.02),
              height: screenHeight*0.13,
              width: screenWidth,
              color: PortColor.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndCondition()));
                          },
                          child: Container(child: TextConst(title: "Terms and Condition",color: PortColor.black))),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,size: screenHeight*0.015,),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.007,),
                  Divider(thickness: screenWidth*0.002,color: PortColor.grey,),
                  SizedBox(height: screenHeight*0.007,),

                  Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyPolicy()));
                          },
                          child: Container(child: TextConst(title: "Privacy and policy",color: PortColor.black))),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,size: screenHeight*0.015,),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      
      ),
    );
  }
}
