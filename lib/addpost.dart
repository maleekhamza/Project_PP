
import 'dart:io';

import 'package:chercher_job/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import 'home.dart';

class addnote extends StatefulWidget {
  @override
  State<addnote> createState() => _addnoteState();
}

class _addnoteState extends State<addnote> {
  TextEditingController title = TextEditingController();

  TextEditingController Salary = TextEditingController();

  TextEditingController Contrat = TextEditingController();

  final offerServices = [
    'Informatique',
    'marketing',
    'commercial',
    'comptabilité',
    'Adminstration'
  ];

  final typeContrat = [
    'CDI',
    'CDD'
  ];

  String ? SelectedServices;
  String ? SelectedContrat;


  CollectionReference ref = FirebaseFirestore.instance.collection('posts');

  Future<void> addOffer() async {
    final  imageurl= await uploadImage(_image!);

    final data = {
      'offer name': title.text,
      'salary': Salary.text,
      'contrat': SelectedContrat,
      'services': SelectedServices,
      'images':imageurl
    };
    ref.add(data).then((value) => Navigator.pop(context));

  }

  File? _image ;

  final picker = ImagePicker();
  //late String downloadUrl;
  Future imagePicker() async {

    try {
      final pick = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pick != null) {
          _image = File(pick.path);
        } else {
          print("no image selected");
        }
      });
    }  catch (e) {
      print(e.toString());

    }
  }
  Future uploadImage(File _image) async{
    String url;
    String imgId=DateTime.now().microsecondsSinceEpoch.toString();
  Reference reference=  FirebaseStorage.instance.ref().child('images').child('posts$imgId');
  await reference.putFile(_image);
  url=await reference.getDownloadURL();
  return url;
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text("Add offers"),
          backgroundColor: kPrimaryColor,
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
               Container(
                 width: 300,
                 height: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                            child: _image == null?
                            Center(child: Text('no image selected')) :
                            Image.file(
                              _image! ,
                              width: 300,
                              height: 300,),
                          ),
                        MaterialButton(
                            onPressed: () {
                          imagePicker();
                        },
                            child: Text("selected image"),
                          textColor: Colors.white,
                          color: kPrimaryColor,
                         )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                  height: 20.0),
              Padding(padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text("Offer Name")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: Salary,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text("salary")),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Select Type Contrat")
                      ),
                      items: typeContrat
                          .map((e) =>
                          DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                          .toList(),
                      onChanged: (val) {
                        SelectedContrat = val as String?;
                      })
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  DropdownButtonFormField(
                      value: SelectedServices,
                      decoration: InputDecoration(
                          label: Text("Select Service")
                      ),
                      items: offerServices
                          .map((e) =>
                          DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                          .toList(),
                      onChanged: (val) {
                        SelectedServices = val as String?;
                      })
              ),
              ElevatedButton(onPressed: () {
                addOffer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey,)
                  ),
                  child: Text("Submit",
                    style: TextStyle(fontSize: 20),
                  )
              )
            ],
          ),
        ),

      );
  }
}

