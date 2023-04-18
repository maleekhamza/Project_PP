import 'dart:io';

import 'package:chercher_job/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateOffer extends StatefulWidget {
  const UpdateOffer({Key? key}) : super(key: key);

  @override
  State<UpdateOffer> createState() => _UpdateOfferState();
}

class _UpdateOfferState extends State<UpdateOffer> {
  final offerServices = [
    'Informatique',
    'marketing',
    'commercial',
    'comptabilité',
    'Adminstration'
  ];
  final typeContrat = [
    'CDI',
    'CDD',
  ];

  String ? SelectedServices;
  String ? SelectedContrat;

  File? _image ;
  final picker = ImagePicker();
  final CollectionReference offer = FirebaseFirestore.instance.collection(
      'posts');
  TextEditingController offerName = TextEditingController();
  TextEditingController offerSalary = TextEditingController();
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
  Future<void> updateOffer(docId) async {
  final  imageurl= await uploadImage(_image!);
  final data ={
      'offer name':offerName.text,
      'salary':offerSalary.text,
      'contrat':SelectedContrat,
      'services':SelectedServices,
      'images':imageurl
    };
    offer.doc(docId).update(data).then((value) => Navigator.pop(context));
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;
    offerName.text = args['offer name'];
    offerSalary.text = args['salary'];
    SelectedContrat = args['contrat'];
    SelectedServices = args['services'];
    final docId = args['id'];


    return Scaffold(
      appBar: AppBar(
        title: Text("Update offers"),
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
                          height: 300,
                          ),
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
                  controller: offerName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text("Offer Name")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: offerSalary,
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
                  child: DropdownButtonFormField(
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
                updateOffer(docId);
              },
                  style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                      backgroundColor: MaterialStateProperty.all(
                          kPrimaryColor)
                  ),
                  child: Text("Update",
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
        ),

    );
  }


}