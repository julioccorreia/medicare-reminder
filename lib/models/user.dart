class UserModel {
  String id;
  String fkUser;
  String name;
  String password;

  UserModel({
    required this.id,
    required this.fkUser,
    required this.name,
    required this.password,
  });

  UserModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        fkUser = map['fkUser'],
        name = map['name'],
        password = map['password'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fkUser": fkUser,
      "name": name,
      "password": password,
    };
  }
}
