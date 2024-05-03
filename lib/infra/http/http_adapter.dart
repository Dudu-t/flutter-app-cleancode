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
    try {
      if (!_isValidMethod(method)) return _handleResponse(Response('', 500));

      final jsonBody = body != null ? jsonEncode(body) : null;
      final Uri uri = Uri.parse(url);

      final response = await _sendRequest(
        sendHttpUri: uri,
        sendHttpMethod: method,
        sendBody: jsonBody,
      );

      return _handleResponse(response);
    } catch (e) {
      return _handleResponse(Response('', 500));
    }
  }

  Future<Response> _sendRequest({
    required sendHttpUri,
    required HttpMethod sendHttpMethod,
    String? sendBody,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    };

    late Response response;

    switch (sendHttpMethod) {
      case HttpMethod.get:
        {
          response = await client.get(sendHttpUri, headers: headers);
          break;
        }
      case HttpMethod.post:
        {
          response =
              await client.post(sendHttpUri, headers: headers, body: sendBody);
          break;
        }
    }

    return response;
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
