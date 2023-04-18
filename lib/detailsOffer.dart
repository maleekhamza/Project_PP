import 'package:chercher_job/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class detailsOffer extends StatefulWidget {
  const detailsOffer({Key? key}) : super(key: key);

  @override
  State<detailsOffer> createState() => _detailsOfferState();
}

class _detailsOfferState extends State<detailsOffer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
    );
  }
}
