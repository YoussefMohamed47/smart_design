import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:questionnaire/app/app_enums.dart';
import 'package:questionnaire/app/app_shared.dart';
import 'package:questionnaire/app/constants.dart';
import 'package:questionnaire/app/di.dart';
import 'package:questionnaire/domain/model/make_form_template/ItemModel.dart';
import 'package:questionnaire/domain/model/make_form_template/form_item_model.dart';
import 'package:questionnaire/domain/model/make_form_template/question_item_model.dart';
import 'package:questionnaire/presentation/resources/base_page_route.dart';
import 'package:questionnaire/presentation/resources/color_manager.dart';
import 'package:questionnaire/screens/build_questionnaire_form/view/build_questionnaire_form_view.dart';
import 'package:questionnaire/screens/make_form_template/viewmodel/make_form_template_viewmodel.dart';
import 'package:questionnaire/utils/colors/appColors.dart';
class MakeFormTemplate extends StatefulWidget {
  const MakeFormTemplate({super.key});

  @override
  State<MakeFormTemplate> createState() => _MakeFormTemplateState();
}

class _MakeFormTemplateState extends State<MakeFormTemplate> {

  final MakeFormTemplateViewModel _viewModel =
  instance<MakeFormTemplateViewModel>();
  selectQuestionType(){
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.blackColor.withOpacity(0.0),
      // shape: RoundedRectangleBorder(
      //   borderRadius: const BorderRadius.only(
      //     topLeft: Radius.circular(32),
      //     topRight: Radius.circular(32),
      //   ),
      // ),

      isScrollControlled: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async{
            _viewModel.selectedQuestionType = FormItemType.ShortText;
            _viewModel.postDataToView();
            return true;
          },
          child: FractionallySizedBox(
            heightFactor: 0.3,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child:  Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        //  borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.withOpacity(0.6))
                        ),
                        padding: EdgeInsets.only(left: 8 ,right: 8 , top: 52),
                        child: DropdownButtonFormField<FormItemType>(
                            decoration:  InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              border: InputBorder.none,
                            ),
                            iconSize:  20,
                            // icon: SvgPicture.asset(
                            //     Assets.assetsSvgImagesIconAwesomeMapMarkerAlt.path),
                            value: _viewModel.selectedQuestionType,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: Constants.hecan),
                            hint: Text(
                              "Select Question Type",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: Constants.hecan),
                            ),
                            onChanged: (value) {
                              if (_viewModel.selectedQuestionType != value) {
                                _viewModel.selectedQuestionType = value ?? FormItemType.ShortText;

                              }
                            },
                            items: List.generate(
                              _viewModel.questionTypeList.length,
                                  (index) => DropdownMenuItem(
                                child: Text(
                                  _viewModel.questionTypeList[index].name,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                value: _viewModel.questionTypeList[index].questionType,
                              ),
                            )),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      addQuestionModel( _viewModel.selectedQuestionType );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ColorManager.black,
                        // borderRadius: BorderRadius.circular(12.r)
                      ),
                      child: Center(
                        child: Text("Next",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor
                          ),),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      _viewModel.selectedQuestionType = FormItemType.ShortText;
      _viewModel.postDataToView();
    });
  }


  addQuestionModel(FormItemType selectedQuestionType){
    TextEditingController questionController = TextEditingController();
    List<ItemModel> options=[];
    final formkey = GlobalKey<FormState>();

    options.add(ItemModel(
      TextEditingController()
    ));
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: const BorderRadius.only(
      //     topLeft: Radius.circular(32),
      //     topRight: Radius.circular(32),
      //   ),
      // ),

      isScrollControlled: true,
      builder: (context) {
        print("selectedQuestionType ======= $selectedQuestionType");
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: StatefulBuilder(
            builder: (BuildContext context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 22,),
                            Text('Question Type: ${selectedQuestionType.name}',style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: Constants.hecan
                            ),),
                            SizedBox(height: 12,),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  //  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.withOpacity(0.6))
                              ),
                              padding: EdgeInsets.only(left: 8 ,right: 8 , top: 0),
                              child: Form(
                                key: formkey,
                                child: TextFormField(
                                    controller: questionController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 6,
                                    minLines: 1,
                                    autofocus: false,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:  16),
                                    inputFormatters: [
                                      // LengthLimitingTextInputFormatter(
                                      //     AppConsts.chatMessageMaxLength),
                                    ],
                                    onChanged: (value) {

                                    },
                                    onTap: () {

                                    },
                                    validator: (val){
                                      if(val?.isEmpty ?? false){
                                        return 'filed required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                        fontSize: 14,
                                      ),
                                      errorMaxLines: 2,
                                      hintText:
                                    "Write your question",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                       16),

                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                          top: 4, left: 6, right: 6),
                                      // suffixIcon: Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                                      //   mainAxisSize: MainAxisSize.min, // added line
                                      //   children: [
                                      //
                                      //
                                      //
                                      //   ],
                                      // ),

                                      fillColor:
                                      Colors.white.withOpacity(0.2),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        borderSide:  BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        borderSide:  BorderSide(
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      focusedErrorBorder:
                                      OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              4.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .errorColor,
                                          )),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .errorColor,
                                          )),
                                    )),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Container(
                              color: Colors.white,
                                child: ElevatedButton(


                                    onPressed: () => setState(() => _viewModel.isRequired = !_viewModel.isRequired),


                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      elevation: MaterialStateProperty.all<double>(0),
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: 24.0,
                                              width: 24.0,
                                              child: Checkbox(
                                                  value: _viewModel.isRequired,
                                                  activeColor: ColorManager.black,
                                                  onChanged: (value){
                                                    setState(() => _viewModel.isRequired = value ?? false);
                                                  }
                                              )
                                          ),
                                          // You can play with the width to adjust your
                                          // desired spacing
                                          SizedBox(width: 10.0),
                                          Text("is Required",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            fontFamily: Constants.hecan
                                          ),
                                          )
                                        ]
                                    )
                                )
                            ),

                            selectedQuestionType == FormItemType.SingleChoice ||
                            selectedQuestionType == FormItemType.MultiChoice ?
                            Container(
                              color: Colors.white,
                              child: ListView.builder(
                                itemCount: options.length,
                                shrinkWrap: true,
                                primary: false,
                              //  physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  return Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                              controller: options[index].optionController,
                                              keyboardType: TextInputType.multiline,
                                              maxLines: 6,
                                              minLines: 1,
                                              autofocus: false,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:  16),
                                              inputFormatters: [
                                                // LengthLimitingTextInputFormatter(
                                                //     AppConsts.chatMessageMaxLength),
                                              ],
                                              onChanged: (value) {

                                              },
                                              onTap: () {

                                              },
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                errorMaxLines: 2,
                                                hintText:
                                                "Write your option ${index+1}",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                    16),

                                                filled: true,
                                                contentPadding: EdgeInsets.only(
                                                    top: 4, left: 6, right: 6),
                                                // suffixIcon: Row(
                                                //   mainAxisAlignment: MainAxisAlignmentaceBetween, // added line
                                                //   mainAxisSize: MainAxisSize.min, // added line
                                                //   children: [
                                                //
                                                //
                                                //
                                                //   ],
                                                // ),

                                                fillColor:
                                                Colors.white.withOpacity(0.2),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(4.0),
                                                  borderSide:  BorderSide(
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(4.0),
                                                  borderSide:  BorderSide(
                                                    color: Colors.grey.withOpacity(0.3),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        4.0),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                    )),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(4.0),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                    )),
                                              )),
                                        ),

                                      Row(

                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,

                                        children: [
                                          GestureDetector(
                                            child: Padding(
                                              padding:  EdgeInsets.only(left: 8.0,right: 1),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorManager.black
                                                ),
                                                child: Padding(
                                                  padding:  EdgeInsets.all(3.0),
                                                  child: Icon(Icons.add,color: ColorManager.white,size: 16,),
                                                ),
                                              ),
                                            ),
                                            onTap: (){  options.add(ItemModel(
                                                TextEditingController()
                                            ));
                                            setState((){});
                                            },
                                          ),
                                          GestureDetector(
                                            child: Padding(
                                              padding:  EdgeInsets.only(left: 8.0,right: 1),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorManager.black
                                                ),
                                                child: Padding(
                                                  padding:  EdgeInsets.all(3.0),
                                                  child: Icon(Icons.close,color: ColorManager.white,size: 16,),
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              if(options.length>1){
                                                options.removeAt(index);
                                                setState((){});
                                              }

                                            },
                                          ),
                                        ],
                                      )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ) :SizedBox()



                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    if(formkey.currentState?.validate() ?? false){
                      _viewModel.dynamicFormModel.formName= 'Form 1';
                      _viewModel.dynamicFormModel.questions.add(QuestionItemModel(
                          question: questionController.text,
                          questionType: _viewModel.selectedQuestionType,
                          options: options,
                          isRequired: _viewModel.isRequired,
                          validators: []
                      ));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }

                  },
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorManager.black,
                      // borderRadius: BorderRadius.circular(12.r)
                    ),
                    child: Center(
                      child: Text("Add Question",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor
                        ),),
                    ),
                  ),
                )

              ],
            ),
          ),
        );
      },
    ).then((value) {
      _viewModel.isRequired=false;
    });
  }
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _viewModel.start();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child:

        StreamBuilder<MakeFormTemplateUseCaseModel>(
            stream: _viewModel.outputMakeFormTemplateContent,
            builder: (context, snapshot) {
              MakeFormTemplateUseCaseModel? data = snapshot.data;
              return
                data != null ?
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 32,),
                      GestureDetector(
                        onTap: (){
                          List<FormItem> temp = [];
                          for(int i =0 ; i < _viewModel.dynamicFormModel.questions.length ; i ++){
                            List<String> options = [];
                            for(int o =0 ; o < _viewModel.dynamicFormModel.questions[i].options.length ; o ++){
                            for(int j =0 ; j < _viewModel.dynamicFormModel.questions[i].options[o].optionController.text.split(",").length ; j ++){
                              options.add(_viewModel.dynamicFormModel.questions[i].options[o].optionController.text.split(",")[j]);
                            }
                            }
                            temp.add(FormItem(question:_viewModel.dynamicFormModel.questions[i].question ?? '',
                                questionType: _viewModel.dynamicFormModel.questions[i].questionType ?? FormItemType.ShortText,
                                isRequired:  _viewModel.dynamicFormModel.questions[i].isRequired,
                              options:options
                            ));
                          }
                          Navigator.push(
                              context,
                              BasePageRoute(
                                  builder: (context) => DynamicForm(
                                    formName: _viewModel.dynamicFormModel.formName,
                                    formItems:  temp,

                                  )));
                        },
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 12),
                          child: Container(width: double.infinity,height: 48,
                          decoration: BoxDecoration(
                            color: ColorManager.black,
                              borderRadius: BorderRadius.circular(12),
                          ),
                            child: Center(
                              child:   Text("Show form",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Constants.hecan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                          itemCount: _viewModel.dynamicFormModel.questions.length,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                           decoration: BoxDecoration(
                             borderRadius:
                             BorderRadius.circular(8.0),
                             border: Border.all(color: Colors.grey.withOpacity(0.3))
                           ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12,),
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Text("${_viewModel.dynamicFormModel.questions[index].question}",
                                       style: TextStyle(
                                           color: Colors.black,
                                           fontFamily: Constants.hecan,
                                           fontSize: 16,
                                           fontWeight: FontWeight.bold
                                       ),
                                     ),
                                     SizedBox(width: 6,),
                                     Text(_viewModel.dynamicFormModel.questions[index].isRequired ? '*':'',

                                     style: TextStyle(
                                       color: Colors.red,
                                       fontFamily: Constants.hecan,
                                       fontSize: 14,
                                       fontWeight: FontWeight.bold
                                     ),
                                     ),

                                   ],
                                 ),
                                  SizedBox(height: 6,),
                                  Text("type :${_viewModel.dynamicFormModel.questions[index].questionType.toString().replaceAll('FormItemType.', '')}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: Constants.hecan,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  _viewModel.dynamicFormModel.questions[index].options.length > 2 ?
                                  Container(
                                    width: double.infinity,
                                    height: 24,
                                    color: Colors.transparent,

                                    child: ListView.builder(
                                        itemCount: _viewModel.dynamicFormModel.questions[index].options.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,i){
                                      return    Text("${_viewModel.dynamicFormModel.questions[index].options[i].optionController.text} , ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: Constants.hecan,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ),
                                      );
                                    }),
                                  ):SizedBox(),

                                  SizedBox(height: 12,),
                                ],
                              ),
                            ),
                            //padding: EdgeInsets.all(8),
                          ),
                        );
                      })
                    ],
                  ),
                ):const SizedBox();
            })

      ),
      floatingActionButton:  FloatingActionButton(
          elevation: 0.0,
        //  backgroundColor: AppColors.blackColor,
          onPressed: (){
            selectQuestionType();
          },
          child:  const Icon(Icons.add,color: Colors.white,)
      ),
    );
  }
}
