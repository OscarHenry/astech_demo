import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:phone_number/phone_number.dart'
    hide PhoneNumber, PhoneNumberType;
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

extension XList<T> on List<T> {
  int indexWhereOrElse(bool Function(T element) test,
      {int Function()? orElse}) {
    final index = indexWhere(test);
    if (index >= 0) {
      return index;
    } else {
      return orElse?.call() ?? index;
    }
  }
}

extension XFormBuilderValidators on FormBuilderValidators {
  static FormFieldValidator<T> phoneNumber<T>({
    required RegionInfo regionInfo,
    String? errorText,
  }) =>
      (value) {
        value as String?;
        // Null or empty string
        if (value == null || value.toString().isEmpty) return null;
        PhoneNumber phone = PhoneNumber.parse(value);
        if (((regionInfo.code == 'US' || regionInfo.code == 'CAD') &&
            phone.nsn.length == 10)) {
          return null;
        } else if (regionInfo.code == 'MX' && phone.nsn.length == 9) {
          return null;
        } else {
          return errorText ?? 'Phone number is invalid';
        }
      };
}
