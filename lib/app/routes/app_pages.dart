import '../../app/modules/sign_up_screen_module/sign_up_screen_page.dart';
import '../../app/modules/sign_up_screen_module/sign_up_screen_bindings.dart';
import '../../app/modules/login_screen_module/login_screen_page.dart';
import '../../app/modules/login_screen_module/login_screen_bindings.dart';


import '../../app/modules/home_screen_module/home_screen_bindings.dart';
import '../../app/modules/home_screen_module/home_screen_page.dart';
import 'package:get/get.dart';
part './app_routes.dart';
/**
 * GetX Generator - fb.com/htngu.99
 * */

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME_SCREEN,
      page: () => HomeScreenPage(),
      binding: HomeScreenBinding(),
    ),

    GetPage(
      name: Routes.LOGIN_SCREEN,
      page: () => LoginScreenPage(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: Routes.SIGN_UP_SCREEN,
      page: () => SignUpScreenPage(),
      binding: SignUpScreenBinding(),
    ),
  ];
}
