import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebaseProvider {
  FirebaseAuth? _firebaseAuth;

  AuthFirebaseProvider() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  User getUser() {
    //obtiene los datos del usuario que inicio sesion
    return _firebaseAuth!.currentUser!;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth!.currentUser;

    if (currentUser == null) {
      return false;
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth!
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      errorMessage = error.toString();
      return Future.error(errorMessage);
    }

    return true;
  }

  Future<bool> register(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth!
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      errorMessage = error.toString();
      return Future.error(errorMessage);
    }

    return true;
  }

  //cerrar sesion
  Future<List<void>> signOut() async {
    return Future.wait([
      _firebaseAuth!.signOut(),
    ]);
  }
}
