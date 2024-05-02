import 'package:faker/faker.dart';
import 'package:fordevs/data/http/http_error.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<Client>()])
import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;
  HttpAdapter(this.client);

  Future<Response> request({
    required String? url,
    required String? method,
    Map? body,
  }) async {
    if (url == null) throw HttpError.badRequest;

    return await client.post(Uri.parse(url));
  }
}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = MockClient();
      final sut = HttpAdapter(client);
      final url = faker.internet.httpUrl();

      await sut.request(url: url, method: 'post');

      verify(client.post(Uri.parse(url)));
    });
  });
}
