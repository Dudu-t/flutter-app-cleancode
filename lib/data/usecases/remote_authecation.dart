import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<AccountEntity> auth(AuthencationParams params) async {
    try {
      final httpResponse = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: RemoteAuthencationParams.fromDomain(params).toMap(),
      );

      if (httpResponse == null) throw HttpError.badRequest;

      return RemoteAccountModel.fromMap(httpResponse).toEntity();
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
