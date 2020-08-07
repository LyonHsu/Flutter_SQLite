

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Dog.dart';
import 'LyonDatabase.dart';

class AddDogActivity extends StatelessWidget {
  // This widget is the root of your application.
  AddDogActivity({Key key, this.title,this.lyonDataBase}) : super(key: key);
  final String title;
  final LyonDataBase lyonDataBase;
  @override
  Widget build(BuildContext context) {
    return  AddDogFragment(title:'Add Dog',lyonDataBase:lyonDataBase);
  }
}

class AddDogFragment extends StatefulWidget {
  AddDogFragment({Key key, this.title,this.lyonDataBase}) : super(key: key);
  final String title;
  final LyonDataBase lyonDataBase;
  @override
  _AddDogFragment createState() => _AddDogFragment(title: title,lyonDataBase:lyonDataBase);
}

class _AddDogFragment extends State<AddDogFragment> {
  final String title;
  final LyonDataBase lyonDataBase;
  int dogAges = 3;
  int dogId = 0;
  String dogs = '';
  _AddDogFragment({this.title,this.lyonDataBase});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData().then((value) {
      setState(() {
        this.dogs=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:
      SingleChildScrollView(
          child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection : Axis.vertical,
                  child:  Text(
                    '${dogs}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ]
          )

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDogOK,
        tooltip: 'Increment',
        backgroundColor: Color(0xFFfbd60b),
        child: Icon(
          Icons.check,
          color:Colors.blue,
          size: 40,
        ),
      ),
    );
  }

  void _addDogOK() async{

    setState(() {
      dogAges++;
      dogId++;
      print('dogId : $dogId ,dogAges : $dogAges,');
    });
    var fido = Dog(
      id: dogId,
      name: 'Fido',
      age: dogAges,
    );
    await lyonDataBase.insertDog(fido);
    getData().then((value) {
      setState(() {
        this.dogs=value;
      });
    });
  }

  Future<String> getData() async{
    List<Dog> dogs =(await lyonDataBase.dogs()) ;
    setState(() {
      dogAges = dogs.last.age;
      dogId = dogs.last.id;
    });
    print('dogId : $dogId ,dogAges : $dogAges, AddDogActivity $dogs');
    return dogs.toString();
  }
}