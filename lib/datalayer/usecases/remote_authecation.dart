import 'package:fordevs/domain/entities/account_entitty.dart';

import '../../domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthencationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: RemoteAuthencationParams.fromDomain(params).toMap(),
    );
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
