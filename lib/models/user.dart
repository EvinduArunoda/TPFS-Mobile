//user modal class used to store data of profile of policemen using the application

class User {

  final String uid;

  User ({this.uid});
}

class UserData {
  
  final String userid;
  final String firstName;
  final String lastName;
  final String address;
  final String employeeID;
  final String phoneNumber;
  final String mailID;
  final String nicnumber;
  final String stationID;

  UserData({ this.userid,this.firstName, this.lastName, this.address, this.employeeID,this.phoneNumber,this.mailID,this.nicnumber,this.stationID});
}

class UserLog {
  
  final String userid;
  num numOfProcedures;
  num numbOfTicSuccess;
  num numbOfTicRep;
  num numofVehProfViewed;
  num numofDriProfViewed;

  UserLog({ this.userid,this.numOfProcedures,this.numbOfTicSuccess,this.numbOfTicRep,this.numofDriProfViewed,this.numofVehProfViewed });
}