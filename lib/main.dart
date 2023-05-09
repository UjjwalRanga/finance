import 'package:finance/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './widgets/exp.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(

          primaryColorDark: Colors.black54,
          primarySwatch: Colors.deepPurple,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final List<List<String>> _exp =[
    ['Shoes','20.99','2022-08-28 18:13:56.845'],['bad','20.99','2022-08-28 18:13:56.845'],['mouse','20.99','2022-08-28 18:13:56.845']
  ];
  late List<List<String>> searchList;
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final searchController = TextEditingController();


  void _rem(int index){
   showDialog(context: context, builder: (_){
     return AlertDialog(

       content: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text("Title:    ${_exp[index][0]}\n"
                "Amount:  \$${_exp[index][1]}")
         ],
       ),
        title: const Center(child: Text("Are you sure?")),
       actions: [
         MaterialButton(onPressed: (){
           setState((){
             _exp.remove(_exp[index]);
           });
           Navigator.of(context).pop();
         }, child: const Text("Ok")),
         MaterialButton(onPressed: (){
           Navigator.of(context).pop();
         }, child: const Text("Cancel")),
       ],
     );
   });

  }

  void _bottomBar(){
    DateTime dateTime= DateTime.now();
    showModalBottomSheet(
        context: context, builder: (ctx){
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children:  [
            TextField(
              autofocus: true,
               decoration:const InputDecoration(labelText: "Title",),
               controller: titleController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
              controller: amountController,
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                Text("Date: ${DateFormat.yMMMEd().format(dateTime)}"),
                Expanded(child: Container()),
                MaterialButton(
                  onPressed: (){
                   showDatePicker(context: context, initialDate: dateTime, firstDate: DateTime(2019), lastDate: DateTime.now()).then((value){
                    if(value == null){
                      return;
                    }
                      dateTime = value;
                  });



                },child: const Text("choose Date"),)
              ],
            ),
            const SizedBox(height: 10,),
            MaterialButton(color: Theme.of(context).primaryColor,
                onPressed: (){
                  if(titleController.text == '' || amountController.text == '' ){
                    return;
                  }
                setState((){
                  List<String> l = [];
                  l.add(titleController.text);
                  l.add(amountController.text);
                  l.add(dateTime.toString());
                  _exp.add(l);

                });
                amountController.clear();
                titleController.clear();

                Navigator.of(context).pop();

            }, child: const Text("Add Expenses",style: TextStyle(color: Colors.white),))
          ],
        ),
      );

    });
  }

  void toggle(){
    setState((){
      searchList = _exp;
      search = !search;
    });
  }

  bool search = true;
  bool showChart = true;
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
          color: Colors.white,
        )
      ),
      floatingActionButton: (search != false) ? FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _bottomBar,
        child: const Icon(Icons.add),
      ): Container(),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //const SizedBox(height: 5,),
            if(query.orientation == Orientation.portrait ) SizedBox (
                width:MediaQuery.of(context).size.width,child: Card(
                elevation: 2,
                  child: ListTile(
                    visualDensity:const VisualDensity(horizontal: -4,vertical: -2),
                    onTap: toggle,
                    contentPadding: const EdgeInsets.all(0),
                    leading: (search == true) ? IconButton(onPressed: toggle,icon:const Icon(Icons.search),) :
                                            IconButton(onPressed: toggle,icon:const Icon(Icons.arrow_back),) ,
                    title: (search == true) ? const Text("Search in Finance",style: TextStyle(fontSize: 19,color: Colors.black45),) :
                                            TextField(
                                              onChanged: (c){
                                                setState((){
                                                searchList = _exp.where((element) => element[0].toLowerCase().startsWith(c.toLowerCase())).toList();
                                                });
                                              },
                                              controller: searchController,
                                              autofocus: true,
                                              style: const TextStyle(fontSize: 19),
                                              decoration: const InputDecoration(border: InputBorder.none),),
                    trailing: (search == true) ? IconButton(onPressed: (){},icon:const Icon(Icons.more_vert),):
                                              IconButton(onPressed: (){},icon:const Icon(Icons.search),) ,
                  ),
                )
            ),
            //const SizedBox(height: 5,),
            (query.orientation == Orientation.landscape ) ? Card(
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Show Chart",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                  Switch(value: showChart, onChanged: (val){
                    setState(
                        (){
                          showChart = !showChart;
                        }
                    );
                  }),
                ],
              ),
            ) : Container(),
            if(query.orientation == Orientation.landscape ) const SizedBox(height: 5,),

            if(query.orientation == Orientation.portrait ) (search == true ) ? Chart(exp: _exp): Container(),
            if(query.orientation == Orientation.landscape && showChart ) (search == true ) ? Chart(exp: _exp): Container(),

            if(query.orientation == Orientation.portrait ) (search == true) ? Expanded(
              //height: MediaQuery.of(context).size.height*0.6,
                child: ListView.builder(
                 itemBuilder: (context,index){
                   return Exp(amount: double.parse(_exp[index][1]).toStringAsFixed(2),title: _exp[index][0],fun: _rem,index: index,time:_exp[index][2] ,);
                 },
                  itemCount: _exp.length,

            ),

            ) : (searchList.isEmpty==false) ? Expanded(child: ListView.builder(
                itemBuilder: (context,index){
                  return Card(
                      elevation: 3,
                      child: ListTile(
                          visualDensity: const VisualDensity(vertical: 2),
                          leading: CircleAvatar(

                              backgroundColor: Theme.of(context).primaryColor,radius: 25,
                              child: FittedBox(child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text("\$${searchList[index][1]}",style:const TextStyle(color: Colors.white),),
                              ),)
                          ),
                          trailing:  Text(
                            DateFormat.yMMMEd().format(DateTime.parse(searchList[index][2])).toString(),
                            style: const TextStyle(color: Colors.grey,fontSize: 16),
                          ),
                          title: Text(
                            searchList[index][0],
                            style: const TextStyle(fontSize: 20),)
                      )
                  );
                },
                itemCount: searchList.length,

              ),): Expanded(child: Text("NO RESULT FOUND!")),
            if(query.orientation == Orientation.landscape && !showChart ) Expanded(child: ListView.builder(
              itemBuilder: (context,index){
                return Card(
                    elevation: 3,
                    child: ListTile(
                        visualDensity: const VisualDensity(vertical: 2),
                        leading: CircleAvatar(

                            backgroundColor: Theme.of(context).primaryColor,radius: 25,
                            child: FittedBox(child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("\$${searchList[index][1]}",style:const TextStyle(color: Colors.white),),
                            ),)
                        ),
                        trailing:  Text(
                          DateFormat.yMMMEd().format(DateTime.parse(searchList[index][2])).toString(),
                          style: const TextStyle(color: Colors.grey,fontSize: 16),
                        ),
                        title: Text(
                          searchList[index][0],
                          style: const TextStyle(fontSize: 20),)
                    )
                );
              },
              itemCount: searchList.length,

            ),),
          ],
        ),
      ),
    );
  }
}

