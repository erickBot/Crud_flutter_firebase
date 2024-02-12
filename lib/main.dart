import 'package:crud_flutter_firebase/src/providers/user_provider.dart';
import 'package:crud_flutter_firebase/src/screen/home/screen_home.dart';
import 'package:crud_flutter_firebase/src/screen/login/screen_login.dart';
import 'package:crud_flutter_firebase/src/screen/register/screen_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Crud',
        initialRoute: 'login',
        routes: {
          'login': (context) => const ScreenLogin(),
          'register': (context) => const ScreenRegister(),
          'home': (context) => const ScreenHome(),
        },
      ),
    );
  }
}
