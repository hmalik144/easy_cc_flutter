import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../model/Currency.dart';

part 'backupCurrencyApi.g.dart';

@RestApi(baseUrl: "https://api.frankfurter.app/")
abstract class BackupCurrencyApi {
  factory BackupCurrencyApi(Dio dio, {String baseUrl}) = _BackupCurrencyApi;

  @GET("latest?")
  Future<HttpResponse<CurrencyResponse>> getCurrencyRate(@Query("from") String currencyFrom,
      @Query("to") String currencyTo);
}

@JsonSerializable()
class CurrencyResponse implements Mapper{
  String? data;
  double amount;
  Map<String, double>? rates;
  String? base;

  CurrencyResponse(this.data, this.amount, this.rates, this.base);

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) => _$CurrencyResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyResponseToJson(this);

  @override
  Currency convert() {
    MapEntry<String, double>? entry = rates?.entries.elementAt(0);
    return Currency(base, entry?.key, entry?.value);
  }
}