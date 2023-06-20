import 'package:astech_demo/commons/distance_unit.dart';
import 'package:astech_demo/customs/custom_dropdown_group_field.dart';
import 'package:astech_demo/customs/custom_phone_number_field.dart';
import 'package:astech_demo/customs/custom_radio_group_button_field.dart';
import 'package:astech_demo/customs/custom_text_field.dart';
import 'package:astech_demo/customs/custom_switch_field.dart';
import 'package:astech_demo/commons/formatter.dart';
import 'package:astech_demo/widgets/bottom_navigation_form.dart';
import 'package:astech_demo/widgets/required_foot_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:phone_number/phone_number.dart';

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
  late final String roFieldName = 'ro';
  late final String odometerFieldName = 'odometer';
  late final String unitFieldName = 'unit';
  late final String warningLightFieldName = 'warningLight';
  late final String srsDeployedFieldName = 'srsDeployed';
  late final String drivableFieldName = 'drivable';
  late final String contactMethodFieldName = 'contactMethod';
  late final String notesFieldName = 'notes';
  late final String phoneFieldName = 'phone';

  // form fields key
  late final GlobalKey<FormBuilderFieldState> roFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: roFieldName);
  late final GlobalKey<FormBuilderFieldState> odometerFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: odometerFieldName);
  late final GlobalKey<FormBuilderFieldState> unitFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: unitFieldName);
  late final GlobalKey<FormBuilderFieldState> warningLightFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: warningLightFieldName);
  late final GlobalKey<FormBuilderFieldState> srsDeployedFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: srsDeployedFieldName);
  late final GlobalKey<FormBuilderFieldState> drivableFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: drivableFieldName);
  late final GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>
      contactMethodFieldKey =
      GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>(
          debugLabel: contactMethodFieldName);
  late final GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>
      notesFieldKey =
      GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>(
          debugLabel: notesFieldName);
  late final GlobalKey<FormBuilderFieldState> phoneFieldKey =
      GlobalKey<FormBuilderFieldState>(debugLabel: phoneFieldName);

  // focus
  late final FocusNode roFocus = FocusNode(debugLabel: roFieldName);
  late final FocusNode odometerFocus = FocusNode(debugLabel: odometerFieldName);
  late final FocusNode unitFocus = FocusNode(debugLabel: unitFieldName);
  late final FocusNode warningLightFocus =
      FocusNode(debugLabel: warningLightFieldName);
  late final FocusNode srsDeployedFocus =
      FocusNode(debugLabel: srsDeployedFieldName);
  late final FocusNode drivableFocus = FocusNode(debugLabel: drivableFieldName);
  late final FocusNode contactMethodFocus =
      FocusNode(debugLabel: contactMethodFieldName);
  late final FocusNode notesFocus = FocusNode(debugLabel: notesFieldName);
  late final FocusNode phoneFocus = FocusNode(debugLabel: phoneFieldName);
  late final FocusNode cancelBtnFocus = FocusNode(debugLabel: 'cancel');
  late final FocusNode submitBtnFocus = FocusNode(debugLabel: 'submit');

  // AccountType
  late final String accountType;

  @override
  void initState() {
    accountType = 'safelite';

    // pre-populate data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // init data
      _formKey.currentState?.patchValue({
        // roField.name: '',
        // odometerField.name: '',
        unitFieldName: DistanceUnit.miles,
        // warningLightFieldName: false,
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    roFocus.dispose();
    odometerFocus.dispose();
    unitFocus.dispose();
    warningLightFocus.dispose();
    srsDeployedFocus.dispose();
    drivableFocus.dispose();
    contactMethodFocus.dispose();
    notesFocus.dispose();
    phoneFocus.dispose();
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
        padding: const EdgeInsets.only(bottom: 72),
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
                    /// Ro/Job ID Input
                    CustomTextField(
                      fieldKey: roFieldKey,
                      name: roFieldName,
                      required: true,
                      labelText: roLabelText,
                      hintText: roHintText,
                      helpText: roHelperText,
                      maxLength: 32,
                      counterVisibility: false,
                      inputFormatters: roInputFormatters,
                      onEditingComplete: () => node.requestFocus(odometerFocus),
                      focusNode: roFocus,
                      validator: roValidator,
                      textInputAction: TextInputAction.next,
                      keyboardType: roKeyboardType,
                    ),
                    const SizedBox(height: 18),

                    /// Odometer
                    Row(
                      children: [
                        /// Odometer Input
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
                            onEditingComplete: () =>
                                node.requestFocus(warningLightFocus),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),

                        /// Unit Selector
                        Expanded(
                          child: CustomSwitchField<DistanceUnit>(
                            fieldKey: unitFieldKey,
                            name: unitFieldName,
                            required: true,
                            items: DistanceUnit.values
                                .map(
                                  (e) =>
                                      SwitchItem(title: e.shortName, value: e),
                                )
                                .toList(),
                            onChanged: (_) =>
                                node.requestFocus(warningLightFocus),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    /// Warning Light Input
                    CustomRadioGroupField<bool>.binary(
                      fieldKey: warningLightFieldKey,
                      name: warningLightFieldName,
                      labelText: 'Warning Light?',
                      required: true,
                      focusNode: warningLightFocus,
                      onChanged: (_) => node.requestFocus(srsDeployedFocus),
                    ),
                    const SizedBox(height: 18),

                    /// SRS Deployed Input
                    CustomRadioGroupField<bool>.binary(
                      fieldKey: srsDeployedFieldKey,
                      name: srsDeployedFieldName,
                      labelText: 'SRS Deployed?',
                      required: true,
                      focusNode: srsDeployedFocus,
                      onChanged: (_) => node.requestFocus(drivableFocus),
                    ),
                    const SizedBox(height: 18),

                    /// Drivable Input
                    CustomRadioGroupField<bool>.binary(
                      fieldKey: drivableFieldKey,
                      name: drivableFieldName,
                      labelText: 'Drivable?',
                      required: true,
                      focusNode: drivableFocus,
                      onChanged: (_) => node.requestFocus(contactMethodFocus),
                    ),
                    const SizedBox(height: 18),

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

                    if (contactMethodFieldKey.currentState?.value ==
                        'text') ...[
                      const SizedBox(height: 18),
                      CustomPhoneNumberField(
                        fieldKey: phoneFieldKey,
                        name: phoneFieldName,
                        focusNode: phoneFocus,
                        labelText: 'Phone',
                        required: true,
                        regions: const [
                          RegionInfo(
                            name: 'United State',
                            code: 'US',
                            prefix: 1,
                          ),
                          RegionInfo(
                            name: 'Canada',
                            code: 'CAD',
                            prefix: 1,
                          ),
                          RegionInfo(
                            name: 'Mexico',
                            code: 'MX',
                            prefix: 52,
                          )
                        ],
                      ),
                    ],

                    const SizedBox(height: 18),

                    /// Notes Input
                    CustomTextField(
                      fieldKey: notesFieldKey,
                      name: notesFieldName,
                      labelText: 'Notes',
                      onEditingComplete: () =>
                          node.requestFocus(submitBtnFocus),
                      focusNode: notesFocus,
                      validator: FormBuilderValidators.maxLength(noteMaxLength),
                      maxLength: noteMaxLength,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      textAlignVertical: TextAlignVertical.top,
                      buildCounter: _buildCounter,
                      maxLines: null,
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
    var helperText = 'Value must have a length less than to 32';
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

  int get noteMaxLength =>
      (contactMethodFieldKey.currentState?.value == 'phone')
          ? 1000 - preferredLanguage.length
          : 1000;

  Widget? _buildCounter(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    int dif = noteMaxLength - currentLength;
    return Text(
      '$currentLength / $noteMaxLength',
      style: TextStyle(
        color: dif.isNegative ? Colors.red : Colors.black,
      ),
    );
  }
}

String get preferredLanguage => 'Preferred Language = English\n\n';
