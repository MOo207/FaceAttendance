class Attendance {
  int id;
  int lectureId;
  int studentId;
  final DateTime? time;
  int isAttended;

  Attendance({
    required this.id,
    required this.lectureId,
    required this.studentId,
    this.time,
    this.isAttended = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lecture_id': lectureId,
      'student_id': studentId,
      'time': time.toString(),
      'is_attended': isAttended,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map["id"] == null ? null : map["id"],
      lectureId: map['lecture_id'] == null ? null : map['lecture_id'],
      studentId: map['student_id'] == null ? null : map['student_id'],
      time: map['time'] == null ? null :  DateTime.parse(map['time']),
      isAttended: map['is_attended'] == null ? null : map['is_attended'],
    );
  }
}