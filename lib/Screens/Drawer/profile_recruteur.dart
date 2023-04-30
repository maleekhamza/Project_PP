import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:chercher_job/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class ProfileRecruteur extends StatefulWidget {
  const ProfileRecruteur({super.key});

  @override
  State<ProfileRecruteur> createState() => _ProfileRecruteurState();
}

class _ProfileRecruteurState extends State<ProfileRecruteur> {
  CollectionReference ref =
      FirebaseFirestore.instance.collection('ProfileRecruteur');

  Future<void> saveData() async {
    final imageurl = await uploadImage(_image!);

    final data = {
      'image': imageurl,
      'firstName': firstName.text,
      'lastName': lastName.text,
      'Email': email.text,
    };
    ref.add(data).then((value) => Navigator.pop(context));
  }

  File? _image;

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
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadImage(File _image) async {
    String url;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('ProfileRecruteur$imgId');
    await reference.putFile(_image);
    url = await reference.getDownloadURL();
    return url;
  }

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final date = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6F35A5),
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                imageProfile(),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: firstName,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'first name',
                    labelStyle: TextStyle(
                      color: Color(0xFF6F35A5),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: lastName,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person),
                    labelText: 'last name',
                    labelStyle: TextStyle(
                      color: Color(0xFF6F35A5),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6F35A5),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.email_rounded),
                    labelText: 'Your Email',
                    labelStyle: TextStyle(
                      color: Color(0xFF6F35A5),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "*Required";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    )),
                    onPressed: () {
                      saveData();
                    },
                    /*async {
                      CollectionReference collRef = FirebaseFirestore.instance
                          .collection('ProfileRecruteur');
                      collRef.add({
                        'image': imageurl,
                        'firstName': firstName.text,
                        'lastName': lastName.text,
                        'Email': email.text,
                      });
                    },*/
                    child: Text("Save")),
              ],
            ),
          ),
        ));
  }

  

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 80.0,
              //backgroundImage: AssetImage("assets/images/profil.jpg"),
              backgroundImage: _image == null
                  ? null
                  : FileImage(
                      File(_image!.path),
                    )),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                /*var context;
                showModalBottomSheet(
                    context: context, builder: (context) => bottomSheet(context));*/
                imagePicker();
              },
              child: Icon(Icons.camera_alt,
                  color: Color.fromARGB(255, 161, 91, 157), size: 28.0),
            ),
          ),
        ],
      ),
    );
  }
}

Widget bottomSheet() {
  return Container(
    height: 100.0,
    width: 30,
    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    child: Column(
      children: <Widget>[
        Text(
          "choose a profile photo",
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {},
              label: Text('Camera'),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {},
              label: Text('Gallery'),
            ),
          ],
        )
      ],
    ),
  );
}
