class AccountEntity {
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromMap(Map map) => AccountEntity(map['token']);
}
