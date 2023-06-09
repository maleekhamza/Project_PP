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
  TextEditingController offerLocation = TextEditingController();
  TextEditingController offerDescription = TextEditingController();
  late String imageurl;



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
       'Location':offerLocation.text,
      'Description':offerDescription.text,
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
    offerLocation.text=args['Location'];
    offerDescription.text=args['Description'];
    imageurl=args['images'];
    final docId = args['id'];


    return Scaffold(
      appBar: AppBar(
        title: Text("Update offers"),
        backgroundColor: kPrimaryColor,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                          child: imageurl == null?
                          Center(child: Text('no image selected')) :
                        _image==null? Image.network(
                            imageurl ,
                            width: 300,
                            height: 300,
                            ):Image.file(
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
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offer Name',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: offerName,
                        decoration: InputDecoration(
                          hintText: 'Offer Name',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,

                          ),
                          filled: true, // ajouter un fond rempli de couleur
                          fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                          border: OutlineInputBorder( // définir une bordure de rectangle
                            borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                            borderSide: BorderSide.none, // supprimer la bordure de ligne
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Offer Name !';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salary',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: offerSalary,
                        decoration: InputDecoration(
                          hintText: 'Salary',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,

                          ),
                          filled: true, // ajouter un fond rempli de couleur
                          fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                          border: OutlineInputBorder( // définir une bordure de rectangle
                            borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                            borderSide: BorderSide.none, // supprimer la bordure de ligne
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Salary !';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
    Padding(padding: const EdgeInsets.all(8.0),
    child:
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Contrat',
    style: TextStyle(
    color: Colors.grey[700],
    fontSize: 18,
    ),
    ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                      value: SelectedContrat,
                      decoration: InputDecoration(
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
    ],
    ),
    ),
    Padding(padding: const EdgeInsets.all(8.0),
    child:
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Service',
    style: TextStyle(
    color: Colors.grey[700],
    fontSize: 18,
    ),
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
    ],
    ),
    ),
                Padding(padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        controller: offerLocation,
                        decoration: InputDecoration(
                          hintText: 'Location',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,

                          ),
                          filled: true, // ajouter un fond rempli de couleur
                          fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                          border: OutlineInputBorder( // définir une bordure de rectangle
                            borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                            borderSide: BorderSide.none, // supprimer la bordure de ligne
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the Location !';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0),
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10,),
                      // définir la hauteur souhaitée du TextFormField
                      TextFormField(
                        controller: offerDescription,
                        decoration: InputDecoration(

                          contentPadding: EdgeInsets.symmetric(vertical: 55.0), // définir la marge interne de la zone de saisie
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          filled: true, // ajouter un fond rempli de couleur
                          fillColor: Colors.grey[200], // définir la couleur de l'arrière-plan
                          border: OutlineInputBorder( // définir une bordure de rectangle
                            borderRadius: BorderRadius.circular(8.0), // personnaliser le rayon des coins du rectangle
                            borderSide: BorderSide.none, // supprimer la bordure de ligne
                          ),
                        ),
                        maxLines: null, // permet à l'utilisateur d'écrire autant de lignes qu'il souhaite
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the event description';
                          }
                          return null;
                        },
                      ),

                    ],
                  ),
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
                    )),
                SizedBox(height: 12,),

              ],
            ),
        ),
      )
        );
  }


}