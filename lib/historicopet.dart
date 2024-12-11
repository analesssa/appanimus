import 'package:flutter/material.dart';

class Historicopet extends StatelessWidget {
  const Historicopet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Pets'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Text(
          'Histórico de Pets',
          style: TextStyle(fontSize: 24),
        ),
      )
  );
  }
}