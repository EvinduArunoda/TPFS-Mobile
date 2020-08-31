import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[900],
      child: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 55.0,
        ),
      ),
    );
  }
}

class LoadingAnother extends StatelessWidget {
  LoadingAnother({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[900],
      child: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 55.0,
        ),
      ),
    );
  }
}