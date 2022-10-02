import 'package:sealed_annotations/sealed_annotations.dart';

@Sealed()
abstract class ViewState {}

class Idle implements ViewState {}

class HasStarted implements ViewState {}

class HasData implements ViewState {
  final dynamic data;

  HasData(this.data);
}

class HasError implements ViewState {
  final String error;

  HasError(this.error);
}
