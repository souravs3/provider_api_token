import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/atendees_provider.dart';

class Atendees_page extends StatelessWidget {
  const Atendees_page({Key? key});

  @override
  Widget build(BuildContext context) {
    // Ensure attendeesList() is called before building this page
    Provider.of<AtendeesProvider>(context, listen: false).attendeesList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendees List'),
      ),
      body: Consumer<AtendeesProvider>(
        builder: (context, atendeesProvider, child) {
          if (atendeesProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (atendeesProvider.attendees == null) {
            return Center(child: Text('Loading attendees...'));
          } else if (atendeesProvider.attendees!.isEmpty) {
            return Center(child: Text('No attendees found.'));
          } else {
            final attendees = atendeesProvider.attendees!;
            return ListView.builder(
              itemCount: attendees.length,
              itemBuilder: (context, index) {
                final attendee = attendees[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: attendee.photo.isNotEmpty
                        ? Image.network(attendee.photo, fit: BoxFit.fill)
                        : Icon(Icons.person),
                  ),
                  title: Text(
                      attendee.name.isNotEmpty ? attendee.name : 'No Name'),
                  subtitle: Text(
                      attendee.email.isNotEmpty ? attendee.email : 'No Email'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
