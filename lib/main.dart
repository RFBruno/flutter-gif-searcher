import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:buscador_gifs/ui/home_page.dart';
import 'package:buscador_gifs/ui/gif_page.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      hintColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
      ),
    ),
    home: SafeArea(
        child: HomePage()
      ),
  ));
}