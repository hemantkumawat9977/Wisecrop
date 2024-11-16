import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            String? message = "";
            try {
              print('error response data ${err.response}');
              message = err.response!.data["message"].toString() ?? '';
            } catch (e) {
              message = "";
            }

            if (message != null && message.isNotEmpty) {
              throw DioException(
                  message: message, requestOptions: err.requestOptions);
            } else {
              throw DioException(
                  message: "Invalid Request",
                  requestOptions: err.requestOptions);
            }
          case 422:
            String? message = "";
            try {
              message = err.response!.data["msg"].toString() ?? '';
            } catch (e) {
              message = "";
            }

            if (message != null && message.isNotEmpty) {
              throw DioException(
                  message: message, requestOptions: err.requestOptions);
            } else {
              throw DioException(
                  message: "Invalid Request",
                  requestOptions: err.requestOptions);
            }

          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;

      case DioExceptionType.badCertificate:
        // TODO: Handle this case.
        break;
      case DioExceptionType.connectionError:
        print("Network Error");
        throw DioException(
            message: "No Internet connection. Please try again.",
            requestOptions: err.requestOptions);
        break;
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r, String? message)
      : super(requestOptions: r);

  @override
  String toString() {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
