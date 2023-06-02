class Player {
  int? id;
  String? name;
  int status = 0;

  Player({
    required this.name,
  });

  Player.withId({this.id, required this.name, required this.status});

  // Bu funksiya db uchun Task ni Map ko'rinishiga o'zgartiradi
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map["id"] = id;
    map["name"] = name;
    map["status"] = status;
    return map;
  }

//  Bu funksiya model uchun db dagi Map ni Task ko'rinishiga qaytaradi(o'zgartiradi)
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player.withId(
      id: map["id"],
      name: map["name"],
      status: map["status"],
    );
  }
}
