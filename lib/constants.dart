import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
const kTextStyle = TextStyle(
    color : Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25.0,
);

const kTextFieldDecoration = InputDecoration(
    labelText: 'UserName',
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey)
    ),


    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),

);

