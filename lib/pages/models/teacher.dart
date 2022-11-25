
class Teacher {
  int? id;
  String? name;
  String? password;

  Teacher({this.id, this.name, this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'] == null ? null : map['id'],
      name: map['name'] == null ? null : map['name'],
      password: map['password'] == null ? null : map['password'],
    );
  }
}