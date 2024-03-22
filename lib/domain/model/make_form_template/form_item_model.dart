import 'package:questionnaire/app/app_enums.dart';

class FormItem {
  final String question;
  final FormItemType questionType;
  final List<String>? options;
  final bool isRequired;

  FormItem({
    required this.question,
    required this.questionType,
    this.options,
    required this.isRequired,
  });
}

