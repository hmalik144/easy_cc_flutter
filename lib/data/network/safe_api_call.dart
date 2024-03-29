import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../main.dart';

mixin SafeApiCall {
  Future<T> getDataFromApiCall<T>(Future<HttpResponse<T>> apiCall) async {
    try {
      HttpResponse<T> httpResponse = await apiCall;
      return httpResponse.data;
    } on DioError catch(dioError) {
      Map<String, dynamic>? errorResponse = dioError.response?.data?["error"];
      String error;

      if (errorResponse?["message"] != null){
        error = errorResponse!["message"];
      } else if (dioError.message.isNotEmpty){
        error = dioError.message;
      } else {
        error = "Failed to retrieve data from api";
      }
      logger.e(error);

      throw HttpException(error);
    }
  }
}