import 'package:easy_cc_flutter/Utils/selection_type.dart';
import 'package:easy_cc_flutter/locator.dart';
import 'package:easy_cc_flutter/main_view_model.dart';
import 'package:easy_cc_flutter/views/converter_edit_text.dart';
import 'package:easy_cc_flutter/views/drop_down_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Utils/constants.dart';
import 'base_widget.dart';

class HomePage extends BaseStatelessWidget<MainViewModel> {
  const HomePage({super.key});

  @override
  MainViewModel createViewModel() {
    return locator<MainViewModel>();
  }

  @override
  Widget displayWidget(BuildContext context, MainViewModel model, Widget? child) {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();

    String selected1 = model.getConversionPair(SelectionType.conversionFrom);
    String selected2 = model.getConversionPair(SelectionType.conversionTo);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(listOfCurrencies, selected1, (selected) {
                        selected1 = selected!;
                        model.setConversionPair(selected1, selected2);
                      }),
              ConverterEditText("Enter conversion from", controller1, (input) => {
                controller2.text = model.convertInput(input?.trim(), SelectionType.conversionFrom)
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(listOfCurrencies, selected2, (selected) {
                selected2 = selected!;
                model.setConversionPair(selected1, selected2);
              }),
              ConverterEditText("Enter conversion from", controller2, (input) => {
                controller1.text = model.convertInput(input?.trim(), SelectionType.conversionTo)
              })
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onModelReady(MainViewModel model) {
    String selected1 = model.getConversionPair(SelectionType.conversionFrom);
    String selected2 = model.getConversionPair(SelectionType.conversionTo);
    model.setCurrencyRate(selected1, selected2);
  }
}
