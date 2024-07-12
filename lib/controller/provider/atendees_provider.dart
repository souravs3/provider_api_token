import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_api_provider/model/attentice_model.dart';
import 'package:http/http.dart' as http;

class AtendeesProvider extends ChangeNotifier {
  List<Attendee>? _atendees;

  bool _isLoading = false;
  bool _isLogin = false;

  List<Attendee>? get attendees => _atendees;
  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAttendees(List<Attendee> attendees) {
    _atendees = attendees;
    notifyListeners();
  }

  Future<void> attendeesList() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    final token = _pref.getString('token');
    setLoading(true);
    var uri = Uri.parse('https://api.acad360.com/v1.1/attendees/list');
    try {
      final response = await http.post(uri,
        body: jsonEncode({
          "eventId": "6376226145148df47313a86c"
        }),
        headers: {
          'tenantid': '63c827a94f51b07114e9d992',
          'username': 'events-app',
          'key': 'cff4c505-9718-4091-a949-060e122ea560',
          'secret': '57ed9e57-d40d-454c-9a11-7764693e2f7e-d08c347ea0134c9a1ce0f24196c1624b',
          'x-auth-token': token!,
          'Content-Type': 'application/json',
        },
      );
      print('Response status: ${response.statusCode}');
      setLoading(false);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] as List;
        final attendees = data.map((attendee) => Attendee.fromJson(attendee)).toList();
        setAttendees(attendees);
      } else {
        print('Attendees list failed: ${response.statusCode}');
      }
    } catch (e) {
      setLoading(false);
      print('Attendees list error: $e');
    }
  }
}
