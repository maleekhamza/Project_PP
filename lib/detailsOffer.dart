import 'package:chercher_job/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class detailsOffer extends StatefulWidget {
  detailsOffer({Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('posts').doc();
    _futureData = _reference.get();

  }
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  @override
  State<detailsOffer> createState() => _detailsOfferState();
}

class _detailsOfferState extends State<detailsOffer> {
   Map<dynamic, dynamic> data= {};
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: TextStyle(color: Colors.white, fontSize: 22,fontWeight: FontWeight.bold),
        ),

        elevation: 0.0,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {    Navigator.of(context).pop();
        },
        ),actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {}),

      ],
        // actions: [
        //  IconButton(
        //onPressed: () {
        //add the id to the map
        // data['id'] = itemId;
        // },
        //icon: Icon(Icons.edit)),
        //IconButton(onPressed: (){
        //Delete the item
        //_reference.delete();
        // }, icon: Icon(Icons.delete))
        // ],
      ),    //,

    );
  }

}

