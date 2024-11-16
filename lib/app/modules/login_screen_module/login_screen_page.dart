

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wisecrop/app/common_widget/common_screen_bg.dart';
import 'package:wisecrop/app/common_widget/common_text_field_widget.dart';
import 'package:wisecrop/app/modules/login_screen_module/login_screen_controller.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/theme/app_colors.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:wisecrop/gen/assets.gen.dart';


class LoginScreenPage extends StatelessWidget {
  LoginScreenController controller = Get.put(LoginScreenController());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CommonScreenBg(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Image.asset(
                            Assets.images.wisecropLogoWhite.path,
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
                          ),
                        ),
                        SizedBox(width: 10), // Add spacing between the image and text
                        Flexible(
                          flex: 2,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Wisecrop",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 60, // You can keep the large size, it will adjust
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextFieldWidget(
                          maxLine: 1,
                          aboveText: "Enter email",
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            controller.email.value = value;
                          },
                          controller: controller.emailController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() => CommonTextFieldWidget(
                          maxLine: 1,
                          aboveText: "Enter password",
                          obscureText: controller.obscureText.value,
                          onChanged: (value) {
                            controller.password.value = value;
                          },
                          suffixIcon: InkWell(
                              onTap: () {
                                controller.obscureText.value = !controller.obscureText.value;
                              },
                              child: controller.obscureText.value ? const Icon(Icons.remove_red_eye_outlined,color:Colors.white,) : const Icon(Icons.remove_red_eye,color: Colors.white,)),
                          controller: controller.passwordController,
                        )),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Forgot password? ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                // Remove the TextDecoration.underline here
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                controller.launchForgotPasswordUrl(Uri.parse("https://app.wisecrop.com/accounts/password/reset/?email="));
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white)), // Change the color here
                                ),
                                child: Text(
                                  "Click here",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    // Remove the TextDecoration.underline here
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),


                        Obx(() => InkWell(
                          onTap: () async{
                            if(controller.checkValidation()){
                              bool isInternetOn = await InternetConnectionChecker().hasConnection;
                              if (isInternetOn) {
                                controller.loginAPI();
                              }else{
                                Dialogs.infoDialog(
                                  onOkTap: () {},
                                  text: "Please check your internet connection",
                                  title: "No internet!",
                                );
                              }


                            }

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: controller.isLoading.value
                                ? const Center(
                                child: SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    color: AppColors.green,
                                  ),
                                ))
                                : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Login",
                                  style: TextStyle(fontSize: 19, color: AppColors.green),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.arrow_forward,size: 24,color:  AppColors.green,)
                              ],
                            ),
                          ),
                        )),
                      ],
                    ), //Column
                  ),



                  GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.SIGN_UP_SCREEN);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account?",
                              style: const TextStyle(color: AppColors.grey, fontSize: 16), // Change color as needed
                            ),
                            TextSpan(
                              text: " Sign up for free!",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), // Change color as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      "Or login via:",
                      style: const TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // InkWell(
                      //     onTap: () {
                      //       //controller.fbLogInClick();
                      //     },
                      //     child: myContainer(Assets.images.iconFb.path)),
                      InkWell(
                          onTap: () {
                            controller.signInWithGoogle();
                          },
                          child: myContainer(Assets.images.iconGoogle.path)),
                      // myContainer(Assets.images.iconLinkdin.path),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myContainer(String img) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.grey, width: 2), borderRadius: const BorderRadius.all(Radius.circular(10)),color: Colors.white),
      child: Image.asset(
        img,
        height: 14,
        width: 14,
      ),
    );
  }


}
