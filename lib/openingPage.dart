import 'package:flutter/material.dart';
import 'package:flutterrequirements/pages/homescreen.dart';
import 'package:flutterrequirements/pages/profile.dart';
import 'package:flutterrequirements/functions/userAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpeningPage extends StatefulWidget {
  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  bool isProfileSet = false;
  var obj=new UserAuth();
  SharedPreferences prefs;


  storeEmail(context,email){
    prefs.setString('docID', email);
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(firstTime: true,)));
  }
  signInUser(context)  async{
    String tp=await obj.signInWithGoogle();
      if (tp == null) {
        print("TP IS NULL");
      }
      else {
        String emailID = await obj.getCurrentUserEmail();
        storeEmail(context,emailID);
      }

  }

  @override
  Widget build(BuildContext context) {
    if (isProfileSet)
      return HomePage();
    else
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("MemoNotes"),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.4,
                  ),
                ),
                Container(
                    height: 200,
                    width: 200,
                    child: FlutterLogo()
                ),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.1,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Welcome to  ",style: TextStyle(color: Colors.black)),
                      TextSpan(text: "MemoNotes",style: TextStyle(color: Colors.lightBlue,fontStyle: FontStyle.italic,fontSize: 32)),
                    ],
                  ),
                  style: TextStyle(fontSize: 25),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.1,
                  ),
                ),
                Container(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image.asset("assets/images/gIMG.jpg"),
                      ),
                      Builder(
                        builder: (context){
                          return RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign In With Google",
                            ),
                            onPressed: () => signInUser(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  checkIfFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("username"))
      setState(() {
        isProfileSet = true;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFirstTime();
  }
}
