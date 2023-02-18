import 'package:easy_cc_flutter/Utils/currency_utils.dart';
import 'package:easy_cc_flutter/data/network/backup_currency_api.dart';
import 'package:easy_cc_flutter/data/network/currency_api.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';

import 'data/model/currency.dart';
import 'data/prefs/preference_provider.dart';
import 'data/repository/repository.dart';
import 'data/repository/repository_impl.dart';
import 'home.dart';
import 'locator.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator<PreferenceProvider>().init();
  await HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<bool?> backgroundCallback(Uri? uri) async {
  PreferenceProvider prefs = PreferenceProvider();
  await prefs.init();
  CurrencyApi api = CurrencyApi.create();
  BackupCurrencyApi backupApi = BackupCurrencyApi.create();
  RepositoryImpl repository = RepositoryImpl(prefs, api, backupApi);

  if (uri?.host == 'updatewidget') {
    Map<String, String>? querys = uri?.queryParameters;
    String? widgetId = querys?["id"];

    return await updateWidget(widgetId, repository);
  } else if (uri?.host == 'createwidget') {
    Map<String, String>? querys = uri?.queryParameters;
    String? widgetId = querys?["id"];
    String? from = querys?["from"]?.getCurrencyCode();
    String? to = querys?["to"]?.getCurrencyCode();

    await HomeWidget.saveWidgetData<String>("${widgetId}_from", from);
    await HomeWidget.saveWidgetData<String>("${widgetId}_to", to);

    return await updateWidget(widgetId, repository);
  }
  return null;
}

Future<bool?> updateWidget(String? widgetId, Repository repository) async {
  String? from = await HomeWidget.getWidgetData<String>("${widgetId}_from");
  String? to = await HomeWidget.getWidgetData<String>("${widgetId}_to");

  if (from == null || to == null) {
    return false;
  }

  Currency currency = await repository.getConversationRateFromApi(from, to);

  await HomeWidget.saveWidgetData<String>("${widgetId}_from", from);
  await HomeWidget.saveWidgetData<String>("${widgetId}_to", to);
  await HomeWidget.saveWidgetData<String>(
      "${widgetId}_rate", currency.rate.toString());
  await HomeWidget.saveWidgetData<bool>("${widgetId}_forced_update", true);

  return await HomeWidget.updateWidget(
      name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
