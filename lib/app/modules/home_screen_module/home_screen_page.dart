import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisecrop/app/modules/home_screen_module/home_screen_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wisecrop/app/theme/app_colors.dart';
import 'package:wisecrop/gen/assets.gen.dart';



class HomeScreenPage extends StatelessWidget {
  HomeScreenController controller = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller.webViewController,
            ),
            Obx(() => controller.loading.value?
            PageLoadingView(controller: controller):SizedBox())
          ],
        ),
      ),
    );
  }
}

class PageLoadingView extends StatelessWidget {
  const PageLoadingView({
    super.key,
    required this.controller,
  });

  final HomeScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.black54.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child:  Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Obx(() => CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: controller.progress.value / 100.0,
              center: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 80,width: 80,child: Image.asset(Assets.images.wisecropLogoWhite.path)),
                  Text("${controller.progress.value}%",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
                ],
              ),
              backgroundColor: Colors.grey,
              progressColor: AppColors.greenColor,
            ),)
          ],
        ),
      ),
    );
  }
}
