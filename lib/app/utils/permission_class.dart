import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:wisecrop/app/utils/wisecrop_session.dart';


class PermissionClass{

  static void setupMehodeCallHandler( ) {
    var platform = MethodChannel("com.wisecrop/native/webview/chanel");
    platform.setMethodCallHandler((call) async {
      print("GoToLoginHHH::  ${call.method}");

      if (call.method == "GoToLogin") {
          print("GoToLoginHHH::  ${call.method}");
         WisecropSession().setToken("");
        }
      });

  }

}