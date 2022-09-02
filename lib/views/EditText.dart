import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class EditText extends StatelessWidget {
  final String _hintText;
  final String? _input;
  final Function(String?) _onChanged;

  const EditText(this._hintText, this._input, this._onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: TextField(
        controller: TextEditingController(
          text: _input
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(14),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(22)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: colourTwo,
          hintText: _hintText,
        ),
        onChanged: _onChanged,

      ),
    );
  }

}