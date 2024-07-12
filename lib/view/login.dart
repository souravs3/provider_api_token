import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/auth_provider.dart';
import 'package:test_api_provider/view/home.dart';

// ignore: must_be_immutable
class Login extends StatelessWidget {
  Login({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        title: Text(
          'Login',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child:
              Consumer<AuthProvider>(builder: (context, authProvider, child) {
            if (authProvider.isLoggedIn) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              });
            }
            return Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Password'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      authProvider.login(
                          emailController.text, passwordController.text);
                    },
                    child: Text('Login'))
              ],
            );
          })),
    );
  }
}
