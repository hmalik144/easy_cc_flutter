import 'package:easy_cc_flutter/MainViewModel.dart';
import 'package:easy_cc_flutter/Utils/SelectionType.dart';
import 'package:easy_cc_flutter/views/DropDownBox.dart';
import 'package:easy_cc_flutter/views/EditText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'BaseStatelessWidget.dart';

class HomePage extends BaseStatelessWidget<MainViewModel> {
  @override
  MainViewModel createViewModel() {
    return MainViewModel();
  }

  @override
  Widget displayWidget(
      BuildContext context, MainViewModel model, Widget? child) {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(model.data, (selected) {}),
              ConverterEditText("Enter conversion from", controller1, (input) => {
                controller2.text = model.convertInput(input, SelectionType.conversionFrom)
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(model.data, (selected) {}),
              ConverterEditText("Enter conversion from", controller2, (input) => {
                controller1.text = model.convertInput(input, SelectionType.conversionTo)
              })
            ],
          ),
        ),
      ],
    );
  }
}
