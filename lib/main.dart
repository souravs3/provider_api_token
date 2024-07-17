import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/atendees_provider.dart';
import 'package:test_api_provider/controller/provider/auth_provider.dart';
import 'package:test_api_provider/controller/provider/details_provider.dart';
import 'package:test_api_provider/controller/provider/group_provider.dart';
import 'package:test_api_provider/view/home.dart';
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
        ChangeNotifierProvider(create: (context) => GroupProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Consumer<AuthProvider>(
          builder: (context, value, child) {
            if (value.isLoggedIn) {
              return Home();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
