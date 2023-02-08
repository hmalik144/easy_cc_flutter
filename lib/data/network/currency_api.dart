// ignore: depend_on_referenced_packages
// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:easy_cc_flutter/data/network/app_dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../model/currency.dart';

part 'currency_api.g.dart';

@RestApi(baseUrl: "https://exchange-rates.abstractapi.com/v1/")
abstract class CurrencyApi {
  factory CurrencyApi(Dio dio, {String baseUrl}) = _CurrencyApi;

  static const api = String.fromEnvironment('currencyApiKey');

  static CurrencyApi create() {
    final dio = AppDio.createDio();
    dio.options.queryParameters.addAll({"api_key": api});

    return _CurrencyApi(dio);
  }

  @GET("/live?")
  Future<HttpResponse<ResponseObject>> getConversion(
      @Query("base") String from, @Query("target") String to);
}

@JsonSerializable()
class ResponseObject implements CurrencyMapper {
  String base;
  String last_updated;
  Map<String, double>? exchange_rates;

  ResponseObject(this.base, this.last_updated, this.exchange_rates);

  factory ResponseObject.fromJson(Map<String, dynamic> json) =>
      _$ResponseObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseObjectToJson(this);

  @override
  Currency convert() {
    return Currency(base, exchange_rates?.keys.first, exchange_rates?.values.first);
  }
}

@JsonSerializable()
class CurrencyObject {
  String? id;
  String? fr;
  String? to;
  double? val;

  CurrencyObject({this.id, this.fr, this.to, this.val});

  factory CurrencyObject.fromJson(Map<String, dynamic> json) =>
      _$CurrencyObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyObjectToJson(this);
}
