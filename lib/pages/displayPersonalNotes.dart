import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterrequirements/ModelClasses/note.dart';
import 'package:flutterrequirements/pages/createNewNote.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DisplayPersonalNotes extends StatefulWidget {
  @override
  _DisplayPersonalNotesState createState() => _DisplayPersonalNotesState();
}

class _DisplayPersonalNotesState extends State<DisplayPersonalNotes> {

  var obj=Note.nothing();
  bool isDataReceived=false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("MemoNotes",style: TextStyle(fontStyle: FontStyle.italic),),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Create Note",
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNewNote())
          ),
        ),
      ),
    );
  }

  receiveLocalData() async{
    await obj.setUpLocalDatabase();
    var allNotes=await obj.getAllNotes();
    setState(() {
      isDataReceived=true;
    });
    print("BROUGHT ALL NOTES HERE BRUHHHHHH");
    print(allNotes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiveLocalData();

  }
}
