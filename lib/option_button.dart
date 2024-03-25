import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String optionName;
  final bool isSelected;
  final Function onSelect;

  OptionButton({
    required this.isSelected,
    required this.onSelect,
    required this.optionName,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return OutlinedButton(
          onPressed: () => onSelect(), child: Text(optionName));
    }
    return FilledButton(
        onPressed: () => onSelect(), child: Text(optionName));
  }
}
