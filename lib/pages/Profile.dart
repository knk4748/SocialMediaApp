

import 'package:cobra1/Widgets/header.dart';
import 'package:flutter/material.dart';







class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: header(context,titleText:"Profile",isAppTitle: false),
      
    );
  }
}