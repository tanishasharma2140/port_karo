import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_btn.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/const_loader.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
import 'package:port_karo/res/country.dart';
import 'package:port_karo/res/custom_text_field.dart';
import 'package:port_karo/utils/utils.dart';
import 'package:port_karo/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  Country _selectedCountry = Country(
    name: "India",
    code: "IND",
    dialCode: "+91",
    flagAsset: Assets.assetsIndiaflag,
  );

  // List of supported countries
  final List<Country> _countries = [
    Country(
      name: "India",
      code: "IND",
      dialCode: "+91",
      flagAsset: Assets.assetsIndiaflag,
    ),
    Country(
      name: "United Arab Emirates",
      code: "UAE",
      dialCode: "+971",
      flagAsset: Assets.assetsIndiaflag, // You'll need to add this asset
    ),
    Country(
      name: "Bangladesh",
      code: "BD",
      dialCode: "+880",
      flagAsset: Assets.assetsIndiaflag, // You'll need to add this asset
    ),
    Country(
      name: "Turkey",
      code: "TUR",
      dialCode: "+90",
      flagAsset: Assets.assetsIndiaflag, // You'll need to add this asset
    ),
  ];

  void _showCountrySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => CountrySelectionDialog(
        countries: _countries,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountry = country;
          });
        },
      ),
    );
  }



  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    // _animationController = AnimationController(
    //   duration: const Duration(seconds: 2),
    //   vsync: this,
    // )..repeat(reverse: true);
    //
    // _moveAnimation = Tween<double>(begin: -10, end: 10).animate(
    //   CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),

  }


  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<AuthViewModel>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: screenHeight * 0.08),
                Container(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.6,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.assetsYoyoMilesRemoveBg),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Image(image: AssetImage(Assets.assetsLoginDriver)),
              ],
            ),
            if (loginViewModel.loading)
              const Center(
                child: ConstLoader(),
              ),
          ],
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.037,
          ),
          decoration: BoxDecoration(
            color: PortColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextConst(
                    title: "Welcome",
                    color: PortColor.portKaro,
                    fontFamily: AppFonts.kanitReg,
                    fontWeight: FontWeight.w400,
                    size: 16,
                  ),
                  SizedBox(width: screenWidth * 0.018),
                  Image(
                    image: const AssetImage(Assets.assetsHello),
                    height: screenHeight * 0.03,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.016),
              TextConst(
                title:
                    "With a valid number, you can access deliveries, and our other services",
                color: PortColor.gray,
                fontFamily: AppFonts.poppinsReg,
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                children: [
                  GestureDetector(
                    onTap: _showCountrySelectionDialog,
                    child: Container(
                      height: screenHeight * 0.05,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey, width: screenWidth * 0.002),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            _selectedCountry.flagAsset,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 4),
                          TextConst(title: _selectedCountry.dialCode, color: PortColor.gray),
                          const Icon(Icons.keyboard_arrow_down, color: PortColor.gray),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: _controller,
                      height: screenHeight * 0.05,
                      hintText: "Mobile Number",
                      fillColor: PortColor.white,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      cursorHeight: screenHeight * 0.025,
                      focusNode: _focusNode,
                    ),
                  ),
                ],
              ),

              if (_isFocused) loginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    final loginViewModel = Provider.of<AuthViewModel>(context, listen: false);
    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        AppBtn(
          title: "Login",
          loading: loginViewModel.loading,
          onTap: () {
            if (_controller.text.length == 10 &&
                RegExp(r'^\d{10}$').hasMatch(_controller.text)) {
              final loginViewModel =
              Provider.of<AuthViewModel>(context, listen: false);
              loginViewModel.loginApi(_controller.text,fcmToken.toString(), context);
            } else {
              Utils.showErrorMessage(
                  context, "please enter a valid 10 digit number");
            }
          },
        ),
        SizedBox(height: screenHeight * 0.02),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: "By clicking on login you agree to the ",
            style: TextStyle(color: PortColor.gray, fontSize: 12,fontFamily: AppFonts.poppinsReg),
            children: [
              TextSpan(
                text: "terms of service",
                style: TextStyle(
                  color: PortColor.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12, fontFamily: AppFonts.poppinsReg
                ),
              ),
              TextSpan(
                text: " and ",
                style: TextStyle(color: PortColor.gray, fontSize: 12,fontFamily: AppFonts.poppinsReg),
              ),
              TextSpan(
                text: "privacy policy",
                style: TextStyle(
                  color: PortColor.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,fontFamily: AppFonts.poppinsReg
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
