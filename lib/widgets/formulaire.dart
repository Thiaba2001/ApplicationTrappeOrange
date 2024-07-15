import 'package:flutter/material.dart';
import 'package:trappe_orange/service/authetification.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('LoginForm');

class LoginForm extends StatefulWidget {
  final Function(bool) onAuthenticationSuccess;
  final Function(String) onlogincallBack;

  const LoginForm({
    Key? key,
    required this.onAuthenticationSuccess,
    required this.onlogincallBack,
  }) : super(key: key);

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true; // État initial pour masquer le mot
  bool isAuthenticated = false;

  Future<void> authenticateAndCallback() async {
    final login = loginController.text.trim();
    final password = passwordController.text.trim();
    print("Login avant authentification: $login");

    final isUserAuthenticated = await AuthService.authenticate(login, password);

    if (isUserAuthenticated) {
      widget.onlogincallBack(login);
      widget.onAuthenticationSuccess(true);
      print('Authentification résuissi ! Login recupéré: $login');
      _formKey.currentState?.reset();
    } else {
      print("Erreur d'authentification"); // Ajoutez cette ligne pour déboguer
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          width: 300,
          height: 50,
          child: TextFormField(
            controller: loginController,
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 20),
              hintText: 'Login',
              prefixIcon: Icon(
                Icons.login,
                color: Colors.black54,
              ),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return ('Veuillez entrer votre login');
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 40,
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(30)),
          width: 300,
          height: 50,
          child: TextFormField(
            controller: passwordController,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: 'Mot de passe',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black),
              prefixIcon: Icon(Icons.password, color: Colors.black54),
              suffixIcon: IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText; // Toggle the _obscureText state
                  });
                },
              ),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return ('Veuillez entrer votre mot de passe');
              }
              return null;
            },
          ),
        ),
        const SizedBox(
          width: 20,
          height: 30,
        ),
        Container(
          width: 250,
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          child: InkWell(
            highlightColor: Colors.green,
            splashColor: Colors.green,
            radius: 200,
            child: ElevatedButton(
              onPressed: isAuthenticated ? null : authenticateAndCallback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                elevation: 7,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "S'authentifier",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
