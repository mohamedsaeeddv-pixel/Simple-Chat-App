import 'package:flutter/material.dart';
class CustomTextFormFiled extends StatelessWidget {
   CustomTextFormFiled({super.key, required this.label,required this.controller,this.validate,this.showPassword=false,this.suffixIcon,} );
   String label;
   var validate;
   bool showPassword;
   var suffixIcon;
   var controller =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,

      validator: validate,
      controller:controller ,
      obscureText:showPassword ,
      decoration: InputDecoration(
          labelText: label,
        labelStyle: const TextStyle(color: Colors.white) ,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        suffixIcon: suffixIcon,

      ),

    );
  }
}
