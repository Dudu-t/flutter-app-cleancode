import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthencationParams params);
}

class AuthencationParams {
  final String email;
  final String password;

  AuthencationParams({required this.email, required this.password});
}
