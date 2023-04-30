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
  _RecruteurState createState() => _RecruteurState();
}

class _RecruteurState extends State<Recruteur> {
  _RecruteurState();

  var rooll;
  var emaill;
  UserModel loggedInUser = UserModel();
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
      loggedInUser = UserModel.fromMap(value.data());
    }).whenComplete(() {
      const CircularProgressIndicator();
      setState(() {
        emaill = loggedInUser.email.toString();
        rooll = loggedInUser.wrool.toString();
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
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text(
          "Recurteur",
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
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
          stream: posts.orderBy('timestamp', descending: true).snapshots(),
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
                                builder: (context) => detailsOffer(offerSnap:offerSnap)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: const [
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height:10),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.work, color: Colors.grey,size: 17,),
                                      SizedBox(width: 8.0),
                                      Text(
                                        offerSnap['offer name'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),),
                                        ],

                        ),
                                    SizedBox(height:5),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.attach_money, color: Colors.grey,size: 17),
                                        SizedBox(width: 8.0),
                                        Text(
                                          offerSnap['salary'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),),
                                      ],

                                    ),
                                    SizedBox(height:5),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.home_repair_service_sharp, color: Colors.grey,size: 17),
                                        SizedBox(width: 8.0),
                                        Text(
                                          offerSnap['contrat'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),),
                                      ],

                                    ),
                                    SizedBox(height:5),

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.home_repair_service_sharp, color: Colors.grey,size: 17),
                                        SizedBox(width: 8.0),
                                        Text(
                                          offerSnap['services'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),),
                                      ],

                                    ),

                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/update',
                                            arguments: {
                                              'offer name': offerSnap['offer name'],
                                              'salary': offerSnap['salary'],
                                              'contrat': offerSnap['contrat'],
                                              'services': offerSnap['services'],
                                              'images': offerSnap['images'],
                                              'Location': offerSnap['Location'],
                                              'Description': offerSnap['Description'],
                                              'id': offerSnap.id,
                                            });
                                      },
                                      icon: const Icon(Icons.edit),
                                      iconSize: 30,
                                      color: Colors.blue,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteOffer(offerSnap.id);
                                      },
                                      icon: const Icon(Icons.delete),
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
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
