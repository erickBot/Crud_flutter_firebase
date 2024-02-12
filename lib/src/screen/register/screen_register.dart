import 'package:crud_flutter_firebase/src/models/user_model.dart';
import 'package:crud_flutter_firebase/src/service/authentication_service.dart';
import 'package:crud_flutter_firebase/src/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final AuthFirebaseProvider _authFirebaseProvider = AuthFirebaseProvider();
  final UserService _userService = UserService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  //

  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isError = false;

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

  void register() async {
    try {
      String name = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        Fluttertoast.showToast(msg: 'Debe llenar todos los campos');
        return;
      }

      if (password.length < 6) {
        Fluttertoast.showToast(msg: 'La clave debe tener minimo 6 caracteres');
        return;
      }

      bool res = await _authFirebaseProvider.register(email, password);

      if (res) {
        UserModel user = UserModel(
          id: _authFirebaseProvider.getUser().uid,
          name: name,
          email: email,
        );

        await _userService.create(user);

        Fluttertoast.showToast(
            msg: 'Usuario registrado!!, ahora inicie sesion');
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      } else {
        Fluttertoast.showToast(msg: 'Ocurrio un error!');
        return;
      }
    } catch (e) {
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
              'Registro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          _email(),
          _password(),
          _name(),
          const SizedBox(height: 20),
          _buttonCreate(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ya tienes cuenta?'),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      ' Ir a Login',
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

  Widget _name() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: 'Nombre de usuario',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon:
              Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
          hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buttonCreate() {
    return GestureDetector(
      onTap: register,
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
          'REGISTRAR',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
