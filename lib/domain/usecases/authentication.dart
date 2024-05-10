// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthencationParams params);
}

class AuthencationParams extends Equatable {
  final String email;
  final String password;

  AuthencationParams({required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}
