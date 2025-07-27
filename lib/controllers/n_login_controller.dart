import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NLoginController extends GetxController {
  static NLoginController get to => Get.find();

  final nip05FieldController = TextEditingController();
  RxBool isFetchingNip05 = false.obs;
  RxInt nip05LoginError = 0.obs;
}
