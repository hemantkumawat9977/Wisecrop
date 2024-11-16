
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:wisecrop/app/utils/wisecrop_session.dart';







class HomeScreenController extends GetxController {
  WebViewController webViewController =WebViewController();
  RxBool loading = true.obs;
  RxInt progress = 0.obs;
  String productionUrl = "https://app.wisecrop.com/production/dashboard/";
  String forgotPasswordUrl = "https://app.wisecrop.com/accounts/password/reset/?email=";
  String wiseUrl = "";
  late Stream<List<ConnectivityResult>> connectivityStream;
  RxBool connectionStatus = false.obs;
  bool dialogIsShowing = false;
  bool forSignUp = false;
String token ="";
String type ="";

  @override
  void onInit() {
    super.onInit();
      token = Get.arguments["token"]??"";
      type = Get.arguments["type"]??"";
      setUpWebView();
  }

  void setUpWebView() async{
    if(type=="forgotPassword"){
      wiseUrl = forgotPasswordUrl;
    }else{
      wiseUrl = productionUrl;
    }
    final cookieManager = WebViewCookieManager();
    await cookieManager.setCookie(
      WebViewCookie(
        name: 'token',
        value: token,
        domain: '.wisecrop.com',  // Make sure the domain matches the URL you're loading
        path: '/',  // Optional, usually set to '/'
      ),
    );

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loading.value = true;
            this.progress.value = progress;
            if (progress == 100) {
              loading.value = false;
            }
          },
          onPageStarted: (String url) {
            loading.value = true;
          },
          onPageFinished: (String url) {
            print("onPageFinished: $url");
          },
          onWebResourceError: (WebResourceError error) {
            print("WebResourceError: ${error.errorType}");
          },
          onNavigationRequest: (NavigationRequest request) async{

            if(request.url.toString()=="https://app.wisecrop.com/accounts/logout/"){
              WisecropSession().setToken("");
              Get.offAndToNamed(Routes.LOGIN_SCREEN);
            } else if(request.url.toString()=="https://app.wisecrop.com/accounts/login/" && forSignUp){
              forSignUp = false;
              WisecropSession().setToken("");
              Get.offAndToNamed(Routes.LOGIN_SCREEN);
            }
             return NavigationDecision.navigate; // Prevent other navigations if needed


          },
        ),
      )
      ..loadRequest(Uri.parse(wiseUrl));
  }

  void listenNetworkConnection() {
    // Get the current connectivity status
    connectivityStream = Connectivity().onConnectivityChanged;
    connectivityStream.listen((List<ConnectivityResult> result) {
      connectionStatus.value = result[0] == ConnectivityResult.none ? false : true;
      if (!connectionStatus.value) {
        dialogIsShowing = true;
        Dialogs.networkDialog(onOkTap: (){
          if(connectionStatus.value){
              dialogIsShowing = false;
              Get.close(1);
          }else{
            Get.snackbar("Please connect with network", "",colorText: Colors.white,backgroundColor: Colors.red);
          }
        });
      } else {
        if(dialogIsShowing){
          dialogIsShowing = false;
          Get.close(1);
        }
      }
    });
  }
}
