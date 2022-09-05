import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class DropDownBox extends StatelessWidget {
  final List<String> _selection;
  final Function(String?) _onChanged;

  const DropDownBox(this._selection, this._onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colourThree,
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22))),
      child: DropdownSearch<String>(
        popupProps: const PopupProps.dialog(showSearchBox: true),
        items: _selection,
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: EdgeInsets.all(14),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            hintText: "Select a currency",
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }

}