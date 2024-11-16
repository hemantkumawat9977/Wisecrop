import 'dart:ui';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../theme/app_colors.dart';

class Dialogs{
  static SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(context: Get.context!);

  static void showLoadingView({required bool isLoading, String? msg,String? updateMessage}) async {
    if (isLoading) {
      if(updateMessage != null && updateMessage.isNotEmpty){
        dialog.updateMessageText(updateMessage);
      }else{
        dialog.show(message: msg ?? "Please wait...", width: 300, type: SimpleFontelicoProgressDialogType.iphone, horizontal: false, indicatorColor: AppColors.greenColor, textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16));

      }
    } else {
      dialog.hide();
    }
  }
  static  void networkDialog({Function? onOkTap}) async {
    await CoolAlert.show(
        context: Get.context!,
        type: CoolAlertType.warning,
        text: "No network connection available",
        textTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),
        title:"Connection lost!",
        barrierDismissible: false,
        backgroundColor: AppColors.greenColor,
        confirmBtnText: "Try again",
        cancelBtnTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        showCancelBtn:false,
        confirmBtnColor: AppColors.greenColor,
        confirmBtnTextStyle: const TextStyle(color: Colors.white),
        loopAnimation: false,
        closeOnConfirmBtnTap: false,

        onConfirmBtnTap: () {
          if (onOkTap != null) {
            onOkTap();
          }
        });


  }

  static  void errorDialog({Function? onOkTap,required String title,required String text}) async {
    await CoolAlert.show(
        context: Get.context!,
        type: CoolAlertType.error,
        text: text,
        textTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),
        title:title,
        barrierDismissible: false,
        backgroundColor: Colors.red,
        confirmBtnText: "Ok",
        cancelBtnTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        showCancelBtn:false,
        confirmBtnColor: AppColors.greenColor,
        confirmBtnTextStyle: const TextStyle(color: Colors.white),
        loopAnimation: false,
        closeOnConfirmBtnTap: true,

        onConfirmBtnTap: () {
          if (onOkTap != null) {
            onOkTap();
          }
        });


  }
  static  void infoDialog({Function? onOkTap,required String title,required String text}) async {
    await CoolAlert.show(
        context: Get.context!,
        type: CoolAlertType.warning,
        text: text,
        textTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),
        title:title,
        barrierDismissible: false,
        backgroundColor: AppColors.greenColor,
        confirmBtnText: "Ok",
        cancelBtnTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        showCancelBtn:false,
        confirmBtnColor: AppColors.greenColor,
        confirmBtnTextStyle: const TextStyle(color: Colors.white),
        loopAnimation: false,
        closeOnConfirmBtnTap: true,

        onConfirmBtnTap: () {
          if (onOkTap != null) {
            onOkTap();
          }
        });


  }

  static  void successDialog({Function? onOkTap,required String title,required String text}) async {
    await CoolAlert.show(
        context: Get.context!,
        type: CoolAlertType.success,
        text: text,
        textTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),
        title:title,
        barrierDismissible: false,
        backgroundColor: AppColors.greenColor,
        confirmBtnText: "Ok",
        cancelBtnTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        showCancelBtn:false,
        confirmBtnColor: AppColors.greenColor,
        confirmBtnTextStyle: const TextStyle(color: Colors.white),
        loopAnimation: false,
        closeOnConfirmBtnTap: true,

        onConfirmBtnTap: () {
          if (onOkTap != null) {
            onOkTap();
          }
        });


  }
}