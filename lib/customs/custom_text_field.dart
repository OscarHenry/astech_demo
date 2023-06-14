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
    this.hideCounter = false,
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
  });

  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final String name;
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helpText;
  final AutovalidateMode autovalidateMode;
  final bool required;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final bool hideCounter;
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

  bool get hasError => fieldKey?.currentState?.hasError == true;
  bool get isTouched => fieldKey?.currentState?.isTouched == true;
  bool get isValid => fieldKey?.currentState?.isValid == true;
  bool get isRequiredError =>
      (fieldKey?.currentState?.value as String?)?.isEmpty == true && required;
  bool get isFocused => focusNode?.hasPrimaryFocus == true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Text.rich(
            TextSpan(
              text: labelText,
              style: const TextStyle(color: Colors.black),
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        StatefulBuilder(
          builder: (_, setState) {
            _listenOnFocusChange(setState);
            return FormBuilderTextField(
              key: fieldKey,
              name: name,
              controller: controller,
              autovalidateMode: autovalidateMode,
              validator: buildValidator(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: hintText,
                counterText: hideCounter ? '' : null,
                helperText: helpText,
                helperStyle: TextStyle(color: helperColor),
                errorStyle: TextStyle(color: errorColor),
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
              maxLength: maxLength,
              focusNode: focusNode,
              autofocus: autofocus,
              onChanged: onChanged,
              textInputAction: textInputAction,
              onEditingComplete: onEditingComplete,
              onSaved: onSaved,
              onSubmitted: onSubmitted,
              onReset: onReset,
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

    if (hasError == true && isRequiredError) {
      helperColor = Colors.black;
    }

    if (isFocused && !hasError) {
      helperColor = Colors.blue;
    }

    // debugPrint('getHelperColor[$name]: $_helperColor');
    return helperColor;
  }

  Color get errorColor {
    Color errorColor = Colors.red;

    if (isFocused) {
      if (isRequiredError) {
        errorColor = Colors.black;
      } else {
        errorColor = Colors.blue;
      }
    }

    // debugPrint('getErrorColor[$name]: $_errorColor');
    return errorColor;
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
    return FormBuilderValidators.compose([
      if (required) FormBuilderValidators.required(errorText: helpText ?? ''),
      if (validator != null) validator!,
    ]);
  }
}
