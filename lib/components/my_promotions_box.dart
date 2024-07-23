import 'package:flutter/material.dart';

class MyPromotionsBox extends StatelessWidget {
  const MyPromotionsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(25)
        
      ),
      child: const Text("Sale",style: TextStyle(fontSize: 40,color: Colors.white),),
          );
  }
}