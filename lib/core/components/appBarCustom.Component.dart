import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../resources.dart';

class AppBarComponent extends StatelessWidget with PreferredSizeWidget{
  AppBarComponent ({Key? key, this.isBack =false,this.onPressBack,required this.title, required this.preferredSize,required this.child,required this.action}) : super(key: key);
  final String? title;
  final Widget? child;
  final bool isBack;
  final Function()? onPressBack;
  final Widget? action;
  @override
  final Size preferredSize;
  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color:  HexColor(ColorsApp.red700),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        )
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            top: (child != null) ?(topPadding+5):(topPadding+(preferredSize.height*.3)),
            child: child ?? Text(title??"",style: TextStyle(
                color: HexColor(ColorsApp.white),fontSize: 16,fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            top: topPadding+(preferredSize.height*.3),
            left: 20,
            child: _buildAppbar(Icon(Icons.arrow_back_ios,color: HexColor(ColorsApp.white),),onPressBack ?? (){
              Get.back();
            })
          ),
          Visibility(
            visible: action != null,
            child: Positioned(
              top: topPadding+(preferredSize.height*.3),
              right: 20,
              child: action ?? const SizedBox()
            )
          )
        ]
      )
    );
  }

  Widget _buildAppbar(Icon icon, VoidCallback callback){
    return GestureDetector(
      onTap: callback,
      child: Center(
        child: icon,
      )
    );
  }
  
}