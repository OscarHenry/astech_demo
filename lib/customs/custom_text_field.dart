import 'package:astech_demo/widgets/field_label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.fieldKey,
    required this.name,
    this.labelText,
    this.hintText,
    this.helpText,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.required = false,
    this.validator,
    this.maxLength,
    this.counterVisibility = true,
    this.controller,
    this.autofocus = true,
    this.focusNode,
    this.onChanged,
    this.onEditingComplete,
    this.onSaved,
    this.onSubmitted,
    this.onReset,
    this.inputFormatters,
    this.style,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLengthEnforcement,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.capitalization,
    this.buildCounter,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
  });

  final GlobalKey<FormBuilderFieldState<FormBuilderField<String>, String>>?
      fieldKey;
  final String name;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helpText;
  final AutovalidateMode autovalidateMode;
  final bool required;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final bool counterVisibility;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String?>? onSubmitted;
  final VoidCallback? onReset;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? capitalization;
  final InputCounterWidgetBuilder? buildCounter;
  final TextCapitalization textCapitalization;
  final TextAlignVertical? textAlignVertical;

  bool get hasError => fieldKey?.currentState?.hasError == true;
  bool get isTouched => fieldKey?.currentState?.isTouched == true;
  bool get isValid => fieldKey?.currentState?.isValid == true;
  bool get isRequiredError =>
      (fieldKey?.currentState?.value)?.isEmpty == true && required;
  bool get isFocused => focusNode?.hasPrimaryFocus == true;

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(color: Colors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          FieldLabelText(
              labelText: labelText,
              labelTextStyle: labelStyle,
              required: required),
        const SizedBox(height: 4),
        StatefulBuilder(
          builder: (_, setState) {
            _listenOnFocusChange(setState);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  key: fieldKey,
                  name: name,
                  controller: controller,
                  autovalidateMode: autovalidateMode,
                  validator: buildValidator(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: hintText,
                    counterText: counterVisibility ? null : '',
                    errorStyle: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 0,
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: errorBorderColor, width: 2),
                    ),
                  ),
                  inputFormatters: inputFormatters,
                  style: style,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  maxLengthEnforcement: maxLengthEnforcement,
                  obscureText: obscureText,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  onChanged: onChanged,
                  textInputAction: textInputAction,
                  onEditingComplete: onEditingComplete,
                  onSaved: onSaved,
                  onSubmitted: onSubmitted,
                  onReset: onReset,
                  buildCounter: buildCounter,
                  textCapitalization: textCapitalization,
                  textAlignVertical: textAlignVertical,
                ),
                const SizedBox(height: 4),
                if (helpText != null) ...[
                  Text(
                    helpText!,
                    style: TextStyle(color: helperColor),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  void _listenOnFocusChange(StateSetter setState) {
    focusNode?.addListener(() {
      // debugPrint('onFocusChange[$name]: $_helperColor');
      setState(() {});
    });
  }

  Color get helperColor {
    Color helperColor = Colors.black;

    if (hasError && !isFocused) {
      helperColor = Colors.red;
    }

    if (isFocused) {
      if (isRequiredError) {
        helperColor = Colors.black;
      } else {
        helperColor = Colors.blue;
      }
    }

    // debugPrint('getHelperColor[$name]: $_helperColor');
    return helperColor;
  }

  Color get errorBorderColor {
    Color errorColor = Colors.red;

    if (isFocused) {
      errorColor = Colors.blueAccent;
    }

    // debugPrint('getErrorColor[$name]: $_errorColor');
    return errorColor;
  }

  FormFieldValidator<String>? buildValidator() {
    return FormBuilderValidators.compose<String>([
      if (required)
        FormBuilderValidators.required<String>(errorText: helpText ?? ''),
      if (validator != null) validator!,
    ]);
  }
}
