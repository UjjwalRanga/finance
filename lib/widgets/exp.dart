import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Exp extends StatefulWidget {



  final String amount;
  final String title;
  final String time;
  final int index;
  final Function fun;


    Exp({required this.amount,required this.title, required this.fun,required this.index, required this.time});

  @override
  State<Exp> createState() => _ExpState();
}

class _ExpState extends State<Exp> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -2),
            trailing: IconButton(icon: const Icon(Icons.delete),onPressed: ()=>widget.fun(widget.index)),
            leading: CircleAvatar(
              radius: 25,
                 backgroundColor: Theme.of(context).primaryColor,
                child: FittedBox(child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text("\$${widget.amount}",style: const TextStyle(color: Colors.white),),
                ),)
            ),
            subtitle: Text(
              DateFormat.yMMMEd().format(DateTime.parse(widget.time)).toString(),
              style: const TextStyle(color: Colors.grey,fontSize: 12),
            ),
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 20),)
        )
    );
  }
}
