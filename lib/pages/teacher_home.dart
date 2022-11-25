import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/attend_by_biometric_data.dart';
import 'package:face_net_authentication/pages/add_biometric_data.dart';
import 'package:face_net_authentication/pages/models/teacher.dart';
import 'package:face_net_authentication/pages/teacher_add_lecture.dart';
import 'package:face_net_authentication/pages/teacher_lectures.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:flutter/material.dart';

class TeacherHome extends StatefulWidget {
  Teacher? teacher;
  TeacherHome({Key? key, this.teacher}) : super(key: key);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  bool loading = false;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _initializeServices().then((value) => print('Services initialized'));
  }

  Future _initializeServices() async {
    setState(() => loading = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home, color: Colors.blueGrey,),
        title:  Row(
          children: [
            Text(
              'Hi ' + widget.teacher!.name! + '!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blueGrey),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    DatabaseHelper _dataBaseHelper = DatabaseHelper.instance;
                    _dataBaseHelper.deleteAllTablesData();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image(image: AssetImage('assets/logo.png',
                      ),
                      height: 200,
                      width: 200,
                      
                      ),
                      SizedBox(height: 20),
                      // list view
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.add),
                              title: Text('Add Biometric Data'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddBiometricData(),
                                  ),
                                );
                              },
                            ),
                            // add lecture
                            ListTile(
                              leading: Icon(Icons.add),
                              title: Text('Add Lecture'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeacherAddLecture(teacher: widget.teacher!),
                                  ),
                                );
                              },
                            ),
                            // display all lectures
                            ListTile(
                              leading: Icon(Icons.list),
                              title: Text('Attendances'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeacherLectures(teacher: widget.teacher,),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
