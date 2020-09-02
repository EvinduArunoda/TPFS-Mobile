//Ticket modal class used to store data of ticket created during each procedure

class  Ticket{
  
  String licensePlate;
  String licenseNumber;
  num phoneNumber;
  String area;
  String date;
  String time;
  dynamic timestamp;

  String vehicle;
  double fineAmount;
  String status;
  List<dynamic> offences;

  dynamic areaCoordinates;
  String vehicleImagePath;
  String driverImagePath;
  String licenseNumberImageLocation;
  String licensePlateImageLocation;
  String validatedText;
  String validatedTextScore;

  String policemenemployeeID;
  String policemenstationID;

  Ticket({ this.licensePlate,this.licenseNumber, this.area, this.date, this.time,
            this.vehicle,this.fineAmount,this.status,this.phoneNumber,this.offences,this.areaCoordinates,this.timestamp,
              this.validatedText,this.validatedTextScore,this.policemenemployeeID,this.policemenstationID});
}