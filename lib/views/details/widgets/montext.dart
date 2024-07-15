import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 350,
      height: 100,
      child: Card(
        color: Colors.orange,
        shadowColor: Color.fromARGB(255, 26, 169, 31),
        elevation: 5,
        child: Text(
          'Veuilliez Renseigner les details ci dessous.',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
