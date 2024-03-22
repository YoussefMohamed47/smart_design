import 'dart:async';

import 'package:questionnaire/app/app_enums.dart';
import 'package:questionnaire/domain/model/make_form_template/ItemModel.dart';
import 'package:questionnaire/domain/model/make_form_template/dynamicModel.dart';
import 'package:questionnaire/domain/model/make_form_template/form_model.dart';
import 'package:questionnaire/domain/usecase/make_form_template_usecase.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import 'package:questionnaire/presentation/base/baseviewmodel.dart';

class MakeFormTemplateViewModel extends BaseViewModel
    with MakeFormTemplateViewModelInput, MakeFormTemplateViewModelOutput {
  MakeFormTemplateViewModel(this._makeFormTemplateUseCase) : super();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  StreamController<MakeFormTemplateUseCaseModel>
  _makeFormTemplateStreamController =
  StreamController<MakeFormTemplateUseCaseModel>.broadcast();
  final MakeFormTemplateUseCaseModel _model =
  MakeFormTemplateUseCaseModel();

  FormItemType selectedQuestionType =FormItemType.ShortText;

  bool isRequired=false;
  FormModel dynamicFormModel = FormModel(formName: "form 1",questions: []);
  List<QuestionTypeModel> questionTypeList = [
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.ShortText] ?? 2,
    'Short Text',
        FormItemType.ShortText
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.LongText] ?? 1,
    'Long Text',
        FormItemType.LongText
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.SingleChoice] ?? 3,
    'Single Choice',
        FormItemType.SingleChoice
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.MultiChoice] ?? 4,
    'Multi Choice',
        FormItemType.MultiChoice
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.Number] ?? 5,
    'Number',
        FormItemType.Number
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.Float] ?? 6,
    'Float',
        FormItemType.Float
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.Date] ?? 7,
    'Date',
        FormItemType.Date
    ),
    QuestionTypeModel(FormItemTypeEnum.toInt[FormItemType.Time] ?? 8,
    'Time',
        FormItemType.Time
    ),


  ];
  final MakeFormTemplateUseCase _makeFormTemplateUseCase;

  // output
  @override
  void dispose() {
    _makeFormTemplateStreamController.close();
  }

  @override
  Sink get inputMakeFormTemplateInput =>
      _makeFormTemplateStreamController.sink;

  @override
  Stream<MakeFormTemplateUseCaseModel> get outputMakeFormTemplateContent =>
      _makeFormTemplateStreamController.stream.map((home) => home);

  // input
  @override
  Future start() async {
    if (_makeFormTemplateStreamController.isClosed) {
      _makeFormTemplateStreamController =
      StreamController<MakeFormTemplateUseCaseModel>.broadcast();
    }
  //  await getTermsAndConditions();
    postDataToView();
  }

  postDataToView() {
    if (!_makeFormTemplateStreamController.isClosed) {
      inputMakeFormTemplateInput.add(_model);
    }
  }

}

mixin MakeFormTemplateViewModelInput {
  Sink get inputMakeFormTemplateInput;
}

mixin MakeFormTemplateViewModelOutput {
  Stream<MakeFormTemplateUseCaseModel> get outputMakeFormTemplateContent;
}

class MakeFormTemplateUseCaseModel {
  MakeFormTemplateUseCaseModel();

}

class QuestionTypeModel{
  int id;
  String name;
  FormItemType questionType;
  QuestionTypeModel(this.id,this.name,this.questionType);
}
