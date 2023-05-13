import 'package:flutter/material.dart';
import 'Mapa.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Mapas",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      body: Mapita(),
    );
  }
}
