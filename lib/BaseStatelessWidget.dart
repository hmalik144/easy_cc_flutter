import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'BaseViewModel.dart';
import 'Utils/Constants.dart';
import 'Utils/ViewState.dart';
import 'Utils/ViewUtils.dart';

abstract class BaseStatelessWidget<T extends BaseViewmodel>
    extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  T createViewModel();

  Widget displayWidget(BuildContext context, T model, Widget? child);

  @override
  Widget build(BuildContext parent) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(paddingGlobal),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colourTwo, colourThree])),
        child: ViewModelBuilder<T>.reactive(
            viewModelBuilder: () => createViewModel(),
            builder: (context, model, child) {
              var state = model.viewState;

              if (state is HasStarted) {
                onStarted();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HasError) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => ViewUtils.displayToast(parent, state.error));
              }
              return Center(
                child: displayWidget(context, model, child),
              );
            },
            onModelReady: (T model) => onModelReady(model)),
      ),
    );
  }

  void onModelReady(model) {}

  void onStarted() {}
}
