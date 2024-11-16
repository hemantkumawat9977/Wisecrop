import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:wisecrop/app/utils/my_notification_handler.dart';
import 'package:wisecrop/app/utils/my_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wisecrop/app/utils/permission_class.dart';
import 'package:wisecrop/app/utils/wisecrop_session.dart';
import '../../networking/rest_api_client_with_api/rest_api_client_with_api.dart';
class LoginScreenController extends GetxController {
  BuildContext context = Get.context!;
  var platform = MethodChannel("com.wisecrop/native/webview/chanel");

  RxBool obscureText = true.obs; // Initially, password is hidden
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString email = ''.obs;
  RxString password = ''.obs;
  String token = '';
  var isLoading = false.obs;
  RxBool isLogin = false.obs;
  ValueNotifier userCredential = ValueNotifier('');

  @override
  void onInit()  {
    super.onInit();

    PermissionClass.setupMehodeCallHandler();
   // getFCMToken();
    checkUserToken();
    print("LOGINSCREEN: ");
  }

  bool checkAllFields() {
    if (emailController.text.isEmpty) {
      MySnackBar().error("Please enter email", "");
      return false;
    } else if (passwordController.text.isEmpty) {
      MySnackBar().error("Please enter password", "");
      return false;
    }
    return true;
  }






  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? user =
      await GoogleSignIn(scopes: ['email']).signIn();
      if (user != null) {
        Dialogs.showLoadingView(isLoading: true);

        final GoogleSignInAuthentication googleAuth = await user.authentication;

        print("googleAuth.idToken: ${googleAuth.idToken}");
        print("googleAuth.accessToken: ${googleAuth.accessToken}");
        final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken);
         print("credentialsWise: ${credentials}");

        try {
          UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credentials);
          print("userCredentialWise: ${userCredential}");


