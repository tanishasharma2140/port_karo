import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view/account/widgets/add_gst_detail.dart';
import 'package:port_karo/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';
import 'constant_color.dart';
class ConstantAppbar extends StatefulWidget {
  const ConstantAppbar({super.key,});
  @override
  State<ConstantAppbar> createState() => _ConstantAppbarState();
}
class _ConstantAppbarState extends State<ConstantAppbar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      profileViewModel.profileApi(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    return  Container(
      decoration: const BoxDecoration(
        color: PortColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 0.5,
            blurRadius: 3,
            offset:  Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.05,vertical: screenHeight*0.045),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              TextConst(title: " ${profileViewModel.profileModel?.data!.firstName?? ""} ${profileViewModel.profileModel?.data!.lastName?? ""}", color: PortColor.black),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddGstDetail()));
                  },
                  child: TextConst(title: "Edit Profile", color: PortColor.gold)),
            ],
          ),
          SizedBox(height: screenHeight*0.001),
          TextConst(
            title: " ${profileViewModel.profileModel?.data!.email?? ""}",
            color: PortColor.gray,
          ),
          SizedBox(height: screenHeight*0.001),
          TextConst(title: "Verify Email ID", color: PortColor.gold),
          SizedBox(height: screenHeight*0.02,),
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddGstDetail(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: screenHeight*0.05,
              decoration: BoxDecoration(
                color: PortColor.gold.withOpacity(0.1),
                border: Border.all(color: PortColor.gold,width: 0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: TextConst(title:
                "Add GST Details",color: PortColor.gold,
                  fontFamily: AppFonts.kanitReg,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

