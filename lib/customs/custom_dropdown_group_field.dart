import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DropdownGroupItem<T> {
  const DropdownGroupItem({required this.title, required this.value});

  final String title;
  final T value;
}

class CustomDropdownGroupField<T> extends StatelessWidget {
  const CustomDropdownGroupField({
    super.key,
    this.fieldKey,
    required this.name,
    required this.labelText,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.required = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.hintText,
    this.helpText,
  });

  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final String name;
  final String labelText;
  final String? hintText;
  final String? helpText;
  final List<DropdownGroupItem<T>> items;
  final T? initialValue;
  final Function(T? value)? onChanged;
  final bool required;
  final AutovalidateMode autovalidateMode;
  final FocusNode? focusNode;
  final FormFieldValidator<T>? validator;

  bool get hasError => fieldKey?.currentState?.hasError == true;
  bool get isTouched => fieldKey?.currentState?.isTouched == true;
  bool get isValid => fieldKey?.currentState?.isValid == true;
  bool get isRequiredError =>
      (fieldKey?.currentState?.value as String?)?.isEmpty == true && required;
  bool get isFocused => focusNode?.hasPrimaryFocus == true;

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(color: Colors.black);
    TextStyle titleItemStyle = const TextStyle(color: Colors.black);
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text.rich(
            TextSpan(
              text: labelText,
              style: labelStyle,
              children: [
                if (required)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.redAccent),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: FormBuilderField<T>(
            key: fieldKey,
            name: name,
            initialValue: initialValue,
            focusNode: focusNode,
            validator: _buildValidator(),
            autovalidateMode: autovalidateMode,
            onChanged: onChanged,
            builder: (field) {
              return DropdownButtonFormField<T>(
                value: field.value,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: hintText,
                  helperText: helpText,
                  helperStyle: TextStyle(color: helperColor),
                  errorStyle: TextStyle(color: errorColor),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: errorBorderColor, width: 2),
                  ),
                ),
                style: titleItemStyle,
                items: items
                    .map<DropdownMenuItem<T>>(
                      (e) => DropdownMenuItem<T>(
                        value: e.value,
                        child: Text(e.title),
                      ),
                    )
                    .toList(),
                onChanged: (value) => field.didChange(value),
              );
            },
          ),
        ),
      ],
    );
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

  FormFieldValidator<T>? _buildValidator() {
    if (required) {
      return FormBuilderValidators.compose<T>([
        FormBuilderValidators.required(),
        if (validator != null) validator!,
      ]);
    }

    return validator;
  }
}
