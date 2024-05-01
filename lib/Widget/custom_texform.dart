import 'package:flutter/material.dart';
import 'package:QRScanGenerate/utils/appcolor.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxline;
  final TextInputType textInputType;
  final FormFieldValidator<String>? validator;
  final int? maxlength;
  const CustomInputField(
      {required this.controller,
      required this.labelText,
      Key? key,
      required this.maxline,
      required this.textInputType,
      this.validator,
      this.maxlength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,bottom: 10,right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.mainColor,
      ),
      child: TextFormField(
        maxLength: maxlength,
        validator: validator,
        keyboardType: textInputType,
        maxLines: maxline,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labelText,
        ),
      ),
    );
  }
}
