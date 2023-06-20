import 'package:astech_demo/commons/distance_unit.dart';
import 'package:astech_demo/customs/custom_dropdown_group_field.dart';
import 'package:astech_demo/customs/custom_radio_group_button_field.dart';
import 'package:astech_demo/customs/custom_text_field.dart';
import 'package:astech_demo/customs/custom_switch_field.dart';
import 'package:astech_demo/commons/formatter.dart';
import 'package:astech_demo/widgets/bottom_navigation_form.dart';
import 'package:astech_demo/widgets/required_foot_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CalibrationSubmissionForm extends StatefulWidget {
  const CalibrationSubmissionForm({super.key});

  @override
  State<CalibrationSubmissionForm> createState() =>
      _CalibrationSubmissionFormState();
}

class _CalibrationSubmissionFormState extends State<CalibrationSubmissionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // form field state
  FormBuilderState? get formFieldState => _formKey.currentState;

  // form fields
  late final String contactMethodFieldName = 'contactMethod';

  // form fields key
  late final GlobalKey<FormBuilderFieldState> contactMethodFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: contactMethodFieldName);

  // focus
  late final FocusNode contactMethodFocus =
      FocusNode(debugLabel: contactMethodFieldName);
  late final FocusNode cancelBtnFocus = FocusNode(debugLabel: 'cancel');
  late final FocusNode submitBtnFocus = FocusNode(debugLabel: 'submit');

  // AccountType
  late final String accountType;

  @override
  void initState() {
    accountType = 'safelite';

    // pre-populate data
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // init data
        // _formKey.currentState?.patchValue({
        // roField.name: '',
        // odometerField.name: '',
        // unitFieldName: DistanceUnit.miles,
        // warningLightFieldName: false,
        // });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    contactMethodFocus.dispose();
    cancelBtnFocus.dispose();
    submitBtnFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      extendBody: true,
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
            /// Header with Vehicle Information
            Container(
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: kElevationToShadow[2],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('form isValid: ${formFieldState?.isValid}'),
                    Text('fieldsValues: ${formFieldState?.value}'),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
              child: Text(
                'Vehicle Information',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            FormBuilder(
              key: _formKey,
              onChanged: () {
                formFieldState!.save();
                if (mounted) {
                  setState(() {});
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Preferred Contact Method Input
                    CustomDropdownGroupField<String>(
                      fieldKey: contactMethodFieldKey,
                      name: contactMethodFieldName,
                      labelText: 'Preferred contact method?',
                      required: true,
                      focusNode: contactMethodFocus,
                      items: const [
                        DropdownGroupItem<String>(value: 'chat', title: 'Chat'),
                        DropdownGroupItem<String>(
                            value: 'phone', title: 'Phone'),
                        DropdownGroupItem<String>(value: 'text', title: 'Text'),
                      ],
                      onChanged: (_) => node.requestFocus(submitBtnFocus),
                    ),
                    const SizedBox(height: 24),

                    /// Required note
                    const RequiredFootNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// Buttons
      bottomNavigationBar: BottomNavigationForm(
        primaryFocusNode: cancelBtnFocus,
        secondaryFocusNode: submitBtnFocus,
        onPrimaryPressed: () {
          node.unfocus();
          Navigator.pop(context);
        },
        onSecondaryPressed: formFieldState?.isValid == true
            ? () {
                node.unfocus();
                Navigator.pop(context);
              }
            : null,
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
    if (accountType == 'safelite')
      // + 1 character (-)
      FormBuilderValidators.equalLength(12,
          errorText: 'Value must have a length equal to 11'),
  ]);

  late TextInputType roKeyboardType =
      accountType == 'belron' || accountType == 'safelite'
          ? TextInputType.number
          : TextInputType.visiblePassword;
}
