import 'dart:math';

import 'package:fordevs/validation/protocols/field_validation.dart';
import 'package:test/test.dart';

void main() {
  late EmailValidation sut;
  setUp(() {
    sut = EmailValidation(field: 'any_field');
  });
  test('Should return null if email is empty', () {
    expect(sut.validate(''), null);
  });
  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('xxxxx@gmail.com'), null);
  });
}

class EmailValidation implements FieldValidation {
  final String field;

  EmailValidation({required this.field});

  @override
  String? validate(String? value) {
    return null;
  }
}
