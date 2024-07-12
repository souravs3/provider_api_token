import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/atendees_provider.dart';
import 'package:test_api_provider/controller/provider/auth_provider.dart';
import 'package:test_api_provider/controller/provider/details_provider.dart';
import 'package:test_api_provider/view/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DetailsProvider()),
        ChangeNotifierProvider(create: (context) => AtendeesProvider()),
      ],
      child: MaterialApp(
        home: Login(),
      ),
    );
  }
}
