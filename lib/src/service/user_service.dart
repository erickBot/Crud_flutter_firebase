import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_flutter_firebase/src/models/user_model.dart';

class UserService {
  CollectionReference? _ref;
  UserModel? user;

  UserService() {
    _ref = FirebaseFirestore.instance.collection('Users');
  }

  Future<void> create(UserModel user) async {
    String errorMessage;

    try {
      return _ref!.doc(user.id).set(user.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<UserModel?> getByUserId(String id) async {
    DocumentSnapshot document = await _ref!.doc(id).get();

    if (document.exists) {
      user = UserModel.fromJson(document.data() as Map<String, dynamic>);
      return user;
    }
    return null;
  }

  //actualizar informacion en firebase
  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref!.doc(id).update(data);
  }

  //obtener datos en tiempo real
  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref!.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<List<UserModel>> getAll() async {
    QuerySnapshot querySnapshot = await _ref!.get();

    var allData = querySnapshot.docs.map((e) => e.data());

    List<UserModel> users = [];

    for (var user in allData) {
      users.add(UserModel.fromJson(user as Map<String, dynamic>));
    }

    return users;
  }

  Future<void> delete(String id) {
    return _ref!.doc(id).delete();
  }
}
