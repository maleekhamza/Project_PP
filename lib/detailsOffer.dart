import 'dart:io';

import 'package:chercher_job/Screens/Drawer/profilScreen.dart';
import 'package:chercher_job/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ApplyPage.dart';

class detailsOffer extends StatelessWidget {
  final DocumentSnapshot offerSnap;

  detailsOffer({Key? key, required this.offerSnap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {
          Navigator.of(context).pop();
        },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {}),

        ],
      ), //,
      body: SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Align(
            //alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                    height: 280.0,
                    width: 600.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white)),
                    padding: const EdgeInsets.all(5.0),
                    child:
                    Image.network(
                      offerSnap['images'],
                      height: 90,
                      fit: BoxFit.cover,
                      width: 120,
                    )
                ),
                SizedBox(height: 3,),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Informations :",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),

                    ),
                  ],
                ),

                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Job Title',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.work, color: kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['offer name'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salary',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6,),

                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['salary'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contrat Type',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6,),

                    Row(
                      children: [
                        Icon(Icons.work_history_outlined, color: kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['contrat'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.home_repair_service_sharp, color: kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['services'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adresse',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.place, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['Location'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 6,),
                    Row(
                      children: [
                        Icon(Icons.description, color: kPrimaryColor),
                        SizedBox(width: 8),
                        Text(
                          offerSnap['Description'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 118, 117, 117),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 2,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 228, 211, 236)
                  ),
                  padding: EdgeInsets.all(32),
                  child: ElevatedButton(
                      child: Text("I'm Interested"),
                      onPressed: ()  {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 350,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color.fromARGB(255, 228, 211, 236)),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: 300.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Color.fromARGB(255, 228, 211, 236)),
                                        padding: EdgeInsets.all(32),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (index == 0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) {
                                                  return MyProfile();
                                                }),
                                              );
                                            } else if (index == 1) {
                                              final result =
                                              await FilePicker.platform.pickFiles();
                                              if (result != null) return;
                                            } else if (index == 2) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) {
                                                  return ApplyPage();
                                                }),
                                              );
                                            }
                                          },
                                          child: Text(index == 0
                                              ? "Complete your profile"
                                              : index == 1
                                              ? "Import Your CV"
                                              : "Apply"),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                  ),
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconoMenu extends StatelessWidget {
  IconoMenu({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new Icon(
            icon,
            size: 38.0,
            color: kPrimaryColor,
          ),
          new Text(
            label,
            style: new TextStyle(fontSize: 12.0, color: Color.fromARGB(255, 222, 62, 14)),
          )
        ],
      ),
    );
  }

}

