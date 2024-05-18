class AlarmModel {
  String id;
  String fkUser;
  String fkUserDependent;
  String name;
  String description;
  DateTime date;

  AlarmModel({
    required this.id,
    required this.fkUser,
    required this.fkUserDependent,
    required this.name,
    required this.description,
    required this.date,
  });

  AlarmModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        fkUser = map['fkUser'],
        fkUserDependent = map['fkUserDependent'],
        name = map['name'],
        description = map['description'],
        date = map['date'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fkUser": fkUser,
      "fkUserDependent": fkUserDependent,
      "name": name,
      "description": description,
      "date": date,
    };
  }
}
