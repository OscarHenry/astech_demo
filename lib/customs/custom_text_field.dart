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

  bool get hasError => fieldKey?.currentState?.hasError == true;
  bool get isTouched => fieldKey?.currentState?.isTouched == true;
  bool get isValid => fieldKey?.currentState?.isValid == true;
  bool get isRequiredError => fieldKey?.currentState?.errorText == 'required';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          builder: (context, setState) => Focus(
            onFocusChange: (isFocused) {
              setState(() {});
            },
            child: FormBuilderTextField(
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
                helperStyle: TextStyle(
                  color: helperColor,
                ),
                errorText: isRequiredError ? helpText : null,
                errorStyle: TextStyle(
                  color: errorColor,
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
              onEditingComplete: onEditingComplete,
              onSaved: onSaved,
              onSubmitted: onSubmitted,
              onReset: onReset,
            ),
          ),
        ),
      ],
    );
  }

  Color get helperColor {
    if (focusNode?.hasPrimaryFocus == true && !hasError) return Colors.blue;
    // if (hasError) return Colors.red;
    return Colors.black;
  }

  Color get errorColor {
    if (isRequiredError) return Colors.black;
    return Colors.red;
  }

  FormFieldValidator<String>? buildValidator() {
    return FormBuilderValidators.compose([
      if (required) FormBuilderValidators.required(errorText: 'required'),
      if (validator != null) validator!,
    ]);
  }
}
