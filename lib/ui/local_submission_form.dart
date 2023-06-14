import 'package:astech_demo/customs/custom_text_field.dart';
import 'package:astech_demo/customs/custom_switch_field.dart';
import 'package:astech_demo/commons/field.dart';
import 'package:astech_demo/commons/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LocalSubmissionForm extends StatefulWidget {
  const LocalSubmissionForm({super.key});

  @override
  State<LocalSubmissionForm> createState() => _LocalSubmissionFormState();
}

class _LocalSubmissionFormState extends State<LocalSubmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // form field state
  FormBuilderState? get formFieldState => _formKey.currentState;

  // form fields
  late final String roFieldName = 'ro';
  late final String odometerFieldName = 'odometer';
  late final String unitFieldName = 'unit';

  // form fields key
  late final GlobalKey<FormBuilderFieldState> roFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: roFieldName);
  late final GlobalKey<FormBuilderFieldState> odometerFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: odometerFieldName);
  late final GlobalKey<FormBuilderFieldState> unitFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: unitFieldName);

  // focus
  late final FocusNode roFocus = FocusNode(debugLabel: roFieldName);
  late final FocusNode odometerFocus = FocusNode(debugLabel: odometerFieldName);
  late final FocusNode unitFocus = FocusNode(debugLabel: unitFieldName);
  late final FocusNode submitBtnFocus = FocusNode(debugLabel: 'submit');

  // AccountType
  late final String accountType;

  @override
  void initState() {
    accountType = 'belron';

    // pre-populate data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // init data
      _formKey.currentState?.patchValue({
        // roField.name: '',
        // odometerField.name: '',
        unitFieldName: 'Miles'
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    roFocus.dispose();
    odometerFocus.dispose();
    unitFocus.dispose();
    submitBtnFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Local'),
        backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 0, thickness: 2),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[2],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('form isValid: ${formFieldState?.isValid}'),
                  Expanded(
                    child: Text('fieldsValues: ${formFieldState?.value}'),
                  ),
                ],
              ),
            ),
            FormBuilder(
              key: _formKey,
              onChanged: () {
                formFieldState!.save();
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CustomTextField(
                      fieldKey: roFieldKey,
                      name: roFieldName,
                      required: true,
                      labelText: roLabelText,
                      hintText: roHintText,
                      helpText: roHelperText,
                      maxLength: 32,
                      hideCounter: true,
                      inputFormatters: roInputFormatters,
                      onEditingComplete: () => node.nextFocus(),
                      focusNode: roFocus,
                      validator: roValidator,
                      textInputAction: TextInputAction.next,
                      keyboardType: roKeyboardType,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            fieldKey: odometerFieldKey,
                            name: odometerFieldName,
                            required: true,
                            labelText: 'Odometer',
                            hintText: 'Odometer',
                            validator: FormBuilderValidators.compose<String>([
                              FormBuilderValidators.maxLength(7),
                            ]),
                            maxLength: 7,
                            focusNode: odometerFocus,
                            onEditingComplete: () => node.nextFocus(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomSwitchField<String>(
                            fieldKey: unitFieldKey,
                            name: unitFieldName,
                            required: true,
                            items: const [
                              SwitchItem(title: 'Miles', value: 'Miles'),
                              SwitchItem(title: 'KM', value: 'KM'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      autofocus: true,
                      focusNode: submitBtnFocus,
                      onPressed: formFieldState?.isValid == true
                          ? () {
                              node.unfocus();
                            }
                          : null,
                      child: const Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get roLabelText {
    var labelText = 'RO#';
    if (accountType == 'belron') {
      labelText = 'Job ID';
    }
    return labelText;
  }

  String get roHintText {
    var hintText = 'Repair Order Number';
    if (accountType == 'belron') {
      hintText = 'Job ID';
    }
    return hintText;
  }

  String get roHelperText {
    var helperText = 'Value must have a length equal to 32';
    if (accountType == 'belron') {
      helperText = 'Value must have a length equal to 14';
    }
    if (accountType == 'safelite') {
      helperText = 'Value must have a length equal to 11';
    }
    return helperText;
  }

  late List<TextInputFormatter>? roInputFormatters = [
    if (accountType == 'belron') CustomFormatter.belronFormatter(),
    if (accountType == 'safelite') CustomFormatter.safeliteFormatter(),
  ];

  late FormFieldValidator<String>? roValidator = FormBuilderValidators.compose([
    if (accountType == 'belron') FormBuilderValidators.equalLength(14),
    if (accountType == 'safelite') FormBuilderValidators.equalLength(11),
  ]);

  late TextInputType roKeyboardType =
      accountType == 'belron' || accountType == 'safelite'
          ? TextInputType.number
          : TextInputType.visiblePassword;
}
