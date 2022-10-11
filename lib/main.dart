import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:logger/logger.dart';

import 'data/prefs/preference_provider.dart';
import 'home.dart';
import 'locator.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await locator<PreferenceProvider>().init();
  runApp(const MyApp());
}

Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    Map<String, String>? querys = uri?.queryParameters;

    int _counter = 0;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0).then((int? value) {
      _counter = value ?? 0;
      _counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', _counter);
    await HomeWidget.updateWidget(name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  } else if (uri?.host == 'createWidget') {
    Map<String, String>? querys = uri?.queryParameters;
    String? id = querys?["id"];
    String? from = querys?["from"];
    String? to = querys?["to"];


  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
