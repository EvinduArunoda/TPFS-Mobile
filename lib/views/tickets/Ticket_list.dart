import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfs_policeman/models/Ticket.dart';
import 'package:tpfs_policeman/views/tickets/Ticket_tile.dart';

class Ticketlist extends StatefulWidget {
  List<Ticket> tickets;

  Ticketlist({Key key, @required this.tickets}) : super(key: key);
  @override
  _TicketlistState createState() => _TicketlistState();
}

class _TicketlistState extends State<Ticketlist> {
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      key: Key('TicketListBuilder'),
      itemCount: widget.tickets.length,
      itemBuilder: (context, index){
         return TicketTile(ticket: widget.tickets[index],key: Key('tile$index'),);
      },
    );
  }
}