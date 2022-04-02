import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/resources/storage_methods.dart';

// class AuthMethods {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<model.User> getUserDetails() async {
//     User currentUser = _auth.currentUser!;

//     DocumentSnapshot snap =
//         await _firestore.collection('users').doc(currentUser.uid).get();
//     return model.User.fromSnap(snap);
//   }

//   // sign up user
//   Future<String> signUpUser({
//     required String email,
//     required String password,
//     required String username,
//     required String bio,
//     required Uint8List file,
//   }) async {
//     String res = "Some error occurred";
//     try {
//       if (email.isNotEmpty ||
//           password.isNotEmpty ||
//           username.isNotEmpty ||
//           bio.isNotEmpty) {
//         // register user
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);

//         String photoUrl = await StorageMethods()
//             .uploadImageToStorage('profilePics', file, false);

//         // add user to our database

//         model.User user = model.User(
//           username: username,
//           uid: cred.user!.uid,
//           email: email,
//           bio: bio,
//           photoUrl: photoUrl,
//           following: [],
//           followers: [],
//         );

//         await _firestore.collection('users').doc(cred.user!.uid).set(
//               user.toJson(),
//             );

//         res = "success";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   //logging in user

//   Future<String> loginUser({
//     required String email,
//     required String password,
//   }) async {
//     String res = "Some error occurred";

//     try {
//       if (email.isNotEmpty || password.isNotEmpty) {
//         await _auth.signInWithEmailAndPassword(
//             email: email, password: password);
//         res = "success";
//       } else {
//         res = "Please enter all the fields";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }
// }

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
