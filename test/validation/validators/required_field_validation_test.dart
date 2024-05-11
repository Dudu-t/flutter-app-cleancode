import 'package:fordevs/validation/validators/required_field_validation.dart';
import 'package:test/test.dart';

void main() {
  late RequiredFieldValidation sut;
  setUp(() {
    sut = RequiredFieldValidation(field: 'any_field');
  });
  test('Should return null if value is not empty', () {
    expect(sut.validate('any_value'), null);
  });
  test('Should return error if value is empty', () {
    expect(sut.validate(''), 'Campo obrigatório');
  });
}
