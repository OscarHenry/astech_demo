import 'package:astech_demo/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SwitchItem<T> {
  const SwitchItem({
    required this.title,
    required this.value,
  });
  final String title;
  final T value;

  @override
  String toString() => 'SwitchItem {title: $title}';
}

class CustomSwitchField<T> extends StatelessWidget {
  const CustomSwitchField({
    super.key,
    this.fieldKey,
    required this.name,
    this.required = false,
    this.initialValue,
    this.onChanged,
    this.backgroundColor,
    this.backgroundIndicatorColor,
    required this.items,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
  });
  final GlobalKey<FormBuilderFieldState>? fieldKey;
  final String name;
  final bool required;
  final T? initialValue;
  final ValueChanged<SwitchItem<T>?>? onChanged;
  final Color? backgroundColor;
  final Color? backgroundIndicatorColor;
  final List<SwitchItem<T>> items;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    // assert(items.length < 2, 'haaaaa');
    return FormBuilderField<T>(
      key: fieldKey,
      name: name,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      validator: validator,
      initialValue: initialValue,
      onChanged: (value) => onChanged?.call(
        items.firstWhere((element) => element.value == value),
      ),
      builder: (field) {
        final hasError = field.hasError;
        final errorText = field.errorText;
        final backgroundC =
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
        final backgroundIndicatorC = hasError
            ? Colors.red
            : backgroundIndicatorColor ?? Theme.of(context).primaryColor;

        final initValue = initialValue ?? field.value;

        final initIndex = items.indexWhereOrElse(
          (element) => element.value == initValue,
          orElse: () => 0,
        );

        return DefaultTabController(
          length: items.length,
          initialIndex: initIndex,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: backgroundC,
              boxShadow: kElevationToShadow[2],
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 2,
                color: backgroundIndicatorC,
              ),
            ),
            child: TabBar(
              padding: EdgeInsets.zero,
              automaticIndicatorColorAdjustment: true,
              splashBorderRadius: BorderRadius.circular(50),
              indicatorWeight: 0,
              indicatorPadding: const EdgeInsets.all(4.0),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: backgroundIndicatorC,
                boxShadow: kElevationToShadow[2],
              ),
              labelColor: Colors.white,
              onTap: (index) => field.didChange(items.elementAt(index).value),
              tabs: List.generate(
                items.length,
                (index) => Tab(
                  text: items.elementAt(index).title,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  FormFieldValidator<T>? buildValidator() {
    return FormBuilderValidators.compose([
      if (required) FormBuilderValidators.required(),
      if (validator != null) validator!,
    ]);
  }
}
