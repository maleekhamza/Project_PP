import 'package:flutter/material.dart';

import '../../constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
         title: const Text(
          'Notification',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:const Center(
       child: Text('Notification_Screen'),
      
      )
    );
  }
}
