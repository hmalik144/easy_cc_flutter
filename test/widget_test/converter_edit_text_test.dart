import 'package:easy_cc_flutter/views/converter_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('converter edit text controls test', (tester) async {
    // Create the widget by telling the tester to build it.
    const hintText = "Test hint text";
    const enterText = "some random text";
    TextEditingController controller = TextEditingController();
    final box = ConverterEditText(hintText, controller, (input) {
      expect(find.text(input!), findsOneWidget);
    });
    await tester.pumpWidget(MaterialApp(
      home: Material(child: box),
    ));

    final hintFinder = find.text(hintText);
    expect(hintFinder, findsOneWidget);

    controller.text = enterText;
    final textFinder = find.text(hintText);
    expect(textFinder, findsOneWidget);
  });
}