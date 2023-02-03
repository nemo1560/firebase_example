import 'package:get/get.dart';

import '../views/root_view.dart';

class RouteName {
  static const String root = "/";
}

class Pages{
  static List<GetPage> pages = [
    GetPage<dynamic>(name: RouteName.root, page: () =>  RootView()),
  ];
}