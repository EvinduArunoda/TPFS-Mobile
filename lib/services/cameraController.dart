import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/models/vehicle.dart';
import 'package:tpfs_policeman/views/CA%20module/takePicture.dart';
import 'package:tpfs_policeman/views/tickets/addImageToTicket.dart';


  // runApp(
  //   MaterialApp(
  //     theme: ThemeData.dark(),
  //     home: TakePictureScreen(
  //       // Pass the appropriate camera to the TakePictureScreen widget.
  //       camera: firstCamera,
  //     ),
  //   ),
  // );
// }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  Ticket ticket;
  String reason;
  Vehicle vehicle;
  Driver driver;


  TakePictureScreen({
    Key key,
    @required this.camera,this.ticket,this.reason,this.vehicle,this.driver
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
//            return RotationTransition(
//              turns:AlwaysStoppedAnimation(270 / 360),
//              child: CameraPreview(_controller));
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.camera_alt),       
        ),
        backgroundColor: Colors.blueGrey,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            //path = await FlutterExifRotation.rotateImage(path: path);
            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
           //File image = await FlutterExifRotation.rotateImage(path: path);

            if(widget.reason == '1'){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TakePicture(imagePath: path),
              ),
            );
            }
            else if(widget.reason == '2'){
               Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureTicket(imagePath: path,ticket:widget.ticket,isVehicle: true,vehicle: widget.vehicle),
              ),
            );
            }
            else if(widget.reason == '3'){
               Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureTicket(imagePath: path,ticket:widget.ticket,isVehicle: false,driver: widget.driver),
              ),
            );
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final  imagePath;

//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: RotationTransition(turns:AlwaysStoppedAnimation(270 / 360),child: Image.file(File(imagePath))),
//     );
//   }
// }