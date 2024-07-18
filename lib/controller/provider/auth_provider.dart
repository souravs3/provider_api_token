import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get loading => _loading;
  AuthProvider() {
    _checkLoginStatus();
  }
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    final uri = Uri.parse('https://api.acad360.com/v1.1/attendees/login');

    final headers = {
      'tenantid': '63c827a94f51b07114e9d992',
      'username': 'events-app',
      'key': 'cff4c505-9718-4091-a949-060e122ea560',
      'secret':
          '57ed9e57-d40d-454c-9a11-7764693e2f7e-d08c347ea0134c9a1ce0f24196c1624b',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'password': password,
      'eventId': '6376226145148df47313a86c',
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);

        _isLoggedIn = true;
        notifyListeners();
        print('Login successful');
      } else {
        print('Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token: ${prefs.getString('token')}');
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _isLoggedIn = false;
    notifyListeners();
  }

  bool hasTextFieldsValue(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
