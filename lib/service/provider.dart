

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginState extends ChangeNotifier{
  bool isLoggedIn = false;
  bool isAuthenticating = false;
  File? selectedImage;

  String enteredEmail = '';
  String enteredPassword = '';
  String enteredUsername = '';


  void login() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }

  void email(String data){
    enteredEmail = data;
    notifyListeners();
  }

  void password(String data){
    enteredPassword = data;
    notifyListeners();
  }

  void username(String data){
    enteredUsername = data;
    notifyListeners();
  }

  void aunthenticate(){
    isAuthenticating = !isAuthenticating ;
    notifyListeners();
  }

  void image(File? gambar){
    selectedImage = gambar ;
    notifyListeners();
  }
}