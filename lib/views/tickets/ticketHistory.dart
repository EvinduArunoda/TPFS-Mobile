// import 'package:filter_list/filter_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tpfs_policeman/shared/filterList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/models/driver.dart';
import 'package:tpfs_policeman/services/auth.dart';
import 'package:tpfs_policeman/services/createTicket.dart';
import 'package:tpfs_policeman/services/db_driver.dart';
import 'package:tpfs_policeman/services/db_policeman.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/views/tickets/Ticket_list.dart';
import 'package:tpfs_policeman/views/profiles/profile.dart';

class TicketHistory extends StatefulWidget {
  List<Ticket> outstandingTickets;
  List<Ticket> paidTickets;
  List<Ticket>reportedTickets;
  List<String>offencelist;
  List<Ticket> permoutstandingTickets;
  List<Ticket> permpaidTickets;
  List<Ticket>permreportedTickets;
  
  TicketHistory({Key key, @required this.outstandingTickets, @required this.paidTickets, @required this.reportedTickets,
      @required this.offencelist,this.permoutstandingTickets,this.permpaidTickets,this.permreportedTickets}) : super(key: key);

  @override
  _TicketHistoryState createState() => _TicketHistoryState();

}

class _TicketHistoryState extends State<TicketHistory> {
  bool outstandingHistory = false;
  bool paidHistory = false;
  bool reported = false;


  List<String> selectedCountList = [];
  @override
    Widget build(BuildContext context) {
      if(widget.outstandingTickets.isNotEmpty){
        setState(() => outstandingHistory = true);
      }else{
        setState(() => outstandingHistory = false);
      }

      if(widget.paidTickets.isNotEmpty){
      setState(() => paidHistory = true);
      }else{
        setState(() => paidHistory = false);
      }

      if(widget.reportedTickets.isNotEmpty){
        setState(() => reported = true);
      }else{
        setState(() => reported = false);
      }
      
        Future<void> _openFilterList() async {
          var list = await FilterList.showFilterList(
            context,
            allTextList: widget.offencelist,
            height: 450,
            width: MediaQuery.of(context).size.width*0.9,
            borderRadius: 10,
            headlineText: "Select Offences",
            hideSearchField: true,
            selectedTextList: selectedCountList,
            

          );
          
          if (list != null) {
            setState(() {
              selectedCountList = List.from(list);
              // print(selectedCountList);
            });
          }
        }

      return DefaultTabController(
        key: Key('TicketHistoryTab'),
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            key: Key('TicketAppBarHistory'),
            leading: BackButton(key:Key('goBackVehicle')),
            title : Text('Ticket History'.toUpperCase(),style: GoogleFonts.orbitron(letterSpacing: 1.5,fontSize: 20.0),),
            backgroundColor: Colors.cyan[900],
            elevation: 10.0,
            actions: <Widget>[
              IconButton(
                key: Key('FilterTicketsWidget'),
            onPressed: ()async{
              // print(widget.offencelist);
             await _openFilterList();
             if(selectedCountList.isNotEmpty){
              setState(() {
                print(selectedCountList);
                widget.outstandingTickets = CreateTicketNew().filterOffences(widget.permoutstandingTickets, selectedCountList);
                widget.paidTickets = CreateTicketNew().filterOffences(widget.permpaidTickets, selectedCountList);
                widget.reportedTickets = CreateTicketNew().filterOffences(widget.permreportedTickets, selectedCountList);
                // print(widget.reportedTickets);
             });
             }
             else{
                setState(() {
                // print(selectedCountList);
                widget.outstandingTickets = widget.permoutstandingTickets;
                widget.paidTickets = widget.permpaidTickets;
                widget.reportedTickets = widget.permreportedTickets;
                // print(widget.reportedTickets);
             });
             }
            //  print(selectedCountList);
            },
            icon: Icon(
              FontAwesomeIcons.th,
              size: 30.0,
              color: Colors.white, )),
            SizedBox(width: 10.0,)
            ],
            bottom: TabBar(
              key: Key('TopTabBarTickets'),
              indicatorColor: Colors.orange,
              tabs: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(fit: BoxFit.contain,child: Text('Outstanding'.toUpperCase(),key: Key('Outstanding'),style:GoogleFonts.bitter(
                        textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(fit: BoxFit.contain,child: Text('Paid'.toUpperCase(),key: Key('Paid'),style:GoogleFonts.bitter(
                        textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0)))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(fit: BoxFit.contain,child: Text('Reported'.toUpperCase(),key: Key('Reported'),style:GoogleFonts.bitter(
                        textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.0)))),
                ),
              ]
            )
          ),
          body: TabBarView(
            key: Key('ViewBodyTab'),
            children: <Widget>[
              outstandingHistory? Ticketlist(tickets: widget.outstandingTickets,key: Key('outHistory')) : NoHistory(key: Key('nooutHistory')),
              paidHistory? Ticketlist(tickets: widget.paidTickets,key: Key('paidHistory')) : NoHistory(key: Key('nopaidHistory')),
              reported? Ticketlist(tickets: widget.reportedTickets,key: Key('repHistory')) : NoHistory(key: Key('norepHistory')),
            ],
          ),
            ),
      );
    }
}

class NoHistory extends StatelessWidget {
  NoHistory({Key key}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          'NO RESULTS FOUND',
          textAlign: TextAlign.center,
          style: GoogleFonts.orbitron(
    textStyle: TextStyle(fontFamily: 'Roberto',color: Colors.red[900] , fontSize: 25.0,fontWeight: FontWeight.w700),
          )),
      ),
    );
  }
}