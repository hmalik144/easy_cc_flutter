import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:easy_cc_flutter/data/model/currency.dart';
import 'package:easy_cc_flutter/data/network/backup_currency_api.dart';
import 'package:easy_cc_flutter/data/network/currency_api.dart';
import 'package:easy_cc_flutter/data/prefs/currency_pair.dart';
import 'package:easy_cc_flutter/data/prefs/preference_provider.dart';
import 'package:easy_cc_flutter/data/repository/repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart' as http;

import '../test_utils/test_utils.dart';
import 'repository_test.mocks.dart';

@GenerateMocks([
  PreferenceProvider,
  CurrencyApi,
  BackupCurrencyApi
], customMocks: [
  MockSpec<http.HttpResponse<ResponseObject>>(
      onMissingStub: OnMissingStub.returnDefault),
  MockSpec<http.HttpResponse<CurrencyResponse>>(
      as: #MockCurrencyResponse, onMissingStub: OnMissingStub.returnDefault),
  MockSpec<HttpException>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DioError>(onMissingStub: OnMissingStub.returnDefault)
])
void main() {
  late RepositoryImpl sut;

  late PreferenceProvider preferenceProvider;
  late CurrencyApi currencyApi;
  late BackupCurrencyApi backupCurrencyApi;

  const String fromCurrency = "AUD - Australian Dollar";
  const String toCurrency = "GBP - British Pound Sterling";

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Create mock object.
    preferenceProvider = MockPreferenceProvider();
    currencyApi = MockCurrencyApi();
    backupCurrencyApi = MockBackupCurrencyApi();

    sut = RepositoryImpl(preferenceProvider, currencyApi, backupCurrencyApi);
  });

  test('get currency pair from prefs', () {
    // Given
    CurrencyPair pair = CurrencyPair(fromCurrency, toCurrency);

    // When
    when(preferenceProvider.getConversionPair()).thenReturn(pair);

    // Then
    expect(sut.getConversionPair(), pair);
  });

  test('get currency rate from API', () async {
    // Given
    http.HttpResponse<ResponseObject> mockResponse = MockHttpResponse();
    ResponseObject responseObject = ResponseObject.fromJson(
        await readJson("test/resources/success_call_api"));
    Currency currencyObject = Currency("AUD", "GBP", 0.601188);

    // When
    when(mockResponse.data).thenReturn(responseObject);
    when(currencyApi.getConversion("AUD", "GBP"))
        .thenAnswer((_) async => mockResponse);

    // Then
    Currency retrieved =
        await sut.getConversationRateFromApi(fromCurrency, toCurrency);
    expect(retrieved.toString(), currencyObject.toString());
  });

  test('get currency rate from backup API', () async {
    // Given
    http.HttpResponse<CurrencyResponse> mockResponse = MockCurrencyResponse();
    CurrencyResponse currencyResponse = CurrencyResponse.fromJson(
        await readJson("test/resources/success_call_backup_api"));
    Currency currencyObject = Currency("AUD", "GBP", 0.601188);

    // When
    when(currencyApi.getConversion("AUD", "GBP"))
        .thenAnswer((_) async => Future.error(MockHttpException()));
    when(mockResponse.data).thenReturn(currencyResponse);
    when(backupCurrencyApi.getCurrencyRate("AUD", "GBP"))
        .thenAnswer((_) async => mockResponse);

    // Then
    Currency retrieved =
        await sut.getConversationRateFromApi(fromCurrency, toCurrency);
    expect(retrieved.toString(), currencyObject.toString());
  });

  test('unable to retrieve rate from both APIs', () async {
    // Given
    MockDioError backUpError = MockDioError();

    // When
    when(backUpError.message).thenReturn("Error message");
    when(currencyApi.getConversion("AUD", "GBP"))
        .thenAnswer((_) async => Future.error(MockDioError()));
    when(backupCurrencyApi.getCurrencyRate("AUD", "GBP"))
        .thenAnswer((_) async => Future.error(backUpError));

    // Then
    expect(
        () async =>
            await sut.getConversationRateFromApi(fromCurrency, toCurrency),
        throwsA(predicate(
            (e) => e is HttpException && e.message == 'Error message')));
  });
}
