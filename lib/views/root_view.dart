import 'package:firebase_example/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/resources.dart';
import '../core/components/appBarCustom.Component.dart';

class RootView extends GetView<BaseController>{
  const RootView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarComponent(preferredSize: const Size(0, 50), action: const InkWell(
        onTap: null,
        child: Icon(
          Icons.account_circle_rounded,
          color: Colors.white,
        ),
      ), title: '',
      child: const Center(),
      ),
      body: body(context),
    );
  }
  
  Widget body(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100
      ),
    );
  }
}