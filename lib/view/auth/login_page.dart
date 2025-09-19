import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:port_karo/generated/assets.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/app_fonts.dart';
import 'package:port_karo/res/const_loader.dart';
import 'package:port_karo/res/constant_color.dart';
import 'package:port_karo/res/constant_text.dart';
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

  late AnimationController _animationController;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _moveAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<AuthViewModel>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFB3E5FC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  AnimatedBuilder(
                    animation: _moveAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_moveAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      height: screenHeight * 0.12,
                      width: screenWidth * 0.6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.assetsPortKaroLogo),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Image(image: AssetImage(Assets.assetsMainimage)),
                ],
              ),
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
                  Container(
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
                          Assets.assetsIndiaflag,
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 4),
                        TextConst(title: "+91", color: PortColor.gray),
                        const Icon(Icons.keyboard_arrow_down,color: PortColor.gray,),
                      ],
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
        GestureDetector(
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
          child: Container(
            height: screenHeight * 0.06,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [PortColor.portMan, PortColor.portManLight],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: !loginViewModel.loading
                ? TextConst(title: "Login", color: PortColor.white)
                : const CupertinoActivityIndicator(radius: 16,color: PortColor.white,),
          ),
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
                  color: PortColor.buttonBlue,
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
                  color: PortColor.buttonBlue,
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
