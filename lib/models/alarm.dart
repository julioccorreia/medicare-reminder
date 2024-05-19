class AlarmModel {
  String id;
  String name;
  String? description;
  int hour;
  int minute;

  AlarmModel({
    required this.id,
    required this.name,
    this.description,
    required this.hour,
    required this.minute,
  });

  AlarmModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        hour = map['hour'],
        minute = map['minute'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "hour": hour,
      "minute": minute,
    };
  }
}
