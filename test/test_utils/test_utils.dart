import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> readJson(String filePath) async {
  final String response = await rootBundle.loadString('$filePath.json');
  return await json.decode(response);
}