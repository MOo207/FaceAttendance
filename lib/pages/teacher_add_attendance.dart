import 'package:face_net_authentication/pages/attend_by_biometric_data.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/student.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:flutter/material.dart';

class TeacherAddAttendance extends StatefulWidget {
  Lecture? lecture;
  Teacher? teacher;
  TeacherAddAttendance({Key? key, required this.lecture, required this.teacher})
      : super(key: key);

  @override
  State<TeacherAddAttendance> createState() => _TeacherAddAttendanceState();
}

class _TeacherAddAttendanceState extends State<TeacherAddAttendance> {
  DatabaseHelper helper = DatabaseHelper.instance;
  late Future<List<Student>> studentsFuture;

  @override
  void initState() {
    studentsFuture = helper.getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Attendance'),
        ),
        body: FutureBuilder<List<Student>>(
          future: studentsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 800,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Student student = snapshot.data![index];
                    return ListTile(
                      title: Text(student.name),
                      leading: Text(student.id.toString()),
                      trailing: FutureBuilder<Attendance?>(
                        future: helper.getAttendanceByStudentIdAndLectureId(
                            student.id, widget.lecture!.id!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Attendance? attendance = snapshot.data;
                            return Checkbox(
                              side: BorderSide(width: 2, color: Colors.black),
                              value: attendance!.isAttended == 1 ? true : false,
                              onChanged: (value) async {
                                setState(() {
                                  attendance.isAttended = value! ? 1 : 0;
                                });
                              },
                            );
                          } else {
                            return SizedBox(
                              height: 10,
                              width: 10,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            // Positioned the button at the bottom of the screen

            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          AttendByBiometricData(lecture: widget.lecture!))));
            }));
  }
}
