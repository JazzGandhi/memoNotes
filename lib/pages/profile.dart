import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterrequirements/pages/homescreen.dart';
import 'package:flutterrequirements/functions/userAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';

class ProfilePage extends StatefulWidget {
  bool firstTime;

  ProfilePage({this.firstTime});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var obj = new UserAuth();
  bool firstTime;
  bool hasProfileCreated = false;
  TextEditingController textController;
  final db = Firestore.instance;
  final formKey = GlobalKey<FormState>();
  String username = "";
  final lis = [
    "profile1.png",
    "profile2.png",
    "profile3.png",
    "profile4.png",
    "profile5.png",
    "profile6.png"
  ];
  int currentIndex = 0;
  double width;

  addToDb(String email) async {
    var groups = new List<Map<String, String>>();
    await db.collection("USERS").document(email).setData({
      "username": username,
      "img": currentIndex,
      "groups": groups,
      "docID": email
    });
  }

  logUserIn(context) async {
    String emailID = await obj.getCurrentUserEmail();
    print('USER KA EMAIL ID IS ');
    print(emailID);
    if (emailID != null) {
      await db.collection("USERS").document(emailID).get().then((docSnap) {
        if (docSnap == null || !docSnap.exists) {
          //user doesnt exist
          //create new document on firebase for a new user
          storeDocIDLocally();
          addToDb(emailID);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          //user already has an account on our app,just log him in and store data on localPref
          storeDocIDLocally();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }




  Widget img(int value) {
    return Container(
      width: 300,
      height: 300,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        child: ClipOval(
          child: Image.asset(
            "assets/images/" + lis[value % 6],
          ),
        ),
      ),
    );
  }

  storeDocIDLocally() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setInt('imageNumber', currentIndex);
  }

  createUser(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      logUserIn(context);
    }
  }

  updateInDb(context) async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      var prefs = await SharedPreferences.getInstance();
      String docID = prefs.getString('docID');

      if (docID == null)
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Sorry,couldn't update data!",
          ),
          duration: Duration(milliseconds: 1000),
        ));
      else {
        storeDocIDLocally();

        await db
            .collection("USERS")
            .document(docID)
            .updateData({"username": username, "img": currentIndex});

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasProfileCreated)
      return HomePage();
    else
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Color.fromRGBO(40, 49, 59, 1),
          appBar: AppBar(
            title: Text("MemoNotes"),
          ),
          body: Container(
            margin: EdgeInsets.only(left: 3, right: 15, top: 15, bottom: 15),
            padding: EdgeInsets.only(left: 3, right: 15, top: 15, bottom: 15),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Your Profile Page:",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color.fromRGBO(114, 133, 165, 1),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: 0.2,
                  ),
                ),
                Text(
                  "Your Avatar:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(114, 133, 165, 1),
                  ),
                  textAlign: TextAlign.left,
                ),
                SwipeDetector(
                  child: img(currentIndex),
                  onSwipeLeft: () {
                    setState(() {
                      currentIndex = (currentIndex + 1) % 6;
                    });
                  },
                  onSwipeRight: () {
                    setState(() {
                      currentIndex = (currentIndex - 1) % 6;
                    });
                  },
                ),
                Text(
                  "Swipe to change avatar",
                  style: TextStyle(color: Colors.white),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: textController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.person),
                          hintText: "Enter username",
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(114, 133, 165, 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (val) {
                          if (val.length <= 2)
                            return "Username seems to be too short";
                          else
                            return null;
                        },
                        onSaved: (val) {
                          username = val;
                        },
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext con) {
                    return FlatButton(
                      child: Text(
                        "SAVE",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () =>
                          firstTime ? createUser(con) : updateInDb(con),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  checkIfDataExists() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('docID'))
      setState(() {
        hasProfileCreated = true;
      });
    textController = new TextEditingController();
  }

  bringDataFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("username")) {
      setState(() {
        username = prefs.getString('username');
        textController = new TextEditingController(text: username);
        currentIndex = prefs.getInt('imageNumber') ?? 0;
        print("USERNAME:" + username);
        print(currentIndex);
        print("END BRING DATA FUNC");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstTime = widget.firstTime;
//    if(firstTime)
//      checkIfDataExists();
    if(firstTime)
      textController=new TextEditingController();
    else
      bringDataFromStorage();
  }
}
