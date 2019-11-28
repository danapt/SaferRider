import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuthenticate {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyBd06bQpajLIsldkupt9zO74f7-rhXIFOc";

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode((response.body)));
      final responseData = json.decode(response.body);
      print(responseData['error']['message']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
//    const url =
//        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBd06bQpajLIsldkupt9zO74f7-rhXIFOc";
//    final response = await http.post(
//      url,
//      body: json.encode(
//        {
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        },
//      ),
//    );
//    print(json.decode((response.body)));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
//    const url =
//        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBd06bQpajLIsldkupt9zO74f7-rhXIFOc";
//    final response = await http.post(
//      url,
//      body: json.encode(
//        {
//          'email': email,
//          'password': password,
//          'returnSecureToken': true,
//        },
//      ),
//    );
//    print(json.decode((response.body)));
  }
}
