import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wisecrop/app/networking/rest_api_client_with_api/rest_api_client_with_api.dart';
import 'package:wisecrop/app/routes/app_pages.dart';
import 'package:wisecrop/app/utils/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wisecrop/app/utils/my_snackbar.dart';


class SignUpScreenController extends GetxController{
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController =  TextEditingController();
  TextEditingController emailController =     TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController countryController =   TextEditingController();
  TextEditingController phoneNumberController =   TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  BuildContext context = Get.context!;
  RxBool obscureText = true.obs; // Initially, password is hidden
  RxBool isLoading = false.obs;
  RxString firstName = "".obs;
  RxString lastName = "".obs;
  RxString email = "".obs;
  RxString password = "".obs;
  RxString countryCode = "".obs;
  RxString countryCodeName = "".obs;
  RxString langCode = "".obs;
  RxString phoneNumber = "".obs;
  String avatarUrl = "";
  String socialAccountId = "";
  RxBool signUpBySocialAccount = false.obs;


  bool checkValidation(){
    if(firstName.value.isEmpty){
      MySnackBar().error("Please enter your first name", "");
      return false;
    }  if(lastName.value.isEmpty){
      MySnackBar().error("Please enter your last name", "");
      return false;
    }  if(email.value.isEmpty){
      MySnackBar().error("Please enter your email id", "");
      return false;
    }  if(!email.value.isEmail){
      MySnackBar().error("Please enter valid email id", "");
      return false;
    }     if(countryController.text.isEmpty){
      MySnackBar().error("Please select your country/country code", "");
      return false;
    }if(!signUpBySocialAccount.value){
      if(password.value.isEmpty){
        MySnackBar().error("Please enter your password", "");
        return false;
      }
      if(password.value.length < 6){
        MySnackBar().error("Please enter password minimum 6 characters", "");
        return false;
      }

    }else{
      if(phoneNumber.value.isEmpty){
        MySnackBar().error("Please enter your phone number", "");
        return false;
      }
      if(phoneNumber.value.length < 8){
        MySnackBar().error("Please enter valid phone number", "");
        return false;
      }
    }
    return true;
  }


