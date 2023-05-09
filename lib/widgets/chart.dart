import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {

  final List<List<String>> exp;
  Chart({required this.exp});



  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {

  double total = 0.0;
  double sum(){
    double s = 0;
    for(int i=0;i< widget.exp.length;i++){
        s += double.parse(widget.exp[i][1]);

    }
    return s;
  }

  double daySum(String day){
    double s = 0;
    for(int i=0;i< widget.exp.length;i++){
      if(day == DateFormat.E().format(DateTime.parse(widget.exp[i][2])).toString()) {
        s += double.parse(widget.exp[i][1]);
      }
    }
    return s;
  }
  Widget bar(String day,){

    total =  sum();
    double n = daySum(day);
   // print("$day  $n  $total");
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          FittedBox(child: Text(n.toStringAsFixed(2))),
          const SizedBox(height: 5,),
          Expanded(
            child: Container(
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
              child: FractionallySizedBox(
                heightFactor: (total!=0)?n/total:0,
                alignment: Alignment.bottomCenter,
                child: Container(
                decoration:  BoxDecoration(
                  borderRadius:
                  (total != n) ? const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)

                  ):
                  BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ) ,
            ),
          ),
          const SizedBox(height: 5,),
          Text(day),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
        child:  Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                    bar("Mon",),
                    bar("Tue",),
                    bar("Wed",),
                    bar("Thu",),
                    bar("Fri",),
                    bar("Sat",),
                    bar("Sun",),

              ],
            ),
          ),
        ),

    );
  }
}

