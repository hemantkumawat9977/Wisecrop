import 'package:wisecrop/app/modules/sign_up_screen_module/sign_up_screen_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class SignUpScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpScreenController());
  }
}