import 'package:flutter/material.dart';
import 'package:trappe_orange/service/getid.dart';
import 'package:trappe_orange/widgets/formulaire.dart';
import 'package:trappe_orange/views/details/details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String login = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 246, 144, 12),
        leading: const Icon(Icons.person),
        title: const Text('Page Authentification '),
        actions: const <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/chaine.jpeg',
              width: 200,
              height: 200,
            ),
            const SizedBox(
              width: 5,
              height: 3,
            ),
            const Text(
              'Trappe ',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const Text(
              'Orange',
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.orange,
                  height: 0.8),
            ),
            const SizedBox(
              height: 30,
              width: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Welcome to',
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, height: 1),
              ),
            ),
            Image.asset(
              'assets/images/chaine2.PNG',
              width: 500,
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: LoginForm(
                onlogincallBack: (loginValue) {
                  setState(() {
                    login = loginValue;
                    print("Login recupéré: $login");
                  });
                },
                onAuthenticationSuccess: (bool isAuthenticated) {
                  if (isAuthenticated) {
                    if (login.isNotEmpty) {
                      print("Login:$login");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyDetails(
                              login: login,
                              enregistrerDetails: EnregistrerDetails(),
                            ),
                          ));
                    } else {
                      print("Erreur: login est vide ");
                    }
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/boule orange.jpg',
                  width: 90,
                  height: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
