import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addpost.dart';
import 'constants.dart';
import 'models/model.dart';
import 'models/Candidat.dart';
import 'models/Recruteur.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  @override
  Widget build(BuildContext context) {
    return contro();
  }
}
class contro extends StatefulWidget {
  contro();

  @override
  _controState createState() => _controState();
}
class _controState extends State<contro> {
  _controState();

  final user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  late String rooll ="";
  late String emaill="";

  @override
  void initState() {
    super.initState();
    if(user!.uid.isNotEmpty){
      FirebaseFirestore.instance
          .collection("users") //.where('uid', isEqualTo: user!.uid)
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
      }).whenComplete(() {
        const CircularProgressIndicator();
        setState(() {
          emaill = loggedInUser.email.toString();
          rooll = loggedInUser.wrool.toString();
        });
      });
    }
  }

  routing() {
    if (rooll == 'Candidat') {
      return Candidat(id: user!.uid,);
    } else {
      return Recruteur(id: user!.uid,);
    }
  }
  @override
  Widget build(BuildContext context) {
    const CircularProgressIndicator();
    return routing();

  }
}