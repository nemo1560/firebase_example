import 'package:firebase_example/controllers/base_controller.dart';
import 'package:get/get.dart';

class BaseBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(() => BaseController());
  }

}