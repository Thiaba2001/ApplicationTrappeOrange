import 'package:flutter/material.dart';
import 'package:trappe_orange/views/details/widgets/montext.dart';
import 'package:trappe_orange/views/details/widgets/numerotrappe.dart';
import 'package:trappe_orange/service/getid.dart';

class MyDetails extends StatelessWidget {
  final String login;
  final EnregistrerDetails enregistrerDetails;
  const MyDetails(
      {Key? key, required this.login, required this.enregistrerDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Ajout Details'),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/chaine.jpeg',
                  width: 200,
                  height: 150,
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                ),
                const MyText(),
                const SizedBox(
                  width: 20,
                  height: 20,
                ),
                NumeroTrappe(
                  login: login,
                  enregistrerDetails: EnregistrerDetails(),
                ),
                const SizedBox(
                  width: 10,
                  height: 20,
                ),
              ]),
        )));
  }
}
