import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String label;
  VoidCallback? ontap;
   CustomButton({super.key,required this.label,required this.ontap}) ;

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      onPressed: ontap,
      color: Colors.white,
      minWidth: double.infinity,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color:Colors.white ),
      ),
      child: Text(label),


    );
  }
}
