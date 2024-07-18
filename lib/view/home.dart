import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/auth_provider.dart';
import 'package:test_api_provider/controller/provider/details_provider.dart';
import 'package:test_api_provider/controller/provider/group_provider.dart';
import 'package:test_api_provider/model/attentice_model.dart';
import 'package:test_api_provider/view/atendees_page.dart';
import 'package:test_api_provider/view/login.dart';
import 'package:test_api_provider/view/styles/text_styles.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final detailsProvider =
        Provider.of<DetailsProvider>(context, listen: false);
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);

    // Fetch event details and groups when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      detailsProvider.getAllDetails();
      groupProvider.fetchGroups();
    });

    bool _isLoggingOut = false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer2<DetailsProvider, GroupProvider>(
        builder: (context, detailsProvider, groupProvider, child) {
          if (detailsProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (detailsProvider.eventModel == null) {
            return const Center(
              child: Text('No data is available'),
            );
          } else {
            final event = detailsProvider.eventModel!;
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${event.title}',
                                style: AppTextStyles().titleStyle(),
                              ),
                              Consumer<AuthProvider>(
                                builder: (context, value, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (!_isLoggingOut) {
                                        // Check if not already logging out
                                        _isLoggingOut =
                                            true; // Set flag to true to indicate logout process started
                                        value.logout().then((_) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login()),
                                          );
                                        }).catchError((error) {
                                          // Handle error if any
                                          print("Logout error: $error");
                                        }).whenComplete(() {
                                          _isLoggingOut =
                                              false; // Reset flag when logout process completes
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: NetworkImage(event.eventlogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Attendees: ${event.attendees}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: WidgetStatePropertyAll(0),
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.teal),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Atendees_page()));
                                  },
                                  child: Text(
                                    'Show all',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Orders: ${event.orders}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Tickets: ${event.receipts}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start Date: ${event.startDate}'),
                                Text('Start Time: ${event.startTime}'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Groups',
                          style: TextStyle(fontSize: 24),
                        ),
                        Container(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: groupProvider.groups.length,
                            itemBuilder: (context, index) {
                              final groupName = groupProvider.groups[index];
                              return ListTile(
                                title: Text(
                                  groupName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    _showGroupDetails(
                                        context,
                                        groupName,
                                        groupProvider
                                            .groupAttendees[groupName]!);
                                  },
                                  child: Text(
                                    'See All',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showGroupDetails(
      BuildContext context, String groupName, List<Attendee> attendees) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(groupName),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: attendees.length,
              itemBuilder: (context, index) {
                final attendee = attendees[index];
                return ListTile(
                  title: Text(
                    attendee.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(attendee.email),
                  leading: CircleAvatar(
                    backgroundImage: attendee.photo.isNotEmpty
                        ? NetworkImage(attendee.photo)
                        : null,
                    child: attendee.photo.isEmpty ? Icon(Icons.person) : null,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
