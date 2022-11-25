import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/pages/teacher_add_attendance.dart';
import 'package:flutter/material.dart';

class TeacherLectures extends StatefulWidget {
  Teacher? teacher;
  TeacherLectures({Key? key, this.teacher}) : super(key: key);

  @override
  State<TeacherLectures> createState() => _TeacherLecturesState();
}

class _TeacherLecturesState extends State<TeacherLectures> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper helper = DatabaseHelper.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lectures'),
      ),
      body: FutureBuilder<List<Lecture>>(
        future: helper.getLecturesByTeacherId(widget.teacher!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
            Lecture? lecture = snapshot.data![index];
                // Datetime to TimeOfDay
                TimeOfDay fromTime = TimeOfDay(
                    hour: lecture.fromDate!.hour,
                    minute: lecture.fromDate!.minute);
                TimeOfDay toTime = TimeOfDay(
                    hour: lecture.toDate!.hour,
                    minute: lecture.toDate!.minute);

                return ListTile(
                  title: Text(snapshot.data![index].name!),
                  subtitle: Text("From: ${fromTime.format(context)} To: ${toTime.format(context)}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherAddAttendance(lecture: lecture, teacher: widget.teacher,))).then((value) => setState(() {}));
                    },
                    child: Text('Attendance'),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No lectures'),
            );
          }
        },
      ),
    );
  }
}
