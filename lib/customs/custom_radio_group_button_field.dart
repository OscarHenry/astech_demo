import 'package:astech_demo/widgets/field_label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

const List<RadioGroupItem<bool>> binarySelection = [
  RadioGroupItem<bool>(value: true, title: 'Yes'),
  RadioGroupItem<bool>(value: false, title: 'No')
];

class RadioGroupItem<T> {
  const RadioGroupItem({
    required this.value,
    required this.title,
  });

  final T value;
  final String title;
}

class CustomRadioGroupField<T> extends StatelessWidget {
  const CustomRadioGroupField({
    Key? key,
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
    this.helpText,
  }) : super(key: key);

  const CustomRadioGroupField.binary({
    super.key,
    this.fieldKey,
    required this.name,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.required = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.helpText,
  }) : items = binarySelection as List<RadioGroupItem<T>>;

  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final String name;
  final String labelText;
  final String? helpText;
  final List<RadioGroupItem<T>> items;
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
      (fieldKey?.currentState?.value)?.isEmpty == true && required;
  bool get isFocused => focusNode?.hasPrimaryFocus == true;

  @override
  Widget build(BuildContext context) {
    Color activeColor = Colors.black;
    TextStyle labelStyle = const TextStyle(color: Colors.black);
    TextStyle titleItemStyle = const TextStyle(color: Colors.black);
    return FormBuilderField<T>(
      key: fieldKey,
      name: name,
      validator: _buildValidator(),
      autovalidateMode: autovalidateMode,
      initialValue: initialValue,
      focusNode: focusNode,
      builder: (FormFieldState<T> field) {
        return Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FieldLabelText(
                      labelText: labelText,
                      labelTextStyle: labelStyle,
                      required: required),
                  const SizedBox(height: 4),
                  if (helpText != null) ...[
                    Text(
                      helpText!,
                      style: TextStyle(color: helperColor),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items
                    .map(
                      (e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio<T>(
                            value: e.value,
                            groupValue: field.value,
                            activeColor: activeColor,
                            onChanged: (value) => field.didChange(value),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(
                            e.title,
                            style: titleItemStyle,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
      onChanged: onChanged,
    );
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
