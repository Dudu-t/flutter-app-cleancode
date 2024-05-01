import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromMap(Map map) =>
      RemoteAccountModel(map['accessToken']);

  AccountEntity toEntity() => AccountEntity(accessToken);
}
