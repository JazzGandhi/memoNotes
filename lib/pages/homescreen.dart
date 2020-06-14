
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterrequirements/pages/displayPersonalNotes.dart';
import 'package:flutterrequirements/pages/showFamilyNotes.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final db=Firestore.instance;
  List<Map<String,String>> groups;
  bool isRetrieved=false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initializeForNotifications() async{
    flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();//onDidReceiveLocalNotification: onDidReceiveLocalNotification
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    //payload is kinda the id which we might want
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(payload),));
    }

  }

  showNotificationInstantly(String payload) async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'idk what this is');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'Title', 'Body of notification', platformChannelSpecifics,
        payload: payload);
  }



  getUserData() async{
    var prefs=await SharedPreferences.getInstance();
    String docID=prefs.getString('docID');
    await db.collection("USERS").document(docID).get().then((docSnap){
        groups=new List.from(docSnap.data["groups"]);
        setState(() {
          isRetrieved=true;
        });
    });
  }

  Widget showGroup(){
    if(groups==null || groups.length==0){
       return Text("Sorry,you are not present in any family group currently");
    }
    else{
      return Flexible(
        child: FractionallySizedBox(
          heightFactor: 0.7,
          child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context,ind){
                return Card(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                  ),
                  child: InkWell(
                    splashColor: Colors.lightBlue.withAlpha(40),
                    child: ListTile(
                      title: Text(groups[ind]["name"],style: TextStyle(color: Colors.white),),
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowFamNotes(groups[ind]))),
                    ),
                  ),
                );
              }
          ),
        ),
      );
    }
  }

  Widget loadingDataWidget(){
    return Center(
      child: Column(
        children: <Widget>[
            Text("Waiting to load from database",style: TextStyle(color: Colors.white),),
            Container(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(40, 49, 59, 1),
        appBar: AppBar(
          title: Text("MemoNotes"),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 10),
            padding: EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 10),
            child: Column(
              children: <Widget>[
                RaisedButton(
                  child: Text("SHOW NOTIFICATION "),
                  onPressed: ()=>showNotificationInstantly("This is payload ie ID type"),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.2,
                    child: Builder(
                      builder: (context){
                        return Center(
                          child: RaisedButton(
                            child: Text("Show my notes"),
                            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> DisplayPersonalNotes())),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.1,
                  ),
                ),
                isRetrieved==false
                ?
                loadingDataWidget()

                :

                showGroup(),

            ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    initializeForNotifications();
  }
}
