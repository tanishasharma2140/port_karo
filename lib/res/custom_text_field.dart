import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:port_karo/main.dart';
import 'package:port_karo/res/constant_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final double? height;
  final double? width;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final double? cursorHeight;
  final int? maxLength;
  final Color? focusedBorder;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    Key? key,
    this.controller,
    this.height,
    this.width,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.hintText,
    this.hintStyle,
    this.fillColor,
    this.keyboardType,
    this.focusNode,
    this.cursorHeight,
    this.maxLength,
    this.focusedBorder = PortColor.gray,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double effectiveHeight = height ?? MediaQuery.of(context).size.height * 0.06;
    double effectiveWidth = width ?? double.infinity;

    return Container(
      height: effectiveHeight,
      width: effectiveWidth,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          fillColor: fillColor ?? PortColor.white,
          filled: true,
          labelText: labelText,
          labelStyle: TextStyle(
            color: PortColor.black.withOpacity(0.5),
            fontSize: 12,
          ),
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(color: PortColor.black.withOpacity(0.3)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: focusedBorder ?? PortColor.gray, width: screenWidth*0.002),
          ),
          counterText: "",
        ),
        cursorColor: PortColor.gray,
        style: const TextStyle(color: PortColor.black),
        cursorHeight: cursorHeight,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        inputFormatters: [
          if (maxLength != null)
            LengthLimitingTextInputFormatter(maxLength),
        ],
      ),
    );
  }
}
