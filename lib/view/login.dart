import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_api_provider/controller/provider/auth_provider.dart';
import 'package:test_api_provider/view/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    emailController.removeListener(_onTextChanged);
    passwordController.removeListener(_onTextChanged);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.teal,
        title: Text(
          'Login Page',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          if (authProvider.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            });
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (authProvider.hasTextFieldsValue(
                            emailController.text, passwordController.text)) {
                          return Colors.teal;
                        }
                        return Colors.transparent;
                      },
                    ),
                  ),
                  onPressed: authProvider.loading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            authProvider
                                .login(emailController.text,
                                    passwordController.text)
                                .then((_) {
                              if (!authProvider.isLoggedIn) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid user credentials'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                  child: authProvider.loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
