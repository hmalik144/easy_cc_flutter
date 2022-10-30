// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

class AppDio {
  static Dio createDio() {
    Dio dio = Dio(
        BaseOptions(
            receiveTimeout: 30000,
            connectTimeout: 30000,
        )
    );
    dio.interceptors.add(LogInterceptor());

    return dio;
  }
}