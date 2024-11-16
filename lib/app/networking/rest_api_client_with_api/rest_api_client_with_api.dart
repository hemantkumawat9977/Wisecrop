
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

import '../app_interceptor.dart';
part 'rest_api_client_with_api.g.dart';

@RestApi(baseUrl: "https://api.wisecrop.com/")
abstract class ApiClientWithAPi {
  factory ApiClientWithAPi() {
    Dio dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader: true, responseBody: true, responseHeader: true));
    dio.interceptors.addAll({
      AppInterceptors(dio),
    });
    return _ApiClientWithAPi(dio);
  }

  @POST('auth/loginSocial')
  Future<dynamic> socialLogin(@Body() Map<String, dynamic> body);
  @POST('auth/login')
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST('auth/tokenFCM')
  Future<dynamic> sendFcmToken(@Header("Authorization") String token,@Body() Map<String, dynamic> body);

  @POST('auth/signup')
  Future<dynamic> signUp(@Body() Map<String, dynamic> body);

  @POST('auth/signupSocial')
  Future<dynamic> socialSignUp(@Body() Map<String, dynamic> body);

  @POST('auth/verifyIfUserExist')
  Future<dynamic> verifyIfUserExist(@Body() Map<String, dynamic> body);
}