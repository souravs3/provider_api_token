import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  // Private fields to store loading state and login status
  bool _loading = false;
  bool _isLoggedIn = false;

  // Public getters for loading state and login status
  bool get isLoggedIn => _isLoggedIn;
  bool get loading => _loading;

  // Method to update loading state and notify listeners
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Method to handle user login
  Future<void> login(String email, String password) async {
    setLoading(true);  // Set loading state to true
    final uri = Uri.parse('https://api.acad360.com/v1.1/attendees/login');  // API endpoint

    // Headers for the HTTP POST request
    final headers = {
      'tenantid': '63c827a94f51b07114e9d992',
      'username': 'events-app',
      'key': 'cff4c505-9718-4091-a949-060e122ea560',
      'secret': '57ed9e57-d40d-454c-9a11-7764693e2f7e-d08c347ea0134c9a1ce0f24196c1624b',
      'Content-Type': 'application/json',
    };

    // Body for the HTTP POST request
    final body = jsonEncode({
      'email': email,
      'password': password,
      'eventId': '6376226145148df47313a86c',
    });

    try {
      // Send HTTP POST request
      final response = await http.post(uri, headers: headers, body: body);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse response data
        final data = jsonDecode(response.body);

        // Save token to shared preferences
        await _saveToken(data['token']);
        
        _isLoggedIn = true;  // Set login status to true
        notifyListeners();  // Notify listeners about the change
        print('Login successful');
      } else {
        print('Login failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Login error: $e');
    } finally {
      setLoading(false);  // Set loading state to false
    }
  }

  // Method to save token to shared preferences
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();  // Get shared preferences instance
    await prefs.setString('token', token);  // Save token
    print('Token: ${prefs.getString('token')}');  // Print token for debugging
  }
}
