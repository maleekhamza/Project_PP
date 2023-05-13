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
  final String id;
  const Candidat({super.key, required this.id});
  @override
  _CandidatState createState() => _CandidatState();
}

class _CandidatState extends State<Candidat> {
  _CandidatState();

  late String rooll="";
  late String emaill="";
  UserModel loggedInUser = UserModel();
  final CollectionReference posts = FirebaseFirestore.instance.collection('posts');

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Candidat",
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
          stream: posts.orderBy('timestamp', descending: true).snapshots(),
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
                                boxShadow: const [
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
                                      child: Image.network(offerSnap['images'],height:150,fit: BoxFit.cover ,width: 120,)
                                  ),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,

                                  children: [

                                    IconButton(onPressed: (){
                                    },
                                      icon: const Icon(Icons.favorite_border),
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
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
