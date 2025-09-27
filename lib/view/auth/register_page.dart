import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_btn.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view/auth/login_page.dart';
import 'package:port_karo/view_model/register_view_model.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isSelected = false;
  dynamic selectedRadioValue;
  String? selectedBusinessUsage; // For dropdown value

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, String>> businessUsageOptions = [
    {
      "title": "Personal Needs",
      "description": "Items like tiffins, furniture, documents etc",
      "id": "1",
    },
    {
      "title": "Business Needs",
      "description": "Goods like plywood, marbles, electronics etc",
      "id": "2",
    },
    {
      "title": "Packers & Movers",
      "description": "End to End house shifting Solution",
      "id": "3",
    },
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController =
  //   AnimationController(vsync: this, duration: const Duration(seconds: 3))
  //     ..repeat(reverse: true);
  //
  //   _animation = Tween<double>(
  //     begin: -50,
  //     end: 50,
  //   ).animate(CurvedAnimation(
  //     parent: _animationController,
  //     curve: Curves.easeInOut,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    Map arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final registerViewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: PortColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: screenHeight * 0.11,
                  width: screenWidth * 0.6,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.assetsYoyoMilesRemoveBg),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.018),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(Assets.assetsIndiaflagsquare),
                    height: screenHeight * 0.023,
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  TextConst(
                    title: arguments["mobileNumber"],
                    color: PortColor.black,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: TextConst(
                      title: "CHANGE",
                      color: PortColor.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: PortColor.portKaro,
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: PortColor.gray,
                          fontFamily: AppFonts.kanitReg,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: PortColor.gray),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: PortColor.gray),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  Expanded(
                    child: TextFormField(
                      cursorColor: PortColor.portKaro,
                      controller: lastnameController,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: PortColor.gray,
                          fontFamily: AppFonts.kanitReg,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: PortColor.gray),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: PortColor.gray),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                cursorColor: PortColor.portKaro,
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email Id",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: PortColor.gray,
                    fontFamily: AppFonts.kanitReg,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: PortColor.gray),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PortColor.gray),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.035),

              // 🔹 Business Usage Dropdown - Added this section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextConst(
                    title: "Requirement",
                    size: 14,
                    color: PortColor.gray,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.kanitReg,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: PortColor.gray, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedBusinessUsage,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        hint: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                          ),
                          child: TextConst(
                            title: "Select Business Usage",
                            color: PortColor.gray,
                            size: 14,
                            fontFamily: AppFonts.poppinsReg,
                          ),
                        ),
                        items: businessUsageOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option["id"],
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextConst(
                                    title: option["title"]!,
                                    color: PortColor.black,
                                    size: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.poppinsReg,
                                  ),
                                  TextConst(
                                    title: option["description"]!,
                                    color: PortColor.gray,
                                    fontFamily: AppFonts.poppinsReg,
                                    size: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBusinessUsage = newValue;
                            selectedRadioValue =
                                newValue; // Also set radio value for backward compatibility
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),

              Center(
                child: TextConst(
                  title: "Have referral code?",
                  color: PortColor.gold,
                  size: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.poppinsReg,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
        AppBtn(title: "Register", onTap: (){
          if (nameController.text.isEmpty) {
            Utils.showErrorMessage(context, "Please enter First Name");
          } else if (lastnameController.text.isEmpty) {
            Utils.showErrorMessage(context, "Please enter Last Name");
          } else if (emailController.text.isEmpty) {
            Utils.showErrorMessage(
              context,
              "Please enter Email Address",
            );
          } else if (selectedBusinessUsage == null) {
            Utils.showErrorMessage(
              context,
              "Please select Business Usage",
            );
          } else {
            registerViewModel.registerApi(
              nameController.text,
              lastnameController.text,
              emailController.text,
              arguments["mobileNumber"],
              selectedBusinessUsage!,
              "111adf",
              context,
            );
          }
        }),
              Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Row(
                  children: [
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          isSelected = value!;
                        });
                      },
                      activeColor: PortColor.gold,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Allow Porter to send updates on ",
                              style: TextStyle(
                                color: PortColor.black,
                                fontSize: 12,
                                fontFamily: AppFonts.kanitReg,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Image.asset(
                                Assets.assetsWhatsappIcon,
                                width: 17,
                                height: 17,
                              ),
                            ),
                            TextSpan(
                              text: "WhatsApp ",
                              style: TextStyle(
                                color: PortColor.gold,
                                fontSize: 12,
                                fontFamily: AppFonts.kanitReg,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 OTP Message
              TextConst(
                title:
                    "A one time password (OTP) will be sent to this number for verification.",
                color: PortColor.gray,
                size: 12,
                textAlign: TextAlign.center,
                fontFamily: AppFonts.kanitReg,
              ),

              // 🔹 Register Button

            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(String title, String subtitle, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: screenHeight * 0.08,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        border: Border.all(color: PortColor.gray, width: screenWidth * 0.002),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: selectedRadioValue,
            onChanged: (newValue) {
              setState(() {
                selectedRadioValue = newValue;
                selectedBusinessUsage = newValue
                    .toString(); // Sync with dropdown
              });
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextConst(
                title: title,
                color: PortColor.black,
                size: 12,
                fontWeight: FontWeight.w500,
              ),
              TextConst(title: subtitle, color: PortColor.gray, size: 10),
            ],
          ),
        ],
      ),
    );
  }
}
