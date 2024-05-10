import 'dart:async';

import 'package:faker/faker.dart';
import 'package:fordevs/domain/entities/account_entitty.dart';
import 'package:fordevs/domain/usecases/usecases.dart';
import 'package:fordevs/presentation/presenters/presenters.dart';
import 'package:fordevs/presentation/protocols/protocols.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Validation>(), MockSpec<Authentication>()])
import 'stream_login_presenter_test.mocks.dart';

void main() {
  late StreamLoginPresenter sut;
  late MockValidation validation;
  late MockAuthentication authentication;
  late String email;
  late String password;

  PostExpectation mockValidationCall(String? field) => when(
        validation.validate(
          field: field ?? anyNamed('field'),
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() => mockAuthenticationCall()
      .thenAnswer((_) async => AccountEntity(faker.guid.guid()));

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    sut = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );
    email = faker.internet.email();
    password = faker.internet.password();
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

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should email null if validation succeds', () {
    sut.emailErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validatation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream?.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });
  test('Should password error if validation success', () {
    sut.passwordErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should password error if validation success', () {
    sut.emailErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.passwordErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream?.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));

    sut.passwordErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.isFormValidStream?.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () async {
    sut.emailErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    sut.passwordErrorStream?.listen(expectAsync1(
      (error) => expect(error, null),
    ));

    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call Authenticaiton with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(authentication
            .auth(AuthencationParams(email: email, password: password)))
        .called(1);
  });

  test('Should emit correct events on Authentication success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });
}
