import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/Constants.dart';

class ConverterEditText extends StatelessWidget {
  final String _hintText;
  final Function(String?) _onChanged;
  final TextEditingController _controller;

  const ConverterEditText(this._hintText, this._controller, this._onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: TextField(
        controller: _controller,
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ],
      ),
    );
  }

}