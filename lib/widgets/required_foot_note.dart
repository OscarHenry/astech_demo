import 'package:flutter/material.dart';

class RequiredFootNote extends StatelessWidget {
  const RequiredFootNote({
    super.key,
    this.isVisible = true,
    this.notation = '*',
    this.description = 'Required',
  });
  final bool isVisible;
  final String notation;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: notation,
        style: const TextStyle(color: Colors.red),
        children: [
          TextSpan(
            text: ' $description',
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
