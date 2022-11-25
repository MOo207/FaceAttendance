import 'dart:convert';

class Student {
  int id;
  String name;
  List faceData;

  Student({
    required this.name,
    required this.faceData, 
    // generate random int id
    required this.id
  });

  static Student fromMap(Map<String, dynamic> student) {
    return new Student(
      id: student['id'] == null ? null : student['id'],
      name: student['name'] == null ? null : student['name'],
      faceData: student['faceData'] == null ? null : jsonDecode(student['faceData']),
    );
  }

  toMap() {
    return {
      'id': id,
      'name': name,
      'faceData': jsonEncode(faceData),
    };
  }
}
