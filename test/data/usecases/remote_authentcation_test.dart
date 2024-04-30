import 'package:faker/faker.dart';
import 'package:fordevs/domain/usecases/usecases.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthencationParams params) async {
    final body = {'email': params.email, 'password': params.password};

    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map body,
  });
}

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
