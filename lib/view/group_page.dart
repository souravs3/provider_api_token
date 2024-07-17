import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/model/attentice_model.dart';
import 'package:test_api_provider/controller/provider/group_provider.dart';

class GroupPage extends StatelessWidget {
  final List<Attendee> attendees;

  GroupPage({Key? key, required this.attendees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Group Management'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: groupController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter the Group Name',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () async {
                  final groupProvider =
                      Provider.of<GroupProvider>(context, listen: false);
                  await groupProvider.saveGroup(groupController.text);
                },
                child: Text(
                  'Add to Group',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'All Attendees',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<GroupProvider>(
                builder: (context, groupProvider, child) {
                  return ListView.builder(
                    itemCount: attendees.length,
                    itemBuilder: (context, index) {
                      final attendee = attendees[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: attendee.photo.isNotEmpty
                              ? Image.network(
                                  attendee.photo,
                                  fit: BoxFit.fill,
                                )
                              : Icon(Icons.person),
                        ),
                        title: Text(attendee.name),
                        trailing: Checkbox(
                          activeColor: Colors.pink,
                          checkColor: Colors.white,
                          shape: CircleBorder(),
                          value: groupProvider.isSelected(attendee),
                          onChanged: (bool? value) {
                            groupProvider.toggleAttendee(attendee);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
