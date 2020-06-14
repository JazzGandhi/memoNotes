import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class Note{
  int id;
  String title;
  String description;
  String dateNoteAdded;
  int isNotificationOn=0;
  String timeNotif;
  String dateNotif;

  Note.nothing();
  Note({@required this.id, @required this.title,@required this.description,@required this.dateNoteAdded,this.isNotificationOn});

  Note.notifyUser({this.isNotificationOn,@required this.timeNotif,@required this.dateNotif});


  Note.all(this.id, this.title, this.description, this.dateNoteAdded,
      this.isNotificationOn, this.timeNotif, this.dateNotif);

  //ALL FUNCTIONS BELOW FOR FIRESTORE

  //YAHA PE ADD FUNCTIONS FOR FIRESTORE




  //all functions below for LOCAL DATABASE
  Future<Database> _databaseSQL;
  setUpLocalDatabase() async{
    _databaseSQL=openDatabase(
        join(await getDatabasesPath(),'personal_notes.db'),
        onCreate: (db,version){
          return db.execute(
              "CREATE TABLE NOTES(id INTEGER PRIMARY KEY,title TEXT,description TEXT,"
                  "dateNoteAdded TEXT,isNotificationOn INTEGER,timeNotif TEXT,dateNotif TEXT)",
          );
        },
        version: 1,
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "title":title,
      "description":description,
      "dateNoteAdded":dateNoteAdded,
      "isNotificationOn":isNotificationOn,
      "timeNotif":timeNotif,
      "dateNotif":dateNotif
    };
  }


  Future<void> insertNewNote(Note note) async{
    print("INSERTION PROCESS STARTED");
    final Database db=await _databaseSQL;
    await db.insert(
      "NOTES",
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("INSERTION PROCESS ENDED MAYBE SUCCESSFULLY");
  }

   Future<List<Map<String,dynamic>>> getAllNotes() async{
    final Database db=await _databaseSQL;
    var allNotes=await db.query("NOTES");
    return allNotes;
   }

   Future<List<Map<String,dynamic>>> getSpecficNote(List<int> id) async{
      final Database db=await _databaseSQL;
      var note=await db.query(
          "NOTES",
        where: "id = ?",
        whereArgs: id
      );
      return note;
   }
}