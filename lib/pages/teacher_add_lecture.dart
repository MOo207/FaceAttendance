import 'dart:math';

import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class TeacherAddLecture extends StatefulWidget {
  Teacher teacher;
  TeacherAddLecture({Key? key, required this.teacher}) : super(key: key);

  @override
  State<TeacherAddLecture> createState() => _TeacherAddLectureState();
}

class _TeacherAddLectureState extends State<TeacherAddLecture> {
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  @override
  Widget build(BuildContext context) {
    final _lectureNameController = TextEditingController();

    void _selectFromTime() async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        cancelText: 'Cancel',
        confirmText: 'Confirm',
        helpText: 'Select Time',
      );
      if (timeOfDay != null) {
        setState(() {
          fromTime = timeOfDay;
        });
      }
    }

    Future<TimeOfDay?> _selectToTime() async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        cancelText: 'Cancel',
        confirmText: 'Confirm',
        helpText: 'Select Time',
      );
      return timeOfDay;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Lecture'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppTextField(
                          labelText: 'Lecture Name',
                          controller: _lectureNameController,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //  lecture fromDate picker widget
                      Row(
                        children: [
                          Text('From: '),
                          TextButton(
                            onPressed: () => _selectFromTime(),
                            child: Text(fromTime?.format(context) ?? 'Select Time'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //  lecture toDate picker widget
                      Row(
                        children: [
                          Text('To: '),
                          TextButton(
                            onPressed: () async {
                              TimeOfDay? timeOfDay = await _selectToTime();
                              if (timeOfDay != null) {
                                toTime = timeOfDay;
                              }
                              setState(() {});
                            },
                            child:
                                Text(toTime?.format(context) ?? 'Select Time'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppButton(
                          text: 'Add Lecture',
                          onPressed: () async {
                            if (_lectureNameController.text.isNotEmpty &&
                                fromTime != null &&
                                toTime != null) {
                              DatabaseHelper helper = DatabaseHelper.instance;
                              Lecture lecture = Lecture(
                                id: Random().nextInt(999999999),
                                name: _lectureNameController.text,
                                teacherId: widget.teacher.id,
                                fromDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    fromTime!.hour,
                                    fromTime!.minute),
                                toDate: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    toTime!.hour,
                                    toTime!.minute),
                              );
                              await helper.createLecture(lecture);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lecture Added')));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please enter name')));
                            }
                          })
                    ],
                  ))
            ],
          ),
        ));
  }
}
