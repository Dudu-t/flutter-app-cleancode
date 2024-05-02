import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordevs/data/http/http.dart';
import 'package:fordevs/data/usecases/usecases.dart';
import 'package:fordevs/domain/usecases/usecases.dart';
import 'package:fordevs/domain/helpers/helpers.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import 'remote_authentcation_test.mocks.dart';

void main() {
  late RemoteAuthentication sut;
  late MockHttpClient httpClient;
  late String url;
  late AuthencationParams params;
  String accessToken = faker.guid.guid();

  Map mockValidData() => {
        'accessToken': accessToken,
        'name': faker.person.name(),
      };

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );
  void mockHttpData(Map data) {
    return mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError httpError) {
    return mockRequest().thenThrow(httpError);
  }

/*

 'accessToken': accessToken,
          'name': faker.person.name(),


 */
  setUp(() {
    httpClient = MockHttpClient();
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
    mockHttpData(mockValidData());

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
    mockHttpError(HttpError.badRequest);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () {
    mockHttpError(HttpError.notFound);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentials if HttpClient return 401', () {
    mockHttpError(HttpError.unauthorized);

    expect(() => sut.auth(params), throwsA(DomainError.invalidCredentials));
  });

  test('Should throw UnexpectedError if HttpClient return 500', () {
    mockHttpError(HttpError.serverError);

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });
  test('Should return an Account if HttpClient return 200', () async {
    mockHttpData(mockValidData());

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });

  test(
      'Should throw UnexpectedError if HttpClient return 200 with invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    expect(() => sut.auth(params), throwsA(DomainError.unexpected));
  });
}
