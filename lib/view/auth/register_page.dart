import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
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

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, String>> options = [
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

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -50,
      end: 50,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final registerViewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFB3E5FC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: Container(
                          height: screenHeight * 0.11,
                          width: screenWidth * 0.6,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.assetsPortKaroLogo),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      );
                    },
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
                        title: arguments["mobileNumber"], color: PortColor.black),
                    SizedBox(width: screenWidth * 0.03),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child:
                      TextConst(title: "CHANGE", color: PortColor.blue),
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
                          hintStyle:
                          TextStyle(fontSize: 16, color: PortColor.gray),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: PortColor.gray),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: PortColor.gray),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
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
                          hintStyle:
                          TextStyle(fontSize: 16, color: PortColor.gray),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: PortColor.gray),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: PortColor.gray),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
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
                    hintStyle: TextStyle(fontSize: 16, color: PortColor.gray),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: PortColor.gray),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: PortColor.gray),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                TextConst(title: "Have referral code?", color: PortColor.blue,size: 12,fontWeight: FontWeight.w600,),
                SizedBox(height: screenHeight * 0.03),

                TextConst(
                    title: "I will be using Porter for:",size: 14,
                    color: PortColor.black),
                SizedBox(height: screenHeight * 0.015),

                // 🔹 Options
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final data = options[index];
                    return buildOption(
                      data["title"].toString(),
                      data["description"].toString(),
                      data["id"].toString(),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),

                // 🔹 Register Button
                GestureDetector(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      Utils.showErrorMessage(context, "Please enter First Name");
                    } else if (lastnameController.text.isEmpty) {
                      Utils.showErrorMessage(context, "Please enter Last Name");
                    } else if (emailController.text.isEmpty) {
                      Utils.showErrorMessage(
                          context, "Please enter Email Address");
                    } else if (selectedRadioValue == null) {
                      Utils.showErrorMessage(
                          context, "Please select an option");
                    } else {
                      registerViewModel.registerApi(
                        nameController.text,
                        lastnameController.text,
                        emailController.text,
                        arguments["mobileNumber"],
                        selectedRadioValue,
                        "111adf",
                        context,
                      );
                    }
                  },
                  child: Container(
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [PortColor.portMan, PortColor.portManLight],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: PortColor.portMan.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: !registerViewModel.loading
                        ? TextConst(title: "Register", color: PortColor.white)
                        : const CupertinoActivityIndicator(radius: 16,color: PortColor.white,),
                  ),
                ),
              ],
            ),
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
        border: Border.all(
          color: PortColor.gray,
          width: screenWidth * 0.002,
        ),
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
              });
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextConst(title: title, color: PortColor.black, size: 12,fontWeight: FontWeight.w500,),
              TextConst(title: subtitle, color: PortColor.gray, size: 10),
            ],
          ),
        ],
      )

    );
  }
}
