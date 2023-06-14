import 'package:astech_demo/custom_switch_field.dart';
import 'package:astech_demo/custom_text_field.dart';
import 'package:astech_demo/field.dart';
import 'package:astech_demo/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class RemoteSubmissionForm extends StatefulWidget {
  const RemoteSubmissionForm({super.key});

  @override
  State<RemoteSubmissionForm> createState() => _RemoteSubmissionFormState();
}

class _RemoteSubmissionFormState extends State<RemoteSubmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // form field state
  FormBuilderState? get formFieldState => _formKey.currentState;

  // form fields
  late final Field<String> roField;
  late final Field<String> odometerField;
  late final Field<String> unitField;

  // focus
  late final FocusNode submitBtnFocus = FocusNode(debugLabel: 'submit');

  // AccountType
  late final String accountType;

  @override
  void initState() {
    accountType = 'belron';

    initializeFields();

    // pre-populate data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // init data
      _formKey.currentState?.patchValue({
        // roField.name: '',
        // odometerField.name: '',
        unitField.name: 'Miles'
      });
    });

    super.initState();
  }

  void initializeFields() {
    roField = Field<String>(
      name: 'ro',
      required: true,
      labelText: 'RO#',
      hintText: 'Repair Order Number',
      helperText: 'Must contain less than 32 characters',
    );

    if (accountType == 'belron') {
      roField
        ..labelText = 'Job ID'
        ..hintText = 'Job ID'
        ..helperText = 'Must be contain 14 characters'
        ..inputFormatters = [CustomFormatter.belronFormatter()]
        ..validator = FormBuilderValidators.compose<String>([
          FormBuilderValidators.equalLength(14),
        ]);
    }

    if (accountType == 'safelite') {
      roField
        ..helperText = 'Must be contain 11 characters'
        ..inputFormatters = [CustomFormatter.safeliteFormatter()]
        ..validator = FormBuilderValidators.compose<String>([
          FormBuilderValidators.equalLength(11),
        ]);
    }

    odometerField = Field<String>(
      name: 'odometer',
      required: true,
      labelText: 'Odometer',
      hintText: 'Odometer',
      helperText: 'Must contain less than 7 characters',
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(7),
      ]),
    );

    unitField = Field<String>(
      name: 'unit',
      required: true,
    );
  }

  @override
  void dispose() {
    roField.dispose();
    odometerField.dispose();
    unitField.dispose();
    submitBtnFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Remote'),
        backgroundColor: Colors.white,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 0, thickness: 2),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Text('Vehicle Information'),
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
                      fieldKey: roField.key,
                      name: roField.name,
                      required: roField.required,
                      labelText: roField.labelText,
                      hintText: roField.hintText,
                      helpText: roField.helperText,
                      maxLength: 32,
                      hideCounter: true,
                      inputFormatters: roField.inputFormatters,
                      onEditingComplete: () => node.nextFocus(),
                      focusNode: roField.focusNode,
                      validator: roField.validator,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            fieldKey: odometerField.key,
                            name: odometerField.name,
                            required: odometerField.required,
                            labelText: odometerField.labelText,
                            hintText: odometerField.hintText,
                            helpText: odometerField.helperText,
                            validator: odometerField.validator,
                            maxLength: 7,
                            focusNode: odometerField.focusNode,
                            onEditingComplete: () => node.nextFocus(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomSwitchField<String>(
                            fieldKey: unitField.key,
                            name: unitField.name,
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
}
