// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:buscador_de_gifs/ui/homepage.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Buscador de Gifs",
      home: HomePage(),
      theme: ThemeData(
        hintColor: Colors.white,
        primaryColor: Colors.white,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
