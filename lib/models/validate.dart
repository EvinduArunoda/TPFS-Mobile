//Validate modal class used to store data of image processing results of license validation

class Validate{
  final Map<dynamic,dynamic> licensePlateValidation;
  final Map<dynamic,dynamic> licenseValidation;
  final String docid;

  Validate({this.docid,this.licensePlateValidation,this.licenseValidation});
}