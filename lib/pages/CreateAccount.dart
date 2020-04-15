import 'dart:async';
import 'package:cobra1/Widgets/header.dart';
import 'package:flutter/material.dart';







class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _scaffolfdKey = GlobalKey<ScaffoldState>();
  String username;
  submit() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      SnackBar snackbar = SnackBar(content: Text("Welcome  $username"));
      _scaffolfdKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, username);
      });
      //Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext parentcontext) {
    return Scaffold(
        key: _scaffolfdKey,
        appBar: header(context,
            titleText: "Create account",
            isAppTitle: false,
            removeBackbutton: true),
        body: Scaffold(
            body: Column(
          children: <Widget>[
            Text("Create a Username"),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: TextFormField(
                  validator: (val) {
                    if (val.trim().length < 3 || val.isEmpty)
                      return "Username is too short";
                    else {
                      if (val.trim().length > 20) {
                        return "Username too long";
                      } else {
                        return null;
                      }
                    }
                  },
                  onSaved: (val) => username = val,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      hintText: "Must be atleast 3 characters"),
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                  margin: EdgeInsets.only(top: 25),
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Sumbit",
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10))),
              onTap: submit,
            )
          ],
        )));
  }
}
