import 'package:chercher_job/Screens/Drawer/profilScreen.dart';
import 'package:chercher_job/Screens/Drawer/profile_recruteur.dart';
import 'package:chercher_job/constants.dart';
import 'package:chercher_job/models/Candidat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../constants.dart';
import 'main_screen.dart';
import 'notificationScreen.dart';
import 'package:flutter/widgets.dart';

class MenuScreen extends StatefulWidget {
  
  

  const MenuScreen({super.key});
  

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
 final user = FirebaseAuth.instance.currentUser;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  String name = '';
  String email = '';
  String imageUrl = '';

  void fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await usersRef.doc(currentUser.uid).get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      if (userData != null) {
        setState(() {
          name = userData['name'];
          email = userData['email'];
         
        });
      }
    }
  }
 @override
  void initState() {
    super.initState();
    fetchUserData();
  }

   
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
                     (user?.email ?? ''),
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
                        builder: (context) => const Candidat(id: 'id')));
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
                        builder: (context) => const NotificationScreen()));
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
                        builder: (context) => const MyProfile()));
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
