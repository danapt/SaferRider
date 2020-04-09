//system classes
import 'dart:async';
import 'dart:convert';
//packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//custom classes
import 'package:saferrider/models/user.dart';
import 'package:saferrider/global/global.dart';

class Auth {
  static Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
//    await user.sendEmailVerification();
    return user.uid;
  }


  static void addUserSettingsDB(User user) async {
    print(user.user_id+"check for google login");
    await checkUserExist(user.user_id).then((value)async{
      if (!value) {
        await Firestore.instance
            .document("users/${user.user_id}")
            .setData(user.toJson());
        await storeUserLocal(user);
        current_user = user;
      } else {
        print("user ${user.email} exists");
        await getUserFirestore(user.user_id).then((user)async{
          await Auth.storeUserLocal(user);
          current_user = user;
        });
      }
    });
  }

  static Future<bool> checkUserExist(String user_id) async {
    bool exists = false;
    try {
      await Firestore.instance.document("users/$user_id").get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });
      return exists;
    } catch (e) {
      return false;
    }
  }

  static Future<User> getUserFirestore(String user_id) async {
    if (user_id != null) {
      return Firestore.instance
          .collection('users')
          .document(user_id)
          .get()
          .then((documentSnapshot) => User.fromJson(documentSnapshot.data));
    } else {
      print('firestore user_id can not be null');
      return null;
    }
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  static Future<String> storeUserLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = json.encode(user.toJson());
    await prefs.setString('user', storeUser);
    return user.user_id;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = User.fromJson(json.decode(prefs.getString('user')));
      //print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  static Future<void> updateProfile(User user)async{
    print('${user.user_id}-=-=-=-=-=-=-=-=-=');
    await Firestore.instance.collection('users').document(user.user_id).updateData(user.toJson());
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }

/*static Stream<User> getUserFirestore(String user_id) {
    print("...getUserFirestore...");
    if (user_id != null) {
      //try firestore
      return Firestore.instance
          .collection("users")
          .where("user_id", isEqualTo: user_id)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return User.fromDocument(doc);
        }).first;
      });
    } else {
      print('firestore user not found');
      return null;
    }
  }*/

/*static Stream<Settings> getSettingsFirestore(String settingsId) {
    print("...getSettingsFirestore...");
    if (settingsId != null) {
      //try firestore
      return Firestore.instance
          .collection("settings")
          .where("settingsId", isEqualTo: settingsId)
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.documents.map((doc) {
          return Settings.fromDocument(doc);
        }).first;
      });
    } else {
      print('no firestore settings available');
      return null;
    }
  }*/
}
