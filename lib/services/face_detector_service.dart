import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorService {
  CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;
  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];
  List<Face> get faces => _faces;
  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(options: FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));

    // _faceDetector = FaceDetector(
    //     options: FaceDetectorOptions(
    //         performanceMode: FaceDetectorMode.fast,
    //         enableContours: true,
    //         enableClassification: true));
  }

  // Future<void> detectFacesFromImage(CameraImage image) async {
  //   // input image format from raw
  //   print(image.format.group);
  //   InputImageData _firebaseImageMetadata = InputImageData(
  //     imageRotation:
  //         _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
  //     inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ??
  //         InputImageFormat.nv21,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     planeData: image.planes.map(
  //       (Plane plane) {
  //         return InputImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width,
  //         );
  //       },
  //     ).toList(),
  //   );

  //   InputImage _firebaseVisionImage = InputImage.fromBytes(
  //     bytes: image.planes[0].bytes,
  //     inputImageData: _firebaseImageMetadata,
  //   );

  //   _faces = await _faceDetector.processImage(_firebaseVisionImage);
  // }

  ///for new version
  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation: _cameraService.cameraRotation ?? InputImageRotation.rotation0deg,
      inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
  
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
  
    InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;
  
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: InputImageFormat.yuv420,
      planeData: image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  
    InputImage _firebaseVisionImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );
  
    _faces = await _faceDetector.processImage(_firebaseVisionImage);
  }

  dispose() {
    _faceDetector.close();
  }
}
