//Criminal modal class to store the data of the matched criminal faces during criminal assesment 

class Criminal{
    String name;
    String address;
    String nicNumber;
    String phoneNumber;
    List<dynamic> offencesReference;

    Criminal({this.name,this.address,this.nicNumber,this.phoneNumber,this.offencesReference});
}
