
class Lecture {
  int? id;
  String? name;
  final DateTime? fromDate;
  final DateTime? toDate;
  int? teacherId;

  Lecture({this.id, this.name, this.fromDate, this.toDate, this.teacherId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fromDate': fromDate.toString(),
      'toDate': toDate.toString(),
      'teacher_id': teacherId,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
      id: map['id'] == null ? null : map['id'],
      name: map['name'] == null ? null : map['name'],
      fromDate: map['fromDate'] == null ? null : DateTime.parse(map['fromDate']),
      toDate: map['toDate'] == null ? null : DateTime.parse(map['toDate']),
      teacherId: map['teacher_id'] == null ? null : map['teacher_id'],
    );
  }
}