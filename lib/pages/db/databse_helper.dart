import 'dart:io';
import 'dart:math';

import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/student.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "faceAttendance.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // await dropDatabase();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
    );
  }

  // drop db
  Future<void> dropDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
  }

  // create teacher table
  Future<void> createTeacherTable(Database db) async {
    // create teachers table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS teachers (
            id integer primary key autoincrement,
            name text not null,
            password text not null
          )
          ''');
  }

  // create student table
  Future<void> createStudentTable(Database db) async {
    // create students table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY autoincrement,
            name TEXT NOT NULL,
            faceData TEXT NOT NULL)
          ''');
  }

  // create lecture table
  Future<void> createLectureTable(Database db) async {
    // create lectures table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS lectures (
            id integer primary key autoincrement,
            name text not null,
            fromDate text not null,
            toDate text not null,
            teacher_id integer not null,
            FOREIGN KEY (teacher_id) REFERENCES teachers(id))
          ''');
  }

  // create attendance table
  Future<void> createAttendanceTable(Database db) async {
    // create attendance table
    await db.execute('''
          CREATE TABLE IF NOT EXISTS attendance (
            id integer primary key autoincrement,
            lecture_id integer not null,
            student_id integer not null,
            time text,
            is_attended integer not null default 0,
            FOREIGN KEY (lecture_id) REFERENCES lectures (id),
            FOREIGN KEY (student_id) REFERENCES students (id))
          ''');
  }

  Future _onCreate(Database db, int version) async {
    await createTeacherTable(db);
    await createStudentTable(db);
    await createLectureTable(db);
    await createAttendanceTable(db);
  }

  Future<int> insertStudent(Student student) async {
    Database db = await instance.database;
    return await db.insert("students", student.toMap());
  }

  Future<List<Student>> queryAllStudents() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> students = await db.query("students");
    return students.map((u) => Student.fromMap(u)).toList();
  }

  Future<int> deleteAllTablesData() async {
    Database db = await instance.database;
    int result = 0;
    result += await db.delete("students");
    result += await db.delete("teachers");
    result += await db.delete("lectures");
    result += await db.delete("attendance");
    return result;
  }

  // attend student
  Future<bool> attendStudent(Attendance attendance) async {
    try {
      Database db = await instance.database;
      await db.insert("attendance", attendance.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // get all students
  Future<List<Student>> getAllStudents() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> students = await db.query("students");
    return students.map((u) => Student.fromMap(u)).toList();
  }

  // login teacher
  Future<Teacher?> loginTeacher(String name, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> teachers = await db.query("teachers",
        where: "name = ? AND password = ?", whereArgs: [name, password]);
    if (teachers.length > 0) {
      return Teacher.fromMap(teachers.first);
    }
    return null;
  }

  // sign up teacher
  Future<Teacher?> signUpTeacher(String name, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> teachers = await db.query("teachers",
        where: "name = ? AND password = ?", whereArgs: [name, password]);
    if (teachers.length > 0) {
      return null;
    }
    Teacher teacher =
        Teacher(id: Random().nextInt(99999999), name: name, password: password);
    await db.insert("teachers", teacher.toMap());
    teachers = await db.query("teachers",
        where: "name = ? AND password = ?", whereArgs: [name, password]);
    return Teacher.fromMap(teachers.first);
  }

  // create lecture
  Future<int> createLecture(Lecture lecture) async {
    Database db = await instance.database;
    return await db.insert("lectures", lecture.toMap());
  }

  // get all lectures
  Future<List<Lecture>> getAllLectures() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> lectures = await db.query("lectures");
    return lectures.map((u) => Lecture.fromMap(u)).toList();
  }

  // get lecture by teacher id
  Future<List<Lecture>> getLecturesByTeacherId(int teacherId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> lectures = await db
        .query("lectures", where: "teacher_id = ?", whereArgs: [teacherId]);
    return lectures.map((u) => Lecture.fromMap(u)).toList();
  }

  // get attendance by lecture id and

  // create attendance
  Future<int> createAttendance(Attendance attendance) async {
    Database db = await instance.database;
    return await db.insert("attendance", attendance.toMap());
  }

  // get all attendance
  Future<List<Attendance>> getAllAttendance() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> attendance = await db.query("attendance");
    return attendance.map((u) => Attendance.fromMap(u)).toList();
  }

  // get attendance by lecture id
  Future<List<Attendance>> getAttendanceByLectureId(int lectureId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> attendance = await db
        .query("attendance", where: "lecture_id = ?", whereArgs: [lectureId]);
    return attendance.map((u) => Attendance.fromMap(u)).toList();
  }

  // get attendance by student id and lecture id
  Future<Attendance?> getAttendanceByStudentIdAndLectureId(
      int studentId, int lectureId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> attendance = await db.query("attendance",
        where: "student_id = ? AND lecture_id = ?",
        whereArgs: [studentId, lectureId]);
    if (attendance.length > 0) {
      return Attendance.fromMap(attendance.first);
    }
    return null;
  }

  // show lecture by date
  Future<List<Lecture>> getLectureByDate(String date) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> lectures = await db
        .query("lectures", where: "from LIKE ?", whereArgs: ["%$date%"]);
    return lectures.map((u) => Lecture.fromMap(u)).toList();
  }
}
