import 'dart:async';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/models/lecture.dart';
import 'package:face_net_authentication/pages/models/student.dart';
import 'package:face_net_authentication/pages/widgets/auth_button.dart';
import 'package:face_net_authentication/pages/widgets/camera_detection_preview.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/signin_form.dart';
import 'package:face_net_authentication/pages/widgets/single_picture.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AttendByBiometricData extends StatefulWidget {
  final Lecture? lecture;
  const AttendByBiometricData({Key? key, required this.lecture}) : super(key: key);

  @override
  AttendByBiometricDataState createState() => AttendByBiometricDataState();
}

class AttendByBiometricDataState extends State<AttendByBiometricData> {
  CameraService _cameraService = locator<CameraService>();
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize();
    setState(() => _isInitializing = false);
    _frameFaces();
  }

  _toggle() async {
    setState(() => _isInitializing = true);
    await _cameraService.toggleCamera();
    setState(() => _isInitializing = false);

    _frameFaces();
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(image, _faceDetectorService.faces[0]);
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      await _cameraService.takePicture();
      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('No face detected!')));
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      Student? student = await _mlService.predict();
       var bottomSheetController = scaffoldKey.currentState!
          .showBottomSheet((context) => signInSheet(student: student, lecture: widget.lecture));
      bottomSheetController.closed.whenComplete(_reload);
    }
  }

  Widget getBodyWidget() {
    if (_isInitializing) return Center(child: CircularProgressIndicator());
    if (_isPictureTaken)
      return SinglePicture(imagePath: _cameraService.imagePath!);
    return CameraDetectionPreview();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("Attend", onBackPressed: _onBackPressed);
    Widget body = getBodyWidget();

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_isPictureTaken? Row(children: [
            Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: FloatingActionButton(
                    heroTag: "switchCamera",
                    onPressed: () async{
                      _toggle();
                    },
                    child: Icon(Icons.switch_camera, color: Colors.white),
                  ),
                ),
          SizedBox(width: 10,),
         AuthButton(onTap: onTap)
      ]): Container(),
    );
  }

  signInSheet({@required Student? student, @required Lecture? lecture}) => student == null
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Text(
            'Person not found 😞',
            style: TextStyle(fontSize: 20),
          ),
        )
      : AttendByBiometricDataSheet(student: student, lecture: lecture,);
}
