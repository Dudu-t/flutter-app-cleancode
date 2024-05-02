import 'package:fordevs/data/http/http.dart';

import '../../domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromMap(Map map) {
    if (!map.containsKey('accessToken')) throw HttpError.invalidData;

    return RemoteAccountModel(map['accessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
