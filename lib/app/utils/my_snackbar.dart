import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wisecrop/app/theme/app_colors.dart';


class MySnackBar {
  void error(String title, String desc) {
    Get.snackbar(title, desc, backgroundColor: Colors.red, colorText: AppColors.white, duration: const Duration(seconds: 1));
  }

  void success(String title, String desc,{int? duration}) {
    Get.snackbar(title, desc, backgroundColor: AppColors.green, colorText: AppColors.white, margin: const EdgeInsets.only(top: 80, right: 15, left: 15), snackPosition: SnackPosition.TOP, duration:  Duration(seconds: duration??1));
  }

  void info(String title, String desc) {
    Get.snackbar(title, desc, backgroundColor: AppColors.primaryYellow, colorText: AppColors.white, duration: const Duration(seconds: 1));
  }

  void showFlutterToast(String title, String titleMini) {
    Get.snackbar(title, titleMini, backgroundColor: AppColors.green, colorText: AppColors.white, margin: const EdgeInsets.only(bottom: 150, right: 15, left: 15), snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }
}
