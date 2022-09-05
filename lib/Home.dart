import 'package:easy_cc_flutter/MainViewModel.dart';
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(model.data, (selected) {}),
              EditText("Enter conversion from", model.top, (selection) => {})
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropDownBox(model.data, (selected) {}),
              EditText("Enter conversion from", model.bottom, (selection) => {})
            ],
          ),
        ),
      ],
    );
  }
}
