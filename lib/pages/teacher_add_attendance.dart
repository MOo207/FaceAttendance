import 'package:face_net_authentication/pages/attend_by_biometric_data.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/student.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/services/export_service.dart';
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
          actions: [
            // export to csv button
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: () async {
                ExportService exportService = ExportService();
                List<Student> students = await studentsFuture;
                // Define the CSV header
    final       List<String> header = ['ID', 'NAME', 'TIME', 'ATTENDANCE'];
                List<List<dynamic>> attendances = [];
                for (Student student in students) {
                  Attendance? attendance =
                      await helper.getAttendanceByStudentIdAndLectureId(
                          student.id, widget.lecture!.id!);
                  if (attendance != null) {
                    // write each attendence as alist of list of strings
                    attendances.add([attendance.studentId, student.name, attendance.time, "PRESENT"]);
                  } else{
                      attendances.add([student.id, student.name, "NONE", "ABSENT"]);
                  }
                }
                print(attendances);
                await exportService.writeDataToCSV(attendances);
              },
            ),
          ],
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
