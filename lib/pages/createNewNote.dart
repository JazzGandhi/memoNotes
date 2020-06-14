import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CreateNewNote extends StatefulWidget {
  @override
  _CreateNewNoteState createState() => _CreateNewNoteState();
}

class _CreateNewNoteState extends State<CreateNewNote> {

  saveLocally(){

  }
  String titleNote;
  String descriptionNote;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        backgroundColor: Color.fromRGBO(40, 49, 59, 1),
        appBar: AppBar(
          title: Text("MemoNotes",style: TextStyle(fontStyle: FontStyle.italic),),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(5, 20, 30, 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.3,
                ),
              ),

              Text("Title:",style: TextStyle(color: Colors.white,fontSize: 25),),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.purpleAccent)),
                  prefixIcon: Icon(Icons.text_fields),
                  hintText: "Enter the title",
                  prefixText: "  "//to show gap between icon and title
                ),
                onChanged: (val)=>titleNote=val,
              ),

              Flexible(
                child: FractionallySizedBox(
                  heightFactor: 0.1,
                ),
              ),
              Text("Description:",style: TextStyle(color: Colors.white,fontSize: 25),),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.purpleAccent)),
                    prefixIcon: Icon(Icons.description),
                    hintText: "Enter the description",
                    prefixText: "  "//to show gap between icon and title
                ),
                onChanged: (val)=>descriptionNote=val,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  child: Text("SAVE THIS NOTE"),
                  color: Colors.greenAccent,
                  onPressed: ()=>saveLocally(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
