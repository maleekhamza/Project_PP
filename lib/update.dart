import 'package:chercher_job/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  String ? SelectedServices;
  final CollectionReference offer = FirebaseFirestore.instance.collection(
      'posts');
  TextEditingController offerName = TextEditingController();
  TextEditingController offerSalary = TextEditingController();
  TextEditingController offerContrat = TextEditingController();

  void updateOffer(docId) {
    final data ={
      'offer name':offerName.text,
      'salary':offerSalary.text,
      'contrat':offerContrat.text,
      'services':SelectedServices
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
    offerContrat.text = args['contrat'];
    SelectedServices = args['services'];
    final docId = args['id'];


    return Scaffold(
      appBar: AppBar(
        title: Text("Update offers"),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
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
              child: TextField(
                controller: offerContrat,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("contrat")),
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