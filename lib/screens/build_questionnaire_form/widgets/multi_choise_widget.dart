import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
// Custom Widget for Multi Choice
class MultiChoiceQuestion extends StatelessWidget {
  final List<String> choices;
  GroupController controller = GroupController();

  MultiChoiceQuestion({required this.choices});

  @override
  Widget build(BuildContext context) {
    return SimpleGroupedCheckbox<int>(
      controller: controller,
      itemsTitle: ["1" ,"2","4","5"],
      values: [1,2,4,5],
      groupStyle: GroupStyle(
          activeColor: Colors.red,
          itemTitleStyle: TextStyle(
              fontSize: 13
          )
      ),
    );
  }
}