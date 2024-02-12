import 'package:crud_flutter_firebase/src/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get currentUser => _user;

  void setCurrentUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }
}
