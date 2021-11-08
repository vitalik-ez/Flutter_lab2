import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  int _age = 18;

  int get getAge => _age;

  void incrementUsersAge() {
    _age++;
    notifyListeners();
  }
}