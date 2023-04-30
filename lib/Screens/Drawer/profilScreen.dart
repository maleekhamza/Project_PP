import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../main.dart';
import '../isCompleted.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select languages'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyProfile> {
  //import image
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  getImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  Future uploadImage(File imgXFile) async {
    String imageurl;
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('ProfileCandidatS1$imgId');
    await reference.putFile(imgXFile);
     imageurl = await reference.getDownloadURL();
    return  imageurl;
  }

  List<String> _selectedItems = [];
  //checkbox
  void _showMultiSelect() async {
    final List<String> items = ['Anglais', 'francais', 'espagnol', 'Allemand'];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(items: items);
        });

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  void _showSkillSelect() async {
    final List<String> Skillitems = [
      'Android',
      'Flutter',
      'Kotlin',
      'Design Graphique'
    ];

    final List<String>? Skillresults = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(items: Skillitems);
        });

    if (Skillresults != null) {
      setState(() {
        _selectedItems = Skillresults;
      });
    }
  }

  final degreeTypeList = [
    "Engineer degree",
    "doctorate degree",
    "Master's degree",
    "Three year University degree",
    "other"
  ];
  final fieldStudytList = [
    "Technologie de l'Informatique",
    "gestion",
    "Science de l'informatique"
  ];
  var experienceList = ["Sans experience", "entre 1 et 4ans", ">5ans"];
   final skillsList = [
    "Android",
    "flutter",
    "Kotlin",
    "Design graphique",
    "Adobe Illustrator",
    "photoshop",
    "Python",
    "Java",
    "C-programming",
    "Symfony",
    "React-js",
    "WordPress"
  ];
  String? value;
  String? studyValue;
  bool isCompleted = false;
  int currentStep = 0;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final date = TextEditingController();
  final NameofDipolme = TextEditingController();
  final NameofUniversity = TextEditingController();
  final Certification = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final Languages = TextEditingController();
  final CentreOfInterest = TextEditingController();
  DateTime _selecteddate = DateTime.now();
  var selectedFieldsStudy;
  var selectedDegree;
 var selectedExperience;
  String? imageurl;
  void initState() {
    super.initState();
    date.text = '';
  }

  get formKey => null;
  @override
  Widget build(BuildContext context) {
    BuildContext context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6F35A5),
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: isCompleted
          ? buildCompleted()
          : Form(
              key: formKey,
              child: Theme(
                data: ThemeData(
                    colorScheme: ColorScheme.light(
                        primary: Color.fromARGB(255, 172, 131, 189))),
                child: Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(),
                  currentStep: currentStep,
                  onStepContinue: () async {
                    final isLastStep = currentStep == getSteps().length - 1;
                    //final  imageurl= await uploadImage(imgXFile! as File);
                    if (currentStep == 0) {
                      CollectionReference collection = FirebaseFirestore
                          .instance
                          .collection('ProfileCandidatS1');

                      collection.add({
                        'images': imageurl,
                        'firstName': firstName.text,
                        'lastName': lastName.text,
                        'date': date.text,
                        'Email': email.text,
                        'phone': phone.text,
                      });
                    } else if (currentStep == 1) {
                      CollectionReference collection = FirebaseFirestore
                          .instance
                          .collection('ProfileCandidatS2');
                      collection.add({
                        'university': NameofUniversity.text,
                        'diploma': NameofDipolme.text,
                        'FieldOfStudy': selectedFieldsStudy,
                        'DegreeOfStudy': selectedDegree,
                      });
                    } else if (currentStep == 2) {
                      CollectionReference collection = FirebaseFirestore
                          .instance
                          .collection('ProfileCandidatS3');
                      collection.add({
                        'experience': selectedExperience,
                        'certification': Certification.text,
                        'language': Languages.text,
                        'centreofInterest': CentreOfInterest.text,
                      });
                    }
                    if (isLastStep) {
                      setState(() {
                        isCompleted = true;
                      });
                    } else {
                      setState(() {
                        currentStep += 1;
                      });

                      //formKey.currentState!.validate();
                      //bool isDetailValid = isDetailComplete();
                      // if (isDetailValid) {
                      // if (isLastStep) {
                      //setState(() {
                      // isCompleted = true;
                      // });
                      //} else {
                      //setState(() {
                      //currentStep += 1;
                      //});
                      // }
                    }
                  },
                  onStepTapped: (step) {
                    setState(() {
                      currentStep = step;
                    });
                  },
                  onStepCancel: currentStep == 0
                      ? null
                      : () => setState(() => currentStep -= 1),
                ),
              ),
            ),
    );
  }

  bool isDetailComplete() {
    if (currentStep == 0) {
      if (firstName.text.isEmpty ||
          lastName.text.isEmpty ||
          date.text.isEmpty ||
          email.text.isEmpty ||
          phone.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else if (currentStep == 1) {
      if (NameofUniversity.text.isEmpty || NameofDipolme.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else if (currentStep == 2) {
      if (Certification.text.isEmpty ||
          Languages.text.isEmpty ||
          CentreOfInterest.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

////////////////////Profile_Stepper///////////////////
  List<Step> getSteps() => [
        ////////Step1/////////
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(""),
          content: Column(
            children: <Widget>[
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6F35A5),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
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
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF6F35A5),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
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
                controller: date,
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
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                  labelText: 'Your date of birth',
                  labelStyle: TextStyle(
                    color: Color(0xFF6F35A5),
                  ),
                  filled: true,
                ),

                //tap datePicker
                onTap: () async {
                  DateTime? pickeddate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));

                  if (pickeddate != null && pickeddate != _selecteddate) {
                    setState(() {
                      date.text = pickeddate.toString();
                    });
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: email,
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
                height: 10,
              ),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
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
                  prefixIcon: Icon(Icons.phone_android_rounded),
                  labelText: 'Your Phone number',
                  labelStyle: TextStyle(
                    color: Color(0xFF6F35A5),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        //////////Step2////////////////////
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text(""),
          content: Column(
            children: [
              Text(
                "Your Academic Background",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: NameofUniversity,
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
                  prefixIcon: Icon(Icons.domain),
                  labelText: 'Your University',
                  labelStyle: TextStyle(
                    color: Color(0xFF6F35A5),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: NameofDipolme,
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
                  prefixIcon: Icon(Icons.school),
                  labelText: 'Your Diploma',
                  labelStyle: TextStyle(
                    color: Color(0xFF6F35A5),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("FieldsOfStudy")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> FieldsItems = [];
                      for (int i = 0;
                          i < (snapshot.data as QuerySnapshot).docs.length;
                          i++) {
                        DocumentSnapshot snap =
                            (snapshot.data as QuerySnapshot).docs[i];
                        FieldsItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.id,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: FieldsItems,
                            onChanged: (studyValue) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected Fields Of Study value is $studyValue',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                              Scaffold.of(context)
                                  .showBottomSheet((context) => snackBar);
                              setState(() {
                                selectedFieldsStudy = studyValue;
                              });
                            },
                            value: selectedFieldsStudy as String?,
                            isExpanded: false,
                            hint: new Text(
                              " Your Fields Of Study",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    }
                    return Text("No widget to build");
                  }),

              /*Text(
                "Your Field of study",
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: value,
                isExpanded: true,
                iconSize: 35,
                items: fieldStudytList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      child: Text(value), value: value);
                }).toList(),
                onChanged: (value) => setState(
                  () => this.value = value,
                ),
              ),*/
              SizedBox(
                height: 20,
              ),
              //dropdownMenu
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Study Degree")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> DegreeItems = [];
                      for (int i = 0;
                          i < (snapshot.data as QuerySnapshot).docs.length;
                          i++) {
                        DocumentSnapshot snap =
                            (snapshot.data as QuerySnapshot).docs[i];
                        DegreeItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.id,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: DegreeItems,
                            onChanged: (DegreeValue) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected Degree Of Study value is $DegreeValue',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                              Scaffold.of(context)
                                  .showBottomSheet((context) => snackBar);
                              setState(() {
                                selectedDegree = DegreeValue;
                              });
                            },
                            value: selectedDegree as String?,
                            isExpanded: false,
                            hint: new Text(
                              " Degree Of Study",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    }
                    return Text("No widget to build");
                  }),
            ],
          ),
        ),
        //////////////Step3///////////////
        Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text(""),
          content: Column(
            children: <Widget>[
              Container(
                child: Text("Your Skills",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),

              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("ExperienceList")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      const Text("Loading.....");
                    else {
                      List<DropdownMenuItem> ExperienceItems = [];
                      for (int i = 0;
                          i < (snapshot.data as QuerySnapshot).docs.length;
                          i++) {
                        DocumentSnapshot snap =
                            (snapshot.data as QuerySnapshot).docs[i];
                        ExperienceItems.add(
                          DropdownMenuItem(
                            child: Text(
                              snap.id,
                              style: TextStyle(color: Colors.black),
                            ),
                            value: "${snap.id}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                            items: ExperienceItems,
                            onChanged: (ExperienceValue) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Selected Experience value is $ExperienceValue',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                              Scaffold.of(context)
                                  .showBottomSheet((context) => snackBar);
                              setState(() {
                                selectedExperience = ExperienceValue as String?;
                              });
                            },
                            value: selectedExperience,
                            isExpanded: false,
                            hint: new Text(
                              " Your Experience",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    }
                    return Text("No widget to build");
                  }),
              SizedBox(
                height: 20,
              ),

              //************* CV ***********/
              Container(
                width: 700.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 228, 211, 236)),
                padding: EdgeInsets.all(32),
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();
                    if (result != null) return;
                  },
                  child: Text("Import Your CV"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //************* Skills***************/
              Container(
                width: 700.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 228, 211, 236)),
                padding: EdgeInsets.all(32),
                child: ElevatedButton(
                  onPressed: _showSkillSelect,
                  child: Text('Your Skills'),
                ),
              ),
              Wrap(
                children: _selectedItems
                    .map((e) => Chip(
                          label: Text(e),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),
              //**************languages********/
              /*Container(
                width: 700.0,
                height: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromARGB(255, 228, 211, 236)),
                padding: EdgeInsets.all(32),
                child: ElevatedButton(
                  onPressed: _showMultiSelect,
                  child: Text('Languages'),
                ),
              ),*/
             /* Wrap(
                children: _selectedItems
                    .map((e) => Chip(
                          label: Text(e),
                        ))
                    .toList(),
              ),*/

              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: Certification,
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
                    prefixIcon: Icon(Icons.school),
                    labelText: 'Certification Name',
                    labelStyle: TextStyle(
                      color: Color(0xFF6F35A5),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 228, 211, 236)),
              ),
              SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: CentreOfInterest,
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
                    prefixIcon: Icon(Icons.music_note),
                    labelText: 'Center of interest',
                    labelStyle: TextStyle(
                      color: Color(0xFF6F35A5),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 228, 211, 236)),
              ),
            ],
          ),
        ),
      ];

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
        ),
      );

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 80.0,
              //backgroundImage: AssetImage("assets/images/profil.jpg"),
              backgroundImage: imgXFile == null
                  ? null
                  : FileImage(
                      File(imgXFile!.path),
                    )),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                /*var context;
                showModalBottomSheet(
                    context: context, builder: (context) => bottomSheet(context));*/
                getImageFromGallery();
              },
              child: Icon(Icons.camera_alt,
                  color: Color.fromARGB(255, 161, 91, 157), size: 28.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
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
          /*Row(
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
          )*/
        ],
      ),
    );
  }
}
