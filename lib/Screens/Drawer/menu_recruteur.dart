
import 'package:chercher_job/Screens/Drawer/profilScreen.dart';
import 'package:chercher_job/Screens/Drawer/profile_recruteur.dart';
import 'package:chercher_job/constants.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../constants.dart';
import 'main_screen.dart';
import 'notificationScreen.dart';
import 'package:flutter/widgets.dart';

class MenuRecruteur extends StatefulWidget {
  const MenuRecruteur({super.key});

  @override
  State<MenuRecruteur> createState() => _MenuRecruteurState();
}

class _MenuRecruteurState extends State<MenuRecruteur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF6F35A5),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                padding: EdgeInsets.only(top: 20.0),
                child: DrawerHeader(
                    child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: 35,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "surname",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Text(
                      "surname@gmail.com",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MainScreen()));
                  },
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.add_alert, color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Notification_Alert',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                   onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NotificationScreen() ));
                  },
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.white),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Profil',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                   onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfileRecruteur()));
                  },
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
