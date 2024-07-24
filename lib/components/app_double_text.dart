import 'package:flutter/material.dart';

class AppDoubleText extends StatelessWidget {
  const AppDoubleText({super.key,required this.bigText,required this.smallText});
  final String bigText ;
  final String smallText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
      children: [
        Text(bigText,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.green),),
        Text(smallText,style: TextStyle(fontWeight: FontWeight.w400,color: Color.fromARGB(255, 108, 108, 108)),)
      ],
    );
  }
}