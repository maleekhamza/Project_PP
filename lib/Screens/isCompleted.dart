import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';

class buildCompleted extends StatefulWidget {
  const buildCompleted({super.key});

  @override
  State<buildCompleted> createState() => _buildCompletedState();
}

class _buildCompletedState extends State<buildCompleted> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Text(
              "Your Profile Is Complete",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0),
            ),
            SizedBox(height: defaultPadding * 2),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 8,
                  child: Image(image: AssetImage('assets/images/done.png'),)
                  
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}
