import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;
  HttpAdapter(this.client);

  @override
  Future<Map?> request({
    required String url,
    required HttpMethod method,
    Map? body,
  }) async {
    if (!_isValidMethod(method)) return _handleResponse(Response('', 500));

    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    final jsonBody = body != null ? jsonEncode(body) : null;

    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    return _handleResponse(response);
  }

  bool _isValidMethod(HttpMethod method) {
    const validMethods = [HttpMethod.post];

    return validMethods.contains(method);
  }

  Map? bodyDecoded(String body) {
    return body.isEmpty ? null : jsonDecode(body);
  }

  Map? _handleResponse(Response response) {
    final body = response.body;

    switch (response.statusCode) {
      case 200:
        return bodyDecoded(body);
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
