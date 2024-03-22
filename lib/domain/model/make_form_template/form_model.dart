import 'package:questionnaire/app/app_enums.dart';
import 'package:questionnaire/domain/model/make_form_template/ItemModel.dart';
import 'package:questionnaire/domain/model/make_form_template/dynamic_form_validator.dart';
import 'package:questionnaire/domain/model/make_form_template/question_item_model.dart';

class FormModel {
  String? formName;
  List<QuestionItemModel> questions = [];

  FormModel(
      {
        this.formName,
        required this.questions ,
       });
}