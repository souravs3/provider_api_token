import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_api_provider/model/event_details_model.dart';

class DetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  EventDetailsModel? _eventModel;
  EventDetailsModel? get eventModel => _eventModel;

  Future<void> getAllDetails() async {
    isLoading = true;
    notifyListeners();

    const uri =
        'https://api.acad360.com/v1.1/events/get-details/6376226145148df47313a86c';
    final url = Uri.parse(uri);
    const _header = {
      'tenantid': '63c827a94f51b07114e9d992',
      'username': 'events-app',
      'key': 'cff4c505-9718-4091-a949-060e122ea560',
      'secret':
          '57ed9e57-d40d-454c-9a11-7764693e2f7e-d08c347ea0134c9a1ce0f24196c1624b',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: _header);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        _eventModel = EventDetailsModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load event details: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      _eventModel = null; // Ensure we handle errors properly
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
