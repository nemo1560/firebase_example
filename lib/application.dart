import 'package:firebase_example/bindings/base_binding.dart';
import 'package:firebase_example/core/notification_service.dart';
import 'package:firebase_example/core/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Application extends StatelessWidget{

  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      initialRoute: NotificationService.getInitRoute(),
      initialBinding: BaseBinding(),
      getPages: Pages.pages,
    );
  }
  
}