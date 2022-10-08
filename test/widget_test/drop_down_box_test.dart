import 'package:easy_cc_flutter/Utils/constants.dart';
import 'package:easy_cc_flutter/views/drop_down_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Drop down box has hint present', (tester) async {
    // Create the widget by telling the tester to build it.
    const hintText = "Test hint text";
    final box = DropDownBox(listOfCurrencies, hintText, (selected) {});
    await tester.pumpWidget(MaterialApp(
      home: box,
    ));
    final hintFinder = find.text(hintText);

    expect(hintFinder, findsOneWidget);
  });
}