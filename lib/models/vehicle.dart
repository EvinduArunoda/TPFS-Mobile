//vehicle modal class used to store data of vehicle searched during vehicle profile search

class Vehicle {
  
  final String licensePlate;
  final String insuranceNumber;
  final String makeAndModel;
  final String regOwner;
  final String regownerNumber;
  final List<dynamic> conditionAndClass;
  final String regNICNumber;

  Vehicle({ this.licensePlate,this.insuranceNumber, this.makeAndModel, this.regOwner, this.regownerNumber,
            this.conditionAndClass,this.regNICNumber});
}