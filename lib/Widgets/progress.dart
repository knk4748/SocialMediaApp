import 'package:flutter/material.dart';

Container circularProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.redAccent)));
}

Container linearProgress() {
  return Container(
    child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple)),
    padding: EdgeInsets.only(bottom: 10),
  );
}
