import 'package:chercher_job/detailsOffer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../Screens/Drawer/drawer_screen.dart';
import '../Screens/Login/login_screen.dart';
import '../addpost.dart';
import '../constants.dart';
import 'model.dart';

class Recruteur extends StatefulWidget {
  String id;
  Recruteur({required this.id});
  @override
  _RecruteurState createState() => _RecruteurState(id: id);
}

class _RecruteurState extends State<Recruteur> {
  String id;
  var rooll;
  var emaill;
  UserModel loggedInUser = UserModel();
  _RecruteurState({required this.id});
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  void deleteOffer(docId) {
    posts.doc(docId).delete();
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(widget.id)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        rooll = loggedInUser.wrool.toString();
        id = loggedInUser.uid.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => addnote()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          "Recurteur",
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
         leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DrawerScreen()));
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
      ),
      body: Center(
        child: StreamBuilder(
          stream: posts.orderBy(FieldPath.documentId).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot offerSnap = snapshot.data.docs[index];
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => detailsOffer()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    spreadRadius: 15,
                                  ),
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      child: Image.network(
                                    offerSnap['images'],
                                    height: 90,
                                    fit: BoxFit.cover,
                                    width: 120,
                                  )),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      offerSnap['offer name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      offerSnap['salary'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      offerSnap['contrat'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      offerSnap['services'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/update',
                                            arguments: {
                                              'offer name':
                                                  offerSnap['offer name'],
                                              'salary': offerSnap['salary'],
                                              'contrat': offerSnap['contrat'],
                                              'services': offerSnap['services'],
                                              'images': offerSnap['images'],
                                              'id': offerSnap.id,
                                            });
                                      },
                                      icon: Icon(Icons.edit),
                                      iconSize: 30,
                                      color: Colors.blue,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteOffer(offerSnap.id);
                                      },
                                      icon: Icon(Icons.delete),
                                      iconSize: 30,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
