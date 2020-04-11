

import 'package:cobra1/TextStyles/TextStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



AppBar header(context, {bool isAppTitle = true , String titleText = "COBRA1"}) {
  return AppBar(
    title: Text(titleText, style:isAppTitle ? appTitleTextStyle():normalTitleTextStyle()),
    centerTitle: true,
    backgroundColor:Theme.of(context).primaryColor,
  );
}
