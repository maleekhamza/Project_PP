import 'package:chercher_job/Screens/Drawer/menu_recruteur.dart';
import 'package:chercher_job/models/Candidat.dart';
import 'package:chercher_job/models/Recruteur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';


import 'main_screen.dart';
import 'menu_screen.dart';
import 'package:flutter/widgets.dart';
class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  
  final zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: const MenuRecruteur(),
      mainScreen: Recruteur(id:'id'),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      menuBackgroundColor: Color.fromARGB(255, 203, 177, 196),
      slideWidth: MediaQuery.of(context).size.width * 0.68,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
    
  }
}
