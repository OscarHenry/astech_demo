import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomFormatter {
  static MaskTextInputFormatter belronFormatter() {
    // formatter for 14 digits numeric input
    const String belronTextMask = '##############';
    return MaskTextInputFormatter(mask: belronTextMask);
  }

  static MaskTextInputFormatter safeliteFormatter() {
    // formatter for 11 digits numeric input grouped by a dash
    const String safeliteTextMask = '#####-######';
    return MaskTextInputFormatter(mask: safeliteTextMask);
  }
}
