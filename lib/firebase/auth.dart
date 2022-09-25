import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_1/Extras/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FbUser _userFromFirebaseUser(User user) {
    return user != null ? FbUser(uid: user.uid) : null;
  }

  //GET UID
  // Future<String> getCurrentUID() async {
  //   return (await _auth.currentUser).uid;
  // }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}

