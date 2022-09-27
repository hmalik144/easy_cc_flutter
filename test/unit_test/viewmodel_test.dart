import 'dart:io';

import 'package:easy_cc_flutter/MainViewModel.dart';
import 'package:easy_cc_flutter/Utils/SelectionType.dart';
import 'package:easy_cc_flutter/data/model/Currency.dart';
import 'package:easy_cc_flutter/data/prefs/CurrencyPair.dart';
import 'package:easy_cc_flutter/data/repository/RepositoryImpl.dart';
import 'package:easy_cc_flutter/locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:easy_cc_flutter/Utils/ViewState.dart';

import 'viewmodel_test.mocks.dart';

@GenerateMocks([
  RepositoryImpl
])
void main() {
  late MainViewModel mainViewModel;
  late RepositoryImpl repository;

  const String fromCurrency = "AUD - Australian Dollar";
  const String toCurrency = "GBP - British Pound Sterling";

  setUpAll(() async {
    // Setup
    await dotenv.load(fileName: "test/resources/test_res.env");
    // Create mock object.
    repository = MockRepositoryImpl();

    locator.registerLazySingleton(() => repository);

    mainViewModel = MainViewModel();
  });

  test('get currency pair from prefs', () {
    // Given
    CurrencyPair pair = CurrencyPair(fromCurrency, toCurrency);

    // When
    when(repository.getConversionPair()).thenReturn(pair);

    // Then
    String fromSelection = mainViewModel.getConversionPair(SelectionType.conversionFrom);
    String toSelection = mainViewModel.getConversionPair(SelectionType.conversionTo);
    expect(fromSelection, fromCurrency);
    expect(toSelection, toCurrency);
  });

  test('get currency pair from prefs nothing stored', () {
    // Given
    CurrencyPair pair = CurrencyPair(null, null);

    // When
    when(repository.getConversionPair()).thenReturn(pair);

    // Then
    String fromSelection = mainViewModel.getConversionPair(SelectionType.conversionFrom);
    String toSelection = mainViewModel.getConversionPair(SelectionType.conversionTo);
    expect(fromSelection, "ALL - Albanian Lek");
    expect(toSelection, "ALL - Albanian Lek");
  });

  test('set the currency rate from API', () async{
    // Given
    Currency currency = Currency(fromCurrency, toCurrency, 0.6);

    // When
    when(repository.getConversationRateFromApi(fromCurrency, toCurrency))
        .thenAnswer((_) async => currency);

    // Then
    mainViewModel.setCurrencyRate(fromCurrency, toCurrency);
    await Future.delayed(const Duration(milliseconds: 100));

    expect((mainViewModel.viewState as HasData).data, currency);
    expect(mainViewModel.conversionRate, currency.rate);
  });

  test('currency rate api fails to retrieve data', () async{
    // Given
    String errorMessage = "failed to retrieve data";

    // When
    when(repository.getConversationRateFromApi(fromCurrency, toCurrency))
        .thenAnswer((_) async => Future.error(HttpException(errorMessage)));

    // Then
    mainViewModel.setCurrencyRate(fromCurrency, toCurrency);
    await Future.delayed(const Duration(milliseconds: 100));

    expect((mainViewModel.viewState as HasError).error, errorMessage);
  });

  test('convert input with correct format', () async{
    // Given
    String input = "43";
    mainViewModel.conversionRate = 6.34;

    // When

    // Then
    expect(mainViewModel.convertInput(input, SelectionType.conversionFrom), "272.62");
    expect(mainViewModel.convertInput(input, SelectionType.conversionTo), "6.78");
  });

  test('convert input with empty input', () async{
    // Given
    String input = "";
    mainViewModel.conversionRate = 6.34;

    // When

    // Then
    expect(mainViewModel.convertInput(input, SelectionType.conversionFrom), "");
    expect(mainViewModel.convertInput(input, SelectionType.conversionTo), "");
  });

  test('convert input with empty input', () async{
    // Given
    String input = "45.45564";
    mainViewModel.conversionRate = 6.34;

    // When

    // Then
    expect(mainViewModel.convertInput(input, SelectionType.conversionFrom), "288.19");
    expect(mainViewModel.convertInput(input, SelectionType.conversionTo), "7.17");
  });
}