          if (userCredential.user != null) {
            String firstName = userCredential.additionalUserInfo?.profile?['given_name'] ?? "Wisecrop";
            String lastName = userCredential.additionalUserInfo?.profile?['family_name'] ?? "";
            String id =  "";
            if(Platform.isAndroid){
              id = userCredential.additionalUserInfo?.profile?['id'] ?? "";
            }else if(Platform.isIOS){
              id = userCredential.additionalUserInfo?.profile?['sub'] ?? "";
            }
            String email = userCredential.user?.email ?? "";
            print("USERGOOGLEID: ${id}");
            if (id.isNotEmpty) {
              Dialogs.showLoadingView(isLoading: false);
              loginWithGoogle(id);
            } else {
              Dialogs.errorDialog(onOkTap: () {}, text: "Something went wrong please try again later.", title: "Login failed");
            }
          }
        } on FirebaseAuthException catch (exc) {
          print('Error : $exc');
          Dialogs.showLoadingView(isLoading: false);

        }
      } else {
        Dialogs.showLoadingView(isLoading: false);
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong. Please try again later.",
          title: "Network connection issue",
        );
      }
    } catch (exc) {
      Dialogs.showLoadingView(isLoading: false);
      print('Error2 : $exc');
      Dialogs.errorDialog(
        onOkTap: () {},
        text: "Something went wrong. Please try again later.",
        title: "Network connection issue",
      );
    }
  }


  void loginWithGoogle(String uid) async {
    print("UID: ${uid}");
    Dialogs.showLoadingView(isLoading: true);
    var params = {"uid": uid};
    var client = ApiClientWithAPi();
    client.socialLogin(params).then((value) async {
      Dialogs.showLoadingView(isLoading: false);
      print("Value: ${value}");
      if (value["token"].isNotEmpty) {
        WisecropSession().setToken(value["token"]);
        checkPlatform(value["token"]);
      } else {
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong. Please try again later.",
          title: "Login failed",
        );
      }
    }).onError((error, stackTrace) {
      Dialogs.showLoadingView(isLoading: false);
      if (error is DioException) {
        print("statusCode: ${error.type}");
        if (error.type == DioExceptionType.unknown) {
          Dialogs.errorDialog(
            onOkTap: () {},
            text: "Invalid login credentials. Please try again.",
            title: "Login failed",
          );
        } else {
          Dialogs.errorDialog(
            onOkTap: () {},
            text: "Something went wrong. Please try again later.",
            title: "Login failed",
          );
        }
      } else {
        // Handle other types of errors
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "An unexpected error occurred. Please try again later.",
          title: "Error",
        );
      }
    });
  }
  void loginAPI() async {
    isLoading.value = true;
    var params= {"email":emailController.text,"password":passwordController.text,"rememberUser":true};
    print("PARAM : $params");
    var client = ApiClientWithAPi();
    client.login(params).then((value) async {
      isLoading.value = false;
      if(value["token"].isNotEmpty){
        emailController.clear();
        passwordController.clear();
        WisecropSession().setToken(value["token"]);
        checkPlatform(value["token"]);
      }else{
        MySnackBar().error("Login Failed check your email-password and internet connection", "");
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      if (error is DioException) {
        print("statusCode: ${error.type}");
        if (error.type == DioExceptionType.unknown) {
          Dialogs.errorDialog(
            onOkTap: () {},
            text: "Invalid login credentials. Please try again.",
            title: "Login failed",
          );
        } else {
          Dialogs.errorDialog(
            onOkTap: () {},
            text: "Something went wrong. Please try again later.",
            title: "Login failed",
          );
        }
      } else {
        // Handle other types of errors
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "An unexpected error occurred. Please try again later.",
          title: "Error",
        );
      }
    });
  }



  void checkPlatform(String token) async{
      await getFCMToken();


    if (Platform.isAndroid) {
      goToTheNative(token); //Because location and file permission not working on flutter web view
    } else if (Platform.isIOS) {
      Get.offAndToNamed(Routes.HOME_SCREEN,arguments: {"token":token});
    }

  }

  void goToTheNative(String token) async {

    try {
       await platform.invokeMethod('openNativeScreen', {'token': token});

    } on PlatformException catch (e) {
      print("Failed to open native screen: '${e.message}'.");
    }
  }

  void checkUserToken() async{
    String token = await WisecropSession().getToken();
    print("TOKEN: ${token}");
    if(token.isNotEmpty){
      checkPlatform(token);
    }
  }


  // void launchForgotPasswordUrl() async {
  //   https://app.wisecrop.com/accounts/password/reset/?email=
  //   // if (Platform.isAndroid) {
  //   //   await platform.invokeMethod('openNativeScreen', {'token': "forgotPassword"});
  //   // } else if (Platform.isIOS) {
  //   //   Get.offAndToNamed(Routes.HOME_SCREEN,arguments: {"type":"forgotPassword"});
  //   // }
  //
  // }
  void launchForgotPasswordUrl(Uri urlPrivacyPolicy) async {
    if (!await launchUrl(urlPrivacyPolicy)) {
      throw Exception('Could not launch $urlPrivacyPolicy');
    }
  }
  Future<void> getFCMToken() async {
    int userID = 0;
    String deviceID = "";
    String deviceModel = "";
    String deviceVersion = "";
    bool isInternetOn = await InternetConnectionChecker().hasConnection;
    if (!isInternetOn) {
      return;
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;
   String  fcmToken = await messaging.getToken() ?? "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    print("fcmToken:: ${fcmToken}");

    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo   = await deviceInfo.androidInfo;
      deviceID = androidInfo.id.toString();
      deviceModel = androidInfo.model.toString();
      deviceVersion = androidInfo.version.release.toString();
    }else if(Platform.isIOS){
      IosDeviceInfo androidInfo   = await deviceInfo.iosInfo;
      deviceID = androidInfo.systemName.toString();
      deviceModel = androidInfo.model.toString();
      deviceVersion = androidInfo.systemVersion.toString();
    }

    if (fcmToken.isNotEmpty) {
      String token = await WisecropSession().getToken();
      if(token.isNotEmpty){
        try {
          // Decode the token without verifying the signature
          final decodedToken = JWT.decode(token);
          var userInfo = decodedToken.payload['userInfo'];
          var exp = decodedToken.payload['exp'];
          userID = userInfo['id'];
          print("UserID: ${userID}");

        } catch (e) {
          MySnackBar().error("Login Failed", "$e");
        }
        var params = {
          "appName": "Wisecrop",
          "token": fcmToken,
          "userId": userID,
          "deviceId": deviceID,
          "device": {"key": deviceModel, "key2": deviceVersion}
        };
        var client = ApiClientWithAPi();
        client.sendFcmToken("Bearer $token", params).then((value) async {
        }).onError((error, stackTrace) async {
          // Fluttertoast.showToast(
          //     msg: "Failed to save FCM token on DB",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.red,
          //     textColor: Colors.white,
          //     fontSize: 16.0
          // );
        });
      }

    }
    return null;
  }

  bool checkValidation() {
    if(email.value.isEmpty){
      MySnackBar().error("Please enter your email id", "");
      return false;
    }  if(!email.value.isEmail){
      MySnackBar().error("Please enter valid email id", "");
      return false;
    }  if(password.value.isEmpty){
      MySnackBar().error("Please enter your password", "");
      return false;
    }
    return true;
  }
}
