import 'package:flutter/material.dart';

class FieldLabelText extends StatelessWidget {
  const FieldLabelText({
    super.key,
    required this.labelText,
    this.labelTextStyle,
    this.required = false,
  });

  final String? labelText;
  final TextStyle? labelTextStyle;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
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
    );
  }
}
