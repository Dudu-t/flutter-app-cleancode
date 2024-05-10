import 'dart:async';

import 'package:faker/faker.dart';
import 'package:fordevs/presentation/presenters/presenters.dart';
import 'package:fordevs/presentation/protocols/protocols.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Validation>()])
import 'stream_login_presenter_test.mocks.dart';

void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late String email;

  PostExpectation mockValidationCall(String? field) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = MockValidation();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });
  test('Should call validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream?.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));

    expectLater(sut.emailErrorStream, emits('error'));
    sut.validateEmail(email);
    sut.validateEmail(email);
  });
}
