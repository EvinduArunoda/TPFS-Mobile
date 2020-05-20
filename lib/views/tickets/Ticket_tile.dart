import 'package:flutter/material.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/views/tickets/ticketDetails.dart';

class TicketTile extends StatelessWidget {
  final Ticket ticket;

  TicketTile({this.ticket});

  Widget getTextWidgets(){
    return new Column(crossAxisAlignment: CrossAxisAlignment.start,children: ticket.offences.map((item) => Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom:2.0),
        child: new Text(
          item,
          style: TextStyle(
            color: Colors.red[900],
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            letterSpacing: 2.0,
          ),
        ),
      ),
    )).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
              boxShadow:[ new BoxShadow(
              color: Colors.blueGrey,
              blurRadius: 6.0,
            ),
            ]),
            child: Card(
              color: Colors.white,
              // margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 5.0),
              child: ListTile(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => TicketDetails(ticket: ticket)),
                  );
                },
                dense: true,
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'Fine Amount : ',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            '${ticket.fineAmount}',
                            style: TextStyle(
                              color: Colors.cyan[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Ticket Status : ',
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.4,
                              child: Text(
                                ticket.status.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7.0),
                      Row(
                        children: <Widget>[
                          Text(
                            'Offences',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: getTextWidgets()
                            ),
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
                trailing: Column(
                  children:<Widget>[
                    Text(
                      ticket.date,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Text(
                      ticket.time,
                       style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}