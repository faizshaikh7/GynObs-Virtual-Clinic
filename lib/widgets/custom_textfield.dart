import 'package:agp_ziauddin_virtual_clinic/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';



class CustomTextField extends StatefulWidget {
  String hintText = "";
  TextEditingController controller;
  List<FieldValidator> validators;
  bool isPassword = false;
  int maxLines;
  Color color;

  TextInputType keyboardType;
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.validators,
      this.hintText = "",
      this.isPassword = false,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.color = Colors.black})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHide = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: widget.color),
      keyboardType: widget.keyboardType,
      validator: MultiValidator(widget.validators),
      controller: widget.controller,
      maxLines: widget.maxLines,
      obscureText: widget.isPassword
          ? isHide
              ? true
              : false
          : false,
      decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          hintStyle: TextStyle(color: grey),
          errorStyle: TextStyle(color: widget.color),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: widget.color),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.color),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.color),
              borderRadius: BorderRadius.circular(10)),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isHide = !isHide;
                    });
                  },
                  icon: Icon(
                    isHide ? Icons.visibility_off : Icons.visibility,
                    color:grey,
                  ))
              : null),
    );
  }
}
