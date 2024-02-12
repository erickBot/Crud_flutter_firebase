import 'package:crud_flutter_firebase/src/models/user_model.dart';
import 'package:crud_flutter_firebase/src/providers/user_provider.dart';
import 'package:crud_flutter_firebase/src/service/authentication_service.dart';
import 'package:crud_flutter_firebase/src/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final AuthFirebaseProvider _authFirebaseProvider = AuthFirebaseProvider();
  final UserService _userService = UserService();
  ProgressDialog? _progressDialog;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isError = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context: context);
    checkUserIsLogin();
  }

  String? validateEmail(String value) {
    value = value.trim();
    if (emailController.text.isNotEmpty) {
      if (value.isEmpty) {
        isError = true;
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        isError = true;
        return 'Ingrese un email correcto';
      }
    }
    isError = false;
    return null;
  }

  String? validatePassword(String value) {
    value = value.trim();
    if (passwordController.text.isNotEmpty) {
      if (value.isEmpty) {
        isError = true;
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        isError = true;
        return 'La contraseña debe tener mínimo 6 caracteres';
      }
    }
    isError = false;
    return null;
  }

  void checkUserIsLogin() async {
    bool isLogin = _authFirebaseProvider.isSignedIn();

    if (isLogin) {
      user =
          await _userService.getByUserId(_authFirebaseProvider.getUser().uid);
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      });
    } else {
      return;
    }
  }

  void login() async {
    try {
      String email = emailController.text;
      String password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(msg: 'Debe lllenar todos los campos');
        return;
      }

      _progressDialog?.show(max: 100, msg: 'Espere un momento');

      bool res = await _authFirebaseProvider.login(email, password);

      if (res) {
        user =
            await _userService.getByUserId(_authFirebaseProvider.getUser().uid);

        if (user != null) {
          Provider.of<UserProvider>(context, listen: false)
              .setCurrentUser(user);

          Future.delayed(const Duration(seconds: 1), () {
            _progressDialog?.close();
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          });
        } else {
          _progressDialog?.close();
          Fluttertoast.showToast(msg: 'No se encontro usuario!');
          return;
        }
      } else {
        _progressDialog?.close();
        Fluttertoast.showToast(msg: 'Usuario no registrado!');
        return;
      }
    } catch (e) {
      _progressDialog?.close();
      Fluttertoast.showToast(msg: '$e');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 60),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          _email(),
          _password(),
          const SizedBox(height: 20),
          _buttonLogin(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No tienes cuenta?'),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, 'register'),
                    child: const Text(
                      ' Crear cuenta',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _email() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          setState(() {
            isEditingEmail = true;
          });
        },
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon:
              Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
          hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
          errorText:
              isEditingEmail ? validateEmail(emailController.text) : null,
        ),
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextField(
        controller: passwordController,
        obscureText: true,
        onChanged: (value) {
          setState(() {
            isEditingPassword = true;
          });
        },
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon:
              Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
          hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
          errorText: isEditingPassword
              ? validatePassword(passwordController.text)
              : null,
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return GestureDetector(
      onTap: login,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor,
        ),
        child: const Center(
            child: Text(
          'LOGIN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
