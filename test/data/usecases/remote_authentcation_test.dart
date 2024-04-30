import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordevs/datalayer/http/http.dart';
import 'package:fordevs/datalayer/usecases/usecases.dart';
import 'package:fordevs/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
  });

  test('Should call HttpCLient with correct URL', () async {
    final params = AuthencationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
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
}
