import 'package:flutter/material.dart';
import 'package:questionnaire/app/app_enums.dart';
import 'package:questionnaire/domain/model/make_form_template/form_item_model.dart';
class DynamicForm extends StatefulWidget {
  final formName;
  final List<FormItem> formItems;

  DynamicForm({required this.formName ,required this.formItems});

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 14.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: widget.formItems.length,
            itemBuilder: (context, index) {
              final formItem = widget.formItems[index];
              switch (formItem.questionType) {
                case FormItemType.ShortText:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(formItem.question,style:  const TextStyle(
                          fontWeight: FontWeight.bold),),
                      TextFormField(
                        decoration: InputDecoration(


                          focusedBorder: OutlineInputBorder(
                              borderSide:  BorderSide(width: 0.7,
                               ),
                              borderRadius: BorderRadius.circular(5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:  BorderSide(
                                width: 0.7,

                              )),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) {
                          if (formItem.isRequired && value?.isEmpty == true) {
                            return 'This field is required';
                          }
                          if (value != null && value.length > 50) {
                            return 'Must not exceed 50 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData[formItem.question] = value,
                      ),
                    ],
                  );
                case FormItemType.LongText:
                  return TextFormField(
                    decoration: InputDecoration(labelText: formItem.question),
                    maxLines: null,
                    validator: (value) {
                      if (formItem.isRequired && value?.isEmpty == true) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _formData[formItem.question] = value,
                  );
                case FormItemType.SingleChoice:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formItem.question),
                      DropdownButtonFormField<String>(
                        value: null,
                        items: formItem.options!
                            .map((option) => DropdownMenuItem(
                          child: Text(option),
                          value: option,
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _formData[formItem.question] = value;
                          });
                        },
                        validator: (value) {
                          if (formItem.isRequired && value == null) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                case FormItemType.MultiChoice:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formItem.question),
                      Column(
                        children: formItem.options!
                            .map((option) => CheckboxListTile(
                          title: Text(option),
                          value: _formData[formItem.question] != null
                              ? _formData[formItem.question].contains(option)
                              : false,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null) {
                                List<String> selectedOptions =
                                _formData[formItem.question] != null
                                    ? List.from(_formData[formItem.question])
                                    : [];
                                if (value) {
                                  selectedOptions.add(option);
                                } else {
                                  selectedOptions.remove(option);
                                }
                                _formData[formItem.question] = selectedOptions;
                              }
                            });
                          },
                        ))
                            .toList(),
                      ),
                    ],
                  );
                case FormItemType.Number:
                  return TextFormField(
                    decoration: InputDecoration(labelText: formItem.question),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (formItem.isRequired && value!.isEmpty) {
                        return 'This field is required';
                      }
                      if (value != null &&
                          int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                    _formData[formItem.question] = int.parse(value!),
                  );
                case FormItemType.Float:
                  return TextFormField(
                    decoration: InputDecoration(labelText: formItem.question),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (formItem.isRequired && value!.isEmpty) {
                        return 'This field is required';
                      }
                      if (value != null &&
                          double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) =>
                    _formData[formItem.question] = double.parse(value!),
                  );
                case FormItemType.Date:
                  return TextFormField(
                    decoration: InputDecoration(labelText: formItem.question),
                    readOnly: true,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _formData[formItem.question] = selectedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (formItem.isRequired && value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    controller: TextEditingController(
                        text: _formData[formItem.question] != null
                            ? _formData[formItem.question].toString()
                            : ''),
                  );
                case FormItemType.Time:
                  return TextFormField(
                    decoration: InputDecoration(labelText: formItem.question),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _formData[formItem.question] = selectedTime;
                        });
                      }
                    },
                    validator: (value) {
                      if (formItem.isRequired && value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    controller: TextEditingController(
                        text: _formData[formItem.question] != null
                            ? _formData[formItem.question].toString()
                            : ''),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // Do something with the form data
            print(_formData);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

