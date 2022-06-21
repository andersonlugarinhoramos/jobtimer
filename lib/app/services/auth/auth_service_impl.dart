import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_timer/app/core/database/database.dart';

import './auth_service.dart';

class AuthServiceImpl implements AuthService {
  final Database _database;

  AuthServiceImpl({
    required Database database,
  }) : _database = database;

  @override
  Future<void> signIn() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    final database = await _database.openConnection();
    await database.writeTxn((isar) => database.clear());
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  @override
  Future<String> email() async {
    String userEmail = '';
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null || user!.email != null) {
        userEmail = user.email!;
      }
    });

    return userEmail;
  }

  @override
  Future<String> photoUrl() async {
    String photoUrl = '';
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null || user!.photoURL != null) {
        photoUrl = user.photoURL!;
      }
    });

    return photoUrl;
  }

  @override
  Future<String> userName() async {
    String userName = '';
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null || user!.displayName != null) {
        userName = user.displayName!;
      }
    });

    return userName;
  }
}
