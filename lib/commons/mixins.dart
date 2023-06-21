import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

mixin FormMixin {
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
  late final GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>
      roFieldKey =
      GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>(
          debugLabel: roFieldName);
  late final GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>
      odometerFieldKey =
      GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>(
          debugLabel: odometerFieldName);
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
}
