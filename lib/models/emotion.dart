class EmotionModel {
  String id;
  String name;
  String? urlIcon;

  EmotionModel({
    required this.id,
    required this.name,
  });

  EmotionModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        urlIcon = map['urlIcon'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "urlIcon": urlIcon,
    };
  }
}
