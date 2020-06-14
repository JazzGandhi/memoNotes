import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class UserAuth{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<String> signInWithGoogle() async{
    print("ENTER FUNCTION SIGNIN WITH GOOGLE");
    final GoogleSignInAccount account=await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
    await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );

    final AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    print("AUTHENTICATING USER ON FIREBASE NOW");
    if(user.isAnonymous || await user.getIdToken() == null)
      return null;
    final FirebaseUser currentUser = await auth.currentUser();
    if(user.uid==currentUser.uid)
      return "DONE";
    else
      return null;
  }

  Future<bool> checkIfUserLoggedIn() async{
    var user=await auth.currentUser();
    if(user==null)
        return false;
    else
      return true;
  }

  signOut() async{
    await auth.signOut();
  }
  Future<String> getCurrentUserEmail() async{
    var user= await auth.currentUser();
    return user.email;
  }
}