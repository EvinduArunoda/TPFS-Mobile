import 'dart:io';
import 'package:tpfs_policeman/models/criminal.dart';
import 'package:tpfs_policeman/models/user.dart';
import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/services/cameraController.dart';
import 'package:tpfs_policeman/services/criminalAssessment.dart';
import 'package:tpfs_policeman/services/firebaseStorage.dart';
import 'package:tpfs_policeman/shared/loading.dart';
import 'package:tpfs_policeman/views/CA%20module/noMatch.dart';
import 'package:tpfs_policeman/views/CA%20module/viewResult.dart';


 class TakePicture extends StatefulWidget {
   CameraDescription camera;
   String imagePath;

   TakePicture({this.camera,this.imagePath});
   @override
   _TakePictureState createState() => _TakePictureState();
 }
 
 class _TakePictureState extends State<TakePicture> {
   final HttpsCallable callableSecond = CloudFunctions.instance.getHttpsCallable(functionName: 'CriminalHistory');
    bool isImage = false;
    final time = DateTime.now();
    bool loading = false;

   void showModal(){
     showDialog<Null>(
       context: context,
       barrierDismissible: false, // user must tap button!
       builder: (BuildContext context) {
         return AlertDialog(
           content: SingleChildScrollView(
             child: ListBody(
               children: <Widget>[
                 Text(
                   'Incorrect invalid image assessed.',
                   style: TextStyle(
                     // color: Colors.black,
                     letterSpacing: 2.0,
                     // fontWeight: FontWeight.bold,
                     fontSize: 18,
                   ),
                 ),
               ],
             ),
           ),
           actions: <Widget>[
             FlatButton(
               child: Text(
                 'OK',
                 style: TextStyle(
                     letterSpacing: 0.5,
                     fontWeight: FontWeight.bold,
                     fontSize: 16
                 ),),
               onPressed: () {
                 Navigator.popUntil(context, ModalRoute.withName("Process"));
               },
             ),
           ],
         );
       },
     );
   }

    @override
    Widget build(BuildContext context) {
      final userUID = Provider.of<User>(context);
      if(widget.imagePath != null){
        isImage = true;
      }
      return loading ? Loading() :Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Criminal Assessment',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 25,
            ),),
        ),
        backgroundColor: Colors.cyan[900],
        elevation: 10.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 70.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35.0,5.0,35.0,5.0),
                child: Column(
                  children: <Widget>[
                    isImage? Container(
//                      child:RotationTransition(turns:AlwaysStoppedAnimation(270 / 360),child: Image.file(File(widget.imagePath))),
                      child:Image.file(File(widget.imagePath)),
                    ) : Column(
                      children : <Widget>[
                        IconButton(
                        icon: Icon(
                          FontAwesomeIcons.cameraRetro,
                          color: Colors.cyan[900],
                          ),
                        iconSize: 200.0,
                        onPressed: null
                        ),
                    SizedBox(height:10.0),
                    Text(
                      'Take New Picture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        fontSize: 23.0,                        
                      ),
                    ),
                    SizedBox(height:14.0),
                    Text(
                      'Click to start taking picture for criminal assessment',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 16.0,                        
                      ),
                    ),
                      ]),
                    SizedBox(height:30.0),
                    FloatingActionButton.extended(
                      onPressed: ()async{
                        if(isImage){
                          setState(() => loading = true);
                        final filepath = '${userUID.uid}:$time';
                        String assessImageLocation = await Storage().uploadDriverAssessImage(widget.imagePath, filepath);
                        //String assessImageLocation = 'CriminalAssessment/slafhia.jpg';
                       final HttpsCallableResult criminalresult = await callableSecond.call(
                         <String, dynamic>{
                           'imagefilePath':assessImageLocation,
                           'id' : filepath,
                           'userid' : userUID.uid
                         },
                       ).catchError((onError){
                         print(Error);
                       });
//                       print(criminalresult.data);
                          var resultid = '';
                          var resultCoorelation = '';
                        //get the result and check if it is unknown or any other
                          if(criminalresult != null){
                            resultid = criminalresult.data['personNIC'];
                            resultCoorelation = criminalresult.data['corelation'];
                            print(resultid);
                            print(resultCoorelation);
                          }
                        if(resultid == 'unknown'){
                          setState(() => loading = false);
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => NoMatch(imagePath: widget.imagePath)));
                        }
                        else if(resultid == ''){
                          setState(() => loading = false);
                          showModal();
                        }
                        else{
                          String matchdriverImage = await Storage().getCriminalImage(resultid);
                          print(matchdriverImage);
                          List<Criminal> matchdriverDetails = await CriminalAssessment().getCriminalDetails(resultid);
                          print(matchdriverDetails);
                          setState(() => loading = false);
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => ViewResult(assessDriverImagePath: widget.imagePath,matchDriverImagePath: matchdriverImage,criminalDetails: matchdriverDetails[0],filepath: filepath,corelation: resultCoorelation)));
                        }
                        }
                        else{
                        print(widget.imagePath);
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => TakePictureScreen(camera: widget.camera, reason: '1')));
                        }
                      },
                      label: isImage? Text('Check Criminal History', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),) : Text('Take Picture'),
                      icon: isImage? Icon(Icons.assignment_ind) :Icon(Icons.add_a_photo),
                      backgroundColor: Colors.blueGrey,
                      )
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
      
      );
  }
  }
