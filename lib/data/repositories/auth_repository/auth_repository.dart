import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/data/models/user_model/user_model.dart'
    as app_user;

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') != null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  Future<app_user.User?> signInWithGoogle() async {
    print("signin work");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("google user ${googleUser}");
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print("credentials ${credential}");

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      print("user cred ${userCredential}");
      final firebase_auth.User? user = userCredential.user;
      print("user ${user}");

      if (user == null) return null;

      print(" Google Sign-In successful, User ID: ${user.uid}");

      // 🔍 Fetch Firestore Data
      final docRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await docRef.get();

      print(" Firestore document snapshot: ${docSnapshot.data()}");

      app_user.User appUser;
      print("the user is ${user}");

      if (!docSnapshot.exists) {
        print(" User does not exist in Firestore. Creating new user...");

        appUser = app_user.User(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );

        await docRef.set(appUser.toMap());
      } else {
        final data = docSnapshot.data();
        if (data == null) {
          print('Firestore document is null');
          return null;
        }

        //  Check if Firestore returned a List instead of a Map
        if (data is! Map<String, dynamic>) {
          throw Exception(
              " Firestore returned unexpected format: ${data.runtimeType}");
          return null;
        }

        appUser = app_user.User.fromMap(data);
      }

      // ✅ Save user ID in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);

      return appUser;
    } catch (e, stacktrace) {
      print(' Error signing in with Google: $e');
      print(' Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<app_user.User?> getCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');
      if (userId == null) return null;

      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data();
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid Firestore user data format");
      }

      return app_user.User.fromMap(data);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }
}
