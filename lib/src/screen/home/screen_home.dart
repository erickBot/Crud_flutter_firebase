import 'package:crud_flutter_firebase/src/models/user_model.dart';
import 'package:crud_flutter_firebase/src/providers/user_provider.dart';
import 'package:crud_flutter_firebase/src/service/authentication_service.dart';
import 'package:crud_flutter_firebase/src/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final UserService _userService = UserService();
  final AuthFirebaseProvider _authFirebaseProvider = AuthFirebaseProvider();
  UserModel? user;
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    setState(() {});
  }

  Future<List<UserModel>> getUsers() async {
    return await _userService.getAll();
  }

  void delete(UserModel uder) async {
    await _userService.delete(user!.id!);

    Fluttertoast.showToast(msg: 'Usuario eliminado!');
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Usuarios registrados'),
          actions: [
            IconButton(
                onPressed: () async {
                  await _authFirebaseProvider.signOut();
                  //
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'login', (route) => false);
                  });
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _cardUser(snapshot.data![index]),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          },
        ));
  }

  Widget _cardUser(UserModel user) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(width: .5, color: Colors.black54),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? '',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(user.email ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
          IconButton(
              onPressed: () => delete(user),
              icon: const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}
