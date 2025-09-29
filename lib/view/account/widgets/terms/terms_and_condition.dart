import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view_model/terms_and_condition_view_model.dart';
import 'package:provider/provider.dart';
class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final termConditionViewModel =
      Provider.of<TermAndConditionViewModel>(context, listen: false);
      termConditionViewModel.termConditionApi();
      print("I am the....");
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
                  SizedBox(width: screenWidth * 0.06),
                  SizedBox(width: screenWidth * 0.24),
                  TextConst(
                    title: "Terms and Condition",
                    color: PortColor.black,
                  ),
                  SizedBox(width: screenWidth * 0.16),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.dangerous_outlined),
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
