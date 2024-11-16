import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wisecrop/gen/assets.gen.dart';

import '../theme/app_colors.dart';

class CommonScreenBg extends StatelessWidget {
  const CommonScreenBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(Assets.images.wiseBg.path,fit: BoxFit.cover,height: Get.height,width: Get.width),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.greenColor.withOpacity(0.8),
              AppColors.greenColor.withOpacity(0.6)
            ],
          ),
        ),
      ),],);
  }
}
