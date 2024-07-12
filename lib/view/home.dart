import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/details_provider.dart';
import 'package:test_api_provider/view/atendees_page.dart';
import 'package:test_api_provider/view/styles/text_styles.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailsProvider>(context, listen: false);

    // Fetch event details when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getAllDetails();
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 168, 125, 20),
      body: Consumer<DetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.eventModel == null) {
            return const Center(
              child: Text('No data is available'),
            );
          } else {
            final event = provider.eventModel!;
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(23, 168, 125, 100)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          '${event.title}',
                          style: AppTextStyles().titleStyle(),
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
                        image: DecorationImage(
                          image: NetworkImage(event.eventlogo),
                          fit: BoxFit
                              .cover, // Optional: adjust this based on how you want the image to fit
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
                                  style: const TextStyle(fontSize: 16),
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        elevation: WidgetStatePropertyAll(0),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.deepOrange)),
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
                                    ))
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
}
