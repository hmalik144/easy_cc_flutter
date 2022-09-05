import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

class ViewUtils{

  static displayToast(BuildContext context, String message){
    Toast.show(
        message,
        duration: Toast.lengthLong,
        gravity:  Toast.bottom
    );
  }

  static displayToastDeferred(BuildContext context, String message){
    WidgetsBinding.instance.addPostFrameCallback(
            (_) => displayToast(context, message));
  }
}