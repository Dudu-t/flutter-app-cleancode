import 'package:fordevs/domain/helpers/helpers.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthencationParams params) async {
    try {
      await httpClient.request(
        url: url,
        method: 'post',
        body: RemoteAuthencationParams.fromDomain(params).toMap(),
      );
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthencationParams {
  final String email;
  final String password;

  RemoteAuthencationParams({required this.email, required this.password});

  factory RemoteAuthencationParams.fromDomain(AuthencationParams params) =>
      RemoteAuthencationParams(
        email: params.email,
        password: params.password,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }
}
