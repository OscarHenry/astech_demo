import 'package:astech_demo/commons/formatter.dart';
import 'package:astech_demo/widgets/field_label_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:astech_demo/commons/extensions.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CustomPhoneNumberField extends StatefulWidget {
  const CustomPhoneNumberField({
    super.key,
    this.fieldKey,
    required this.name,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.required = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.focusNode,
    this.hintText,
    this.helpText = 'Area code +7 digit #',
    this.initialRegionInfo,
    required this.countries,
    this.controller,
    this.maxLength,
    this.counterVisibility = true,
    this.autofocus = true,
    this.onEditingComplete,
    this.onSaved,
    this.onSubmitted,
    this.onReset,
    this.style,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLengthEnforcement,
    this.keyboardType = TextInputType.phone,
    this.textInputAction,
    this.maxLines = 1,
    this.capitalization,
    this.buildCounter,
    this.textCapitalization = TextCapitalization.none,
    this.textAlignVertical,
  });

  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final String name;
  final String labelText;
  final String? initialValue;
  final RegionInfo? initialRegionInfo;
  final List<RegionInfo> countries;
  final String? hintText;
  final String? helpText;
  final bool required;
  final AutovalidateMode autovalidateMode;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final int? maxLength;
  final bool counterVisibility;
  final bool autofocus;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String?>? onSubmitted;
  final VoidCallback? onReset;
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

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  bool get hasError => widget.fieldKey?.currentState?.hasError == true;

  bool get isTouched => widget.fieldKey?.currentState?.isTouched == true;

  bool get isValid => widget.fieldKey?.currentState?.isValid == true;

  bool get isEmpty =>
      (widget.fieldKey?.currentState?.value as String?)?.isEmpty != false;

  bool get isRequiredError => isEmpty && widget.required;

  bool get isFocused => widget.focusNode?.hasPrimaryFocus == true;

  late RegionInfo _selectedCountryCode =
      widget.initialRegionInfo ?? widget.countries.first;

  @override
  void initState() {
    _listenOnFocusChange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(color: Colors.black);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: FieldLabelText(
            labelText: widget.labelText,
            labelTextStyle: labelStyle,
            required: widget.required,
          ),
        ),
        const SizedBox(width: 24),
        Flexible(
          fit: FlexFit.tight,
          child: buildCountryCodeField(),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: FormBuilderTextField(
            key: widget.fieldKey,
            name: widget.name,
            controller: widget.controller,
            autovalidateMode: widget.autovalidateMode,
            validator: buildValidator(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              hintText: widget.hintText,
              counterText: widget.counterVisibility ? null : '',
              helperText: widget.helpText,
              helperStyle: TextStyle(color: helperColor),
              errorStyle: TextStyle(color: errorColor),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: errorBorderColor, width: 2),
              ),
              suffixIcon: isEmpty
                  ? null
                  : CloseButton(
                      onPressed: () => widget.fieldKey?.currentState?.reset(),
                      color: Colors.black,
                    ),
            ),
            inputFormatters: inputFormatters,
            style: widget.style,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onEditingComplete,
            onSaved: widget.onSaved,
            onSubmitted: widget.onSubmitted,
            onReset: widget.onReset,
            buildCounter: widget.buildCounter,
            textCapitalization: widget.textCapitalization,
            textAlignVertical: widget.textAlignVertical,
          ),
        ),
      ],
    );
  }

  Widget buildCountryCodeField() {
    TextStyle titleItemStyle = const TextStyle(color: Colors.black);
    InputDecoration countryCodeInputDecorator = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      errorText: hasError ? '' : null,
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: errorBorderColor, width: 2),
      ),
    );
    return DropdownButtonFormField<RegionInfo>(
      value: _selectedCountryCode,
      isExpanded: false,
      decoration: countryCodeInputDecorator,
      style: titleItemStyle,
      items: widget.countries
          .map<DropdownMenuItem<RegionInfo>>(
            (e) => DropdownMenuItem<RegionInfo>(
              value: e,
              child: Text(e.code),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() {
        _selectedCountryCode = value!;
        FocusScope.of(context).nextFocus();
        widget.fieldKey?.currentState?.reset();
        debugPrint('_selectedCountryCode: $_selectedCountryCode');
        debugPrint(
            'inputFormatters: ${inputFormatters.map((e) => (e as MaskTextInputFormatter).getMask())}');
      }),
    );
  }

  /// error here
  List<TextInputFormatter> get inputFormatters => [
        if (_selectedCountryCode.code == 'US')
          CustomFormatter.usPhoneFormatter(),
        if (_selectedCountryCode.code == 'CAD')
          CustomFormatter.cadPhoneFormatter(),
        if (_selectedCountryCode.code == 'MX')
          CustomFormatter.mxPhoneFormatter(),
      ];

  void _listenOnFocusChange() {
    widget.focusNode?.addListener(() {
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
      if (widget.required)
        FormBuilderValidators.required(errorText: widget.helpText ?? ''),
      XFormBuilderValidators.phoneNumber(
        regionInfo: _selectedCountryCode,
        errorText: widget.helpText,
      ),
    ]);
  }
}
