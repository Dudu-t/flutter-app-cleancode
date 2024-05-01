import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordevs/datalayer/http/http.dart';
import 'package:fordevs/datalayer/usecases/usecases.dart';
import 'package:fordevs/domain/usecases/usecases.dart';
import 'package:fordevs/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthencationParams params;
  late String accessToken;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );

    params = AuthencationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    accessToken = faker.guid.guid();
  });

  test('Should call HttpCLient with correct URL', () async {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    await sut.auth(params);

    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {
          'email': params.email,
          'password': params.password,
        },
      ),
    );
  });
  test('Should throw UnexpectedError if HttpClient return 400', () {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.badRequest);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.notFound);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.serverError);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });
  test('Should throw InvalidCredentials if HttpClient return 401', () {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.unauthorized);

    expect(() => sut.auth(params), throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.serverError);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });
  test('Should return an Account if HttpClient return 200', () async {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });
}
