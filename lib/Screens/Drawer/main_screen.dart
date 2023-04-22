import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter/widgets.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            if (ZoomDrawer.of(context)!.isOpen()) {
              ZoomDrawer.of(context)!.close();
            } else {
              ZoomDrawer.of(context)!.open();
            }
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Candidat',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text('Candidat'),
      ),
    );
  }
}
