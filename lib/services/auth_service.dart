import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tic_tac_shift/models/user_model.dart';

import 'database.dart';

/*
* This class is used for the developer to access and handle firebase sign in services.
*/
class AuthService {
  //initialize firebase sign in service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*
  * Detects and Keeps track if a user is signed in or not.
  * It uses a firebase defined stream.
  * Returns a response each time the user logsIn or out(combined with a listener).
  * Return a user object if user signed in and returns null if signed out.
  */
  Stream<UserModel?> get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseToUserModel(user));
  }

  //create a UserModel object based on User <-(User the Firebase type)
  //convert firebase User object to my UserModel object
  UserModel? _userFromFirebaseToUserModel(User? firebaseUser) {
    return (firebaseUser != null)
        ? UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            username: firebaseUser.displayName)
        : null;
  }

  /*
  * This method is to sign in anonymously.
  * It creates an instance of my UserModel object.
  */
  Future<UserModel?> signInAnon() async {
    try {
      // get user credentials
      UserCredential anonUserInfo = await _auth.signInAnonymously();
      //get user info
      User? firebaseUser = anonUserInfo.user;
      return _userFromFirebaseToUserModel(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in with email and pass
  Future? signInEmailnPassword(String email, String password) async {
    try {
      UserCredential userInfo = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = userInfo.user;
      return _userFromFirebaseToUserModel(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register with email and pass
  Future? registerEmailnPassword(
      String username, String email, String password) async {
    try {
      bool isUsernameTaken = await DatabaseService().isUsernameTaken(username);
      if (isUsernameTaken) {
        return 'Username already taken';
      }
      //creating new user with email and password
      UserCredential userInfo = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? firebaseUser = userInfo.user;
      await firebaseUser!.updateProfile(displayName: username);
      await firebaseUser.reload();
      //adding user to database
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(username, email);

      return _userFromFirebaseToUserModel(firebaseUser);
    } catch (e) {
      print(e.toString());
      return "Invalid email address or Already taken";
    }
  }

//sign out
  Future? signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
