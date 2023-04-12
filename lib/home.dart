import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addpost.dart';
import 'constants.dart';
import 'models/model.dart';
import 'models/Candidat.dart';
import 'models/Recruteur.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    return  contro();
  }
}
class contro extends StatefulWidget {
  contro();

  @override
  _controState createState() => _controState();
}
class _controState extends State<contro> {
  _controState();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
    String? rooll;
  late  String?  emaill;
  String id="" ;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        rooll = loggedInUser.wrool.toString();
        id = loggedInUser.uid.toString();
        print(id);

      });
    });
  }

  routing() {
    if (rooll == 'Candidat') {
      return Candidat(id:id,
      );
    } else {
      return Recruteur(id: id,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator();
    return routing();

}
}