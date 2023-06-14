import 'package:flutter/material.dart';

enum BottomNavigationStyle { outlined, elevated }

class BottomNavigationForm extends StatelessWidget {
  final bool hasSimple;
  final String primaryLabelText;
  final String? secondaryLabelText;
  final FocusNode? primaryFocusNode;
  final FocusNode? secondaryFocusNode;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final BottomNavigationStyle primaryStyle;
  final BottomNavigationStyle? secondaryStyle;
  const BottomNavigationForm({
    super.key,
    this.primaryFocusNode,
    this.secondaryFocusNode,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.primaryLabelText = 'Cancel',
    this.secondaryLabelText = 'Submit',
    this.primaryStyle = BottomNavigationStyle.outlined,
    this.secondaryStyle = BottomNavigationStyle.elevated,
  }) : hasSimple = false;

  const BottomNavigationForm.simple({
    super.key,
    this.primaryFocusNode,
    this.onPrimaryPressed,
    this.primaryLabelText = 'Cancel',
    this.primaryStyle = BottomNavigationStyle.outlined,
  })  : hasSimple = true,
        secondaryLabelText = null,
        secondaryFocusNode = null,
        onSecondaryPressed = null,
        secondaryStyle = null;

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (hasSimple) {
      child = buildButton(
        style: primaryStyle,
        focusNode: primaryFocusNode,
        onPressed: onPrimaryPressed,
        labelText: primaryLabelText,
      );
    } else {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildButton(
            style: primaryStyle,
            focusNode: primaryFocusNode,
            onPressed: onPrimaryPressed,
            labelText: primaryLabelText,
          ),
          const SizedBox(width: 32),
          buildButton(
            style: secondaryStyle!,
            focusNode: secondaryFocusNode,
            onPressed: onSecondaryPressed,
            labelText: secondaryLabelText!,
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: buildBoxDecorationWithGradient(),
      child: child,
    );
  }

  BoxDecoration buildBoxDecorationWithGradient() {
    return const BoxDecoration(
      color: Colors.white,
      gradient: LinearGradient(
        stops: [0.0, 0.3],
        colors: [
          Colors.white10,
          Colors.white,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.decal,
      ),
    );
  }

  Widget buildButton({
    required BottomNavigationStyle style,
    bool autofocus = true,
    FocusNode? focusNode,
    VoidCallback? onPressed,
    required String labelText,
  }) {
    switch (style) {
      case BottomNavigationStyle.elevated:
        return ElevatedButton(
          autofocus: autofocus,
          focusNode: focusNode,
          onPressed: onPressed,
          child: Text(labelText),
        );
      case BottomNavigationStyle.outlined:
        return OutlinedButton(
          autofocus: autofocus,
          focusNode: focusNode,
          onPressed: onPressed,
          child: Text(labelText),
        );
    }
  }
}
