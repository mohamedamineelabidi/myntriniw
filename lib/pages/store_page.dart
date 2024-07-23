import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntrriniw_v0/components/app_double_text.dart';
import 'package:ntrriniw_v0/components/my_app_bar.dart';
import 'package:ntrriniw_v0/components/my_nav_bar.dart';
import 'package:ntrriniw_v0/components/my_promotions_box.dart';
import 'package:ntrriniw_v0/components/my_search_bar.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body:ListView(
          
          children: [
            MySearchBar(),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text('store',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppDoubleText(bigText: "Promotions",smallText: "view all",),
              ),
              SizedBox(height: 10,),
              MyPromotionsBox(),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      decoration: BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(25)),
                      
                    )
                  ],
                ),
              ),

              SizedBox(height: 10,),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: AppDoubleText(bigText: "Products",smallText: 'view all',),
              )
          ],),


        
        bottomNavigationBar: const MyNavBar(selectedIndex: 3));
  }
}
