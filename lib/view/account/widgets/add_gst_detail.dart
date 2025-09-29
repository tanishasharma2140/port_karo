import 'package:flutter/material.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/view_model/profile_update_view_model.dart';
import 'package:provider/provider.dart';
import '../../../view_model/profile_view_model.dart';

class AddGstDetail extends StatefulWidget {
  const AddGstDetail({super.key});
  @override
  State<AddGstDetail> createState() => _AddGstDetailState();
}

class _AddGstDetailState extends State<AddGstDetail> {
  String _availability = "Available";
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController gstINController = TextEditingController();
  final TextEditingController gstRegistrationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileUpdateViewModel = Provider.of<ProfileUpdateViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: PortColor.bg,
        body: SingleChildScrollView(
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 15,right: 14,left: 14),
                  height: screenHeight * 0.095,
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
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          profileUpdateViewModel.profileUpdateApi(
                            firstnameController.text,
                            lastnameController.text,
                            emailIdController.text,
                            profileViewModel.profileModel!.data!.phone.toString(),
                            gstINController.text,
                            gstRegistrationController.text,
                            context,
                          );
                        },
                        child: TextConst(
                          title: "Saved",
                          color: PortColor.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.045, top: screenHeight * 0.02),
                  child: TextConst(
                      title: "Mobile Number", color: PortColor.gray,fontFamily: AppFonts.kanitReg,),
                ),
                SizedBox(height: screenHeight * 0.003),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.045, bottom: screenHeight * 0.01),
                  child: Row(
                    children: [
                      TextConst(title: '${profileViewModel.profileModel!.data!.phone??""}', color: PortColor.black),
                      SizedBox(width: screenWidth * 0.02),
                      TextConst(
                          title: "Cannot be changed", color: PortColor.gray,fontFamily: AppFonts.poppinsReg,),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.035),
                    height: _availability == "Available"
                        ? screenHeight * 0.63
                        : screenHeight * 0.47,
                    decoration: BoxDecoration(
                      color: PortColor.white,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: firstnameController,
                          decoration: InputDecoration(
                            hintText: profileViewModel
                                    .profileModel?.data?.firstName ??
                                "",
                            hintStyle: TextStyle(
                              color: PortColor.black.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        TextField(
                          controller: lastnameController,
                          decoration: InputDecoration(
                            hintText:
                                profileViewModel.profileModel?.data?.lastName ??
                                    "",
                            hintStyle: TextStyle(
                              color: PortColor.black.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        TextField(
                          controller: emailIdController,
                          decoration: InputDecoration(
                            hintText:
                                profileViewModel.profileModel?.data?.email ??
                                    "",
                            hintStyle: TextStyle(
                              color: PortColor.black.withOpacity(0.7),
                              fontSize: 16,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PortColor.grey,
                                width: screenWidth * 0.002,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        TextConst(
                            title: "GST Details",
                            color: PortColor.black.withOpacity(0.7)),
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          children: [
                            TextConst(
                                title: _availability, color: PortColor.black),
                            const Spacer(),
                            PopupMenuButton<String>(
                              color: PortColor.white,
                              icon: const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: PortColor.black,
                              ),
                              onSelected: (String value) {
                                setState(() {
                                  _availability = value;
                                });
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Available',
                                  child: Text('Available'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Not available',
                                  child: Text('Not available'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (_availability == "Available") ...[
                          TextField(
                            controller: gstINController,
                            decoration: InputDecoration(
                              hintText: "GSTIN No",
                              hintStyle: TextStyle(
                                  color: PortColor.black.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: PortColor.grey,
                                  width: screenWidth * 0.002,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: PortColor.grey,
                                  width: screenWidth * 0.002,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextField(
                            controller: gstRegistrationController,
                            decoration: InputDecoration(
                              hintText: "GST Registration Address ",
                              hintStyle: TextStyle(
                                  color: PortColor.black.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: PortColor.grey,
                                  width: screenWidth * 0.002,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: PortColor.grey,
                                  width: screenWidth * 0.002,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              ],
            ),

        ),
      ),
    );
  }
}

