import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Field<T> {
  final GlobalKey<FormBuilderFieldState> key;
  final String name;
  final FocusNode focusNode;
  bool required;
  String? labelText;
  String? helperText;
  String? hintText;
  List<TextInputFormatter>? inputFormatters;
  FormFieldValidator<String>? validator;
  Field({
    GlobalKey<FormBuilderFieldState>? key,
    required this.name,
    this.required = false,
    FocusNode? focusNode,
    this.labelText,
    this.helperText,
    this.hintText,
    this.validator,
    this.inputFormatters,
  })  : key = key ?? GlobalKey<FormBuilderFieldState>(),
        focusNode = FocusNode(debugLabel: name);

  dispose() {
    focusNode.dispose();
  }

  bool get isValid => key.currentState?.isValid == true;
}
