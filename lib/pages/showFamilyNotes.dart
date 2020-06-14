import 'package:flutter/material.dart';

class ShowFamNotes extends StatefulWidget {
  var group;
  ShowFamNotes(this.group);
  @override
  _ShowFamNotesState createState() => _ShowFamNotesState(group);
}

class _ShowFamNotesState extends State<ShowFamNotes> {
  Map<String,String> group;
  _ShowFamNotesState(this.group);

  getNotes(){

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }
}
