
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wisecrop/app/common_widget/common_drop_field_widget.dart';
import 'package:wisecrop/app/common_widget/common_screen_bg.dart';
import 'package:wisecrop/app/common_widget/common_text_field_widget.dart';
import 'package:wisecrop/app/modules/sign_up_screen_module/sign_up_screen_controller.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/theme/app_colors.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:wisecrop/gen/assets.gen.dart';


class SignUpScreenPage extends StatelessWidget {
  SignUpScreenController controller = Get.put(SignUpScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
       CommonScreenBg(),
          SafeArea(
            child: SingleChildScrollView(
              child: SafeArea(
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
                  Obx(() =>      Visibility(
              visible: !controller.signUpBySocialAccount.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // commanContainer(img: Assets.images.iconFb.path),
                    commanContainer(
                        img: Assets.images.iconGoogle.path,
                        onClick: () {
                          controller.signUpWithGoogle();
                        }),
                    // commanContainer(img: Assets.images.iconLinkdin.path),
                  ],
                ),
              ),
            )),
                  Obx(() => Visibility(
                    visible: controller.signUpBySocialAccount.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      child: Text("You are about to use your Google account to login to Wisecrop. As a final step please complete the following form:",textAlign: TextAlign.center, style: const TextStyle(color: AppColors.greyLight, fontSize: 17)),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Or:",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * 0.4,
                                child: CommonTextFieldWidget(
                                      aboveText: "First Name *",
                                      obscureText: false,
                                      maxLine: 1,
                                      controller: controller.firstNameController,
                                      onChanged: (value) {
                                        controller.firstName.value = value;
                                        controller.update();
                                        // controller.isChecked.value = value!;
                                      },
                                    ),
                              ),
                              SizedBox(
                                  width: Get.width * 0.4,
                                  child:  CommonTextFieldWidget(
                                        aboveText: "Last Name *",
                                        maxLine: 1,
                                        obscureText: false,
                                        controller: controller.lastNameController,
                                        onChanged: (value) {
                                          controller.lastName.value = value;
                                          controller.update();
                                        },
                                      ))
                            ],
                          ),
                          const SizedBox(height: 10),
                           CommonTextFieldWidget(
                                aboveText: "Email *",
                                obscureText: false,
                                maxLine: 1,
                                controller: controller.emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  controller.email.value = value;
                                  controller.update();
                                },
                              ),
                          const SizedBox(height: 10),
                          Obx(() => Visibility(
                                visible: !controller.signUpBySocialAccount.value,
                                child: CommonTextFieldWidget(
                                  aboveText: "Password *",
                                  maxLine: 1,
                                  maxLength: 20,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: controller.obscureText.value,
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        controller.obscureText.value = !controller.obscureText.value;
                                      },
                                      child: controller.obscureText.value ? const Icon(Icons.remove_red_eye_outlined, color: Colors.white) : const Icon(Icons.remove_red_eye, color: Colors.white)),
                                  controller: controller.passwordController,
                                  onChanged: (value) {
                                    controller.password.value = value;
                                    controller.update();
                                  },
                                ),
                              )),
                          Obx(() => Visibility(
                                visible: controller.signUpBySocialAccount.value,
                                child: CommonTextFieldWidget(
                                  aboveText: "Phone *",
                                  maxLine: 1,
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  obscureText: false,
                                  controller: controller.phoneNumberController,
                                  onChanged: (value) {
                                    controller.phoneNumber.value = value;
                                    controller.update();
                                  },
                                ),
                              )),
                          const SizedBox(height: 10),
                          CommonDropDownWidget(
                            hint: "Select your Country",
                            aboveText: "Country *",
                            controller: controller.countryController,
                            itemList: [],
                            onTap: () {
                              showCountryCodeDialog(context);
                            },
                            onChanged: (value, index, id) {},
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 6),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.launchPrivacyPolicy(Uri.parse("https://help.wisecrop.com/portal/pt/kb"));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "By registering you accept our ",
                                          style: const TextStyle(color: AppColors.grey, fontSize: 16), // Change color as needed
                                        ),
                                        TextSpan(
                                          text: " Terms and condition ",
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), // Change color as needed
                                        ),
                                        TextSpan(
                                          text: "and",
                                          style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.w500, fontSize: 16), // Change color as needed
                                        ),
                                        TextSpan(
                                          text: " Privacy Policy ",
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), // Change color as needed
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Obx(() => GestureDetector(
                              onTap: () async{
                                if (controller.checkValidation()) {
                                  if (!controller.isLoading.value) {
                                    bool isInternetOn = await InternetConnectionChecker().hasConnection;
                                    if (isInternetOn) {
                                      if (controller.signUpBySocialAccount.value) {
                                        controller.signupWithSocialAccount();
                                      } else {
                                        controller.signup();
                                      }
                                    }else{
                                      Dialogs.infoDialog(
                                        onOkTap: () {},
                                        text: "Please check your internet connection",
                                        title: "No internet!",
                                      );
                                    }
                                    FocusNode().unfocus();
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white
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
                                            "Sign up",
                                            style: TextStyle(fontSize: 19, color: AppColors.greenColor),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 24,
                                            color:AppColors.greenColor,
                                          )
                                        ],
                                      ),
                              )))
                        ],
                      ), //Column
                    ), //Padding
                  ), //Card
                  const SizedBox(
                    height: 20,
                  ),

                  GestureDetector(
                    onTap: (){
                      Get.offAndToNamed(Routes.LOGIN_SCREEN);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have a Wisecrop account?",
                              style: const TextStyle(color: AppColors.grey, fontSize: 16), // Change color as needed
                            ),
                            TextSpan(
                              text: " Login",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), // Change color as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget commanContainer({required String img, Function? onClick}) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
      },
      child: Container(
        width: 58,
        height: 58,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10)), color: Colors.white),
        child: Image.asset(
          img,
          height: 14,
          width: 14,
        ),
      ),
    );
  }

  void showCountryCodeDialog(BuildContext context) async {
    final countryPicker = const FlCountryCodePicker();
    final picked = await countryPicker.showPicker(context: Get.context!);
    if (picked != null) {
      String name = picked.name;
      String code = picked.code;
      String dialCode = picked.dialCode;
      controller.countryCode.value = dialCode.toString();
      controller.countryCodeName.value = code.toString();
      controller.langCode.value = code.toString();
      controller.countryController.text = "$dialCode $name";
      controller.update();
    } else {
      print('No match found.');
    }
  }
}
