//Driver modal class used to store driver details fetched during driver license number search

class Driver {
  
  final String licenseNumber;
  final String name;
  final String address;
  final num phoneNumber;
  final List<dynamic> physicalDisabilities;
  final String emailAddress;
  final String nicnumber;

  Driver({ this.licenseNumber,this.name, this.address, this.phoneNumber, this.emailAddress,
            this.physicalDisabilities,this.nicnumber});
}