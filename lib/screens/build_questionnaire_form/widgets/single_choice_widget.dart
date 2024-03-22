
import 'package:flutter/material.dart';
// Custom Widget for Single Choice
class SingleChoiceQuestion extends StatelessWidget {
  final List<String> choices;
  final Function(String? value) onChangedAnswer;

  SingleChoiceQuestion({required this.choices,required this.onChangedAnswer});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: choices.map((choice) {
        return DropdownMenuItem(
          value: choice,
          child: Text(choice),
        );
      }).toList(),
      decoration: InputDecoration(labelText: 'Single Choice'),
      onChanged: (String? value) {
      onChangedAnswer(value);
    },
    );
  }
}