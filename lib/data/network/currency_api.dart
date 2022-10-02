// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:easy_cc_flutter/data/network/app_dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../model/currency.dart';

part 'currency_api.g.dart';

@RestApi(baseUrl: "https://free.currencyconverterapi.com/api/v3/")
abstract class CurrencyApi {
  factory CurrencyApi(Dio dio, {String baseUrl}) = _CurrencyApi;
  static const api = String.fromEnvironment('currencyApiKey');
  
  static CurrencyApi create() {
    final dio = AppDio.createDio();
    dio.options.queryParameters.addAll({"apiKey": api});

    return _CurrencyApi(dio);
  }

  @GET("/convert?")
  Future<HttpResponse<ResponseObject>> getConversion(@Query("q") String currency);
}

@JsonSerializable()
class ResponseObject implements CurrencyMapper{
  dynamic query;
  Map<String, CurrencyObject>? results;

  ResponseObject({
    this.query,
    this.results
  });

  factory ResponseObject.fromJson(Map<String, dynamic> json) => _$ResponseObjectFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseObjectToJson(this);

  @override
  Currency convert() {
    CurrencyObject? cur = results?.entries.elementAt(0).value;
    return Currency(cur?.fr, cur?.to, cur?.val);
  }
  
}

@JsonSerializable()
class CurrencyObject{
  String? id;
  String? fr;
  String? to;
  double? val;

  CurrencyObject({
    this.id,
    this.fr,
    this.to,
    this.val
  });

  factory CurrencyObject.fromJson(Map<String, dynamic> json) => _$CurrencyObjectFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyObjectToJson(this);
}