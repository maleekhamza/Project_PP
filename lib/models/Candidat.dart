import 'package:chercher_job/Screens/Drawer/drawer_candidat.dart';
import 'package:chercher_job/Screens/Drawer/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../Screens/Drawer/drawer_screen.dart';
import '../Screens/Login/login_screen.dart';
import '../constants.dart';
import '../detailsOffer.dart';
import 'model.dart';

class Candidat extends StatefulWidget {
  String id;
  Candidat({required this.id});
  @override
  _CandidatState createState() => _CandidatState(id: id);
}

class _CandidatState extends State<Candidat> {
  String id;
  var rooll;
  var emaill;
  UserModel loggedInUser = UserModel();
  _CandidatState({required this.id});
  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users") //.where('uid', isEqualTo: user!.uid)
        .doc(id)
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Candidat",
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
                MaterialPageRoute(builder: (context) => const DrawerCandidat()));
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
      body:  Center(
        child: StreamBuilder(
          stream: posts.orderBy(FieldPath.documentId).snapshots(),
          builder:(context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder:(context,index){
                  final DocumentSnapshot offerSnap =snapshot.data.docs[index];
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
                          height:150 ,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow:[
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10,
                                  spreadRadius: 15,

                                ),]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Image.network(offerSnap['images'],height:90,fit: BoxFit.cover ,width: 120,)
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(offerSnap['offer name'],
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                  ),
                                  Text(offerSnap['salary'],
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text(offerSnap['contrat'],
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                  Text(offerSnap['services'],
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                ],

                              ),
                              Row(
                                children: [

                                  IconButton(onPressed: (){
                                  },
                                    icon: Icon(Icons.favorite_border),
                                    iconSize: 30,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ) ,
                        ),
                      ),
                      ),
                    ],
                  );
                },);
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
