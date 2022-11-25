import 'dart:math';

import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/attendance.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/student.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:flutter/material.dart';

class AttendByBiometricDataSheet extends StatefulWidget {
  Lecture? lecture;
  final Student student;
  AttendByBiometricDataSheet(
      {Key? key, required this.student, required this.lecture})
      : super(key: key);

  @override
  State<AttendByBiometricDataSheet> createState() =>
      _AttendByBiometricDataSheetState();
}

class _AttendByBiometricDataSheetState
    extends State<AttendByBiometricDataSheet> {
  final _cameraService = locator<CameraService>();

  Future _signIn(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Person attendance has been marked!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Confirm Attend, ' + widget.student.name + '?',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                AppButton(
                  text: 'Confirm',
                  onPressed: () async {
                    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
                    // attend student
                    Attendance attendance = Attendance(
                        id: Random().nextInt(99999999),
                        studentId: widget.student.id,
                        time: DateTime.now(),
                        isAttended: 1,
                        lectureId: widget.lecture!.id!);
                    bool isAttended =
                        await _databaseHelper.attendStudent(attendance);
                    if (isAttended) {
                      await _signIn(context);
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Attending failed")));
                    }
                  },
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
