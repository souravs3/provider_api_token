import 'package:flutter/material.dart';
import 'package:test_api_provider/controller/services/db_helper.dart';
import 'package:test_api_provider/model/attentice_model.dart';

class GroupProvider with ChangeNotifier {
  final List<Attendee> _selectedAttendees = [];
  final List<String> _groups = [];
  final Map<String, List<Attendee>> _groupAttendees = {};

  List<Attendee> get selectedAttendees => _selectedAttendees;
  List<String> get groups => _groups;
  Map<String, List<Attendee>> get groupAttendees => _groupAttendees;

  void toggleAttendee(Attendee attendee) {
    if (_selectedAttendees.contains(attendee)) {
      _selectedAttendees.remove(attendee);
    } else {
      _selectedAttendees.add(attendee);
    }
    notifyListeners();
  }

  bool isSelected(Attendee attendee) {
    return _selectedAttendees.contains(attendee);
  }

  Future<void> saveGroup(String groupName) async {
    if (groupName.isEmpty) return;

    final groupId = await DatabaseHelper.instance.insertGroup(groupName);

    for (var attendee in _selectedAttendees) {
      await DatabaseHelper.instance.insertGroupAttendee(groupId, attendee);
    }

    _selectedAttendees.clear();
    await fetchGroups();
    notifyListeners();
  }

  Future<void> fetchGroups() async {
    _groups.clear();
    _groupAttendees.clear();

    final groupsFromDb = await DatabaseHelper.instance.getGroups();
    for (var group in groupsFromDb) {
      final groupId = group['id'];
      final groupName = group['name'];
      _groups.add(groupName);

      final attendeesFromDb =
          await DatabaseHelper.instance.getGroupAttendees(groupId);
      final attendees = attendeesFromDb.map((attendeeMap) {
        return Attendee(
          salutation: attendeeMap['salutation'] ??
              '', // Handle null with default value ''
          firstName: attendeeMap['first_name'] ?? '',
          middleName: attendeeMap['middle_name'] ?? '',
          lastName: attendeeMap['last_name'] ?? '',
          name: attendeeMap['attendee_name'] ?? '',
          email: attendeeMap['attendee_email'] ?? '',
          city: attendeeMap['city'] ?? '',
          country: attendeeMap['country'] ?? '',
          photo: attendeeMap['attendee_photo'] ??
              '', // Ensure photo is a String type
          designation: attendeeMap['designation'] ?? '',
          affiliation: attendeeMap['affiliation'] ?? '',
        );
      }).toList();
      _groupAttendees[groupName] = attendees;
    }

    notifyListeners();
  }
}