  void signup() async{
    isLoading.value = true;
    var params= {"first_name":firstName.value,"last_name":lastName.value,"email":email.value,"password":password.value,"lang_code":langCode.value,"country_code":countryCodeName.value,"phone":countryCode.value,"terms_conditions":"${true}","notifications":"${true}"};
    var client = ApiClientWithAPi();
    client.signUp(params).then((value) async {
      isLoading.value = false;
      if(value["message"]=="User created successfully"){
        createAccountSuccessfully("${firstName.value} ${lastName.value}");
      }else if(value["message"]== "A user with this email or username already exists"){
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "A user with this email or username already exists.",
          title: "Signup failed",
        );
      }else{
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong. Please try again later.",
          title: "Signup failed",
        );
      }
    }).catchError((error) {
      isLoading.value = false;
      print("Error: ${error.runtimeType}");
      print("Error: ${error}");
      if(error.runtimeType.toString()== "InternalServerErrorException"){
        Dialogs.infoDialog(
          onOkTap: () {},
          text: "A user with this email or username already exists.",
          title: "User exist",
        );
      }else{
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong please try again later.",
          title: "Signup failed",
        );
      }

    });
  }


  void createAccountSuccessfully(String name) {
    Dialogs.successDialog(title: "Account Created", text: "User created successfully please go to login",onOkTap: (){
      Future.delayed(Duration(seconds: 1),() {
        Get.offAndToNamed(Routes.LOGIN_SCREEN);
      },);
    });
  }
  void launchPrivacyPolicy(Uri urlPrivacyPolicy) async {
    if (!await launchUrl(urlPrivacyPolicy)) {
      throw Exception('Could not launch $urlPrivacyPolicy');
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? user =
      await GoogleSignIn(scopes: ['email']).signIn();
      if (user != null) {
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
            String picUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUFNWMaJ843cjJvpTu6ijuNHLW3nUSsr9I8g&s";
            String firstName = userCredential.additionalUserInfo?.profile?['given_name'] ?? "Wisecrop";
            String lastName = userCredential.additionalUserInfo?.profile?['family_name'] ?? "";
            String id =  "";
            if(Platform.isAndroid){
              id = userCredential.additionalUserInfo?.profile?['id'] ?? "";
            }else if(Platform.isIOS){
              id = userCredential.additionalUserInfo?.profile?['sub'] ?? "";
            }
            String email = userCredential.additionalUserInfo?.profile?['email'] ?? "";
            String avatarUrl = userCredential.additionalUserInfo?.profile?['picture'] ?? picUrl; // Avatar URL
            if (id.isNotEmpty) {
              verifyIfUserExist(email,id,firstName,lastName,avatarUrl);
               //signupWithGoogle(id,firstName,lastName,email,languageCode,countryCode,phone,avatarUrl);
            } else {
              Dialogs.errorDialog(onOkTap: () {}, text: "Google signup failed please try again later.", title: "Signup failed");
            }
          }
        } on FirebaseAuthException catch (exc) {
          print('Error : $exc');
        }
      } else {

      }
    } catch (exc) {
      print('Error2 : $exc');
    }
  }
  void signupWithSocialAccount() async{
   Dialogs.showLoadingView(isLoading: true);
   String deviceVersion = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo   = await deviceInfo.androidInfo;
      deviceVersion = androidInfo.version.release.toString();
    }else if(Platform.isIOS){
      IosDeviceInfo androidInfo   = await deviceInfo.iosInfo;
      deviceVersion = androidInfo.systemVersion.toString();
    }
    var params= {"first_name":firstName.value,"last_name":lastName.value,"email":email.value,"lang_code":langCode.value,"country_code":langCode.value,"phone":countryCode.value+" "+phoneNumber.value,"terms_conditions":"${true}","notifications":"${true}","uid":socialAccountId,"provider":"Google","avatar_url":avatarUrl,"extra_data":"${deviceVersion}"};
    var client = ApiClientWithAPi();
    client.socialSignUp(params).then((value) async {
      Dialogs.showLoadingView(isLoading: false);
      if(value["message"]=="User created successfully"){
        createAccountSuccessfully("${firstName} ${lastName}");
      }else if(value["message"]== "A user with this email or username already exists"){
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "A user with this email or username already exists.",
          title: "Signup failed",
        );
      }else{
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong. Please try again later.",
          title: "Signup failed",
        );
      }
    }).onError((error, stackTrace) {
      Dialogs.showLoadingView(isLoading: false);
      print("DioExceptionType: ${error.runtimeType}");
      isLoading.value = false;
      if(error.runtimeType.toString()== "NoInternetConnectionException"){
        Dialogs.infoDialog(
          onOkTap: () {},
          text: "Please check your internet connection",
          title: "No internet!",
        );

      }
    });
  }

  void showDataOnUi(String id, String firstName, String lastName, String email, String avatarUrl) {
     signUpBySocialAccount.value = true;
     firstNameController.text = firstName;
     lastNameController.text = lastName;
     emailController.text =  email;
     this.firstName.value = firstName;
     this.lastName.value = lastName;
     this.email.value = email;
     this.avatarUrl = avatarUrl;
     this.socialAccountId = id;
  }

  void verifyIfUserExist(String email, String id, String firstName, String lastName, String avatarUrl) {
    Dialogs.showLoadingView(isLoading: true);
  var  params= {"email":email};
    var client = ApiClientWithAPi();
    client.verifyIfUserExist(params).then((value) async {
      Dialogs.showLoadingView(isLoading: false);
      if(value["user"]!=null){
        Dialogs.infoDialog(title: "Account exist", text: "User already exist please go to login",onOkTap: (){
          Future.delayed(Duration(seconds: 1),() {
            Get.offAndToNamed(Routes.LOGIN_SCREEN);
          },);
        });
      }
    }).catchError((error) {
      Dialogs.showLoadingView(isLoading: false);
      if(error.runtimeType.toString()=="NotFoundException"){
        showDataOnUi(id,firstName,lastName,email,avatarUrl);
      }else{
        Dialogs.errorDialog(
          onOkTap: () {},
          text: "Something went wrong please try again later.",
          title: "Signup failed",
        );
      }
    });
  }
}


