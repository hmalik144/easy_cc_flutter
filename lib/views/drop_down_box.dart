import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../Utils/constants.dart';

class DropDownBox extends StatelessWidget {
  final List<String> _selection;
  final String _hintText;
  final Function(String?) _onChanged;

  const DropDownBox(this._selection, this._hintText, this._onChanged,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colourThree,
      elevation: 2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22))),
      child: DropdownSearch<String>(
        popupProps: const PopupProps.dialog(
            showSearchBox: true,
            dialogProps: DialogProps(backgroundColor: colourThree)),
        items: _selection,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.all(14),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.transparent,
            hintText: _hintText,
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }
}
