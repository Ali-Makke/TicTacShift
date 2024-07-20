import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/loading.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;

  const RegisterPage({super.key, required this.toggleView});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _email = "";
  String _password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.amber[50],
            appBar: AppBar(
              backgroundColor: Colors.amber[100],
              elevation: 0.0,
              title: const Text("Sign Up"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: const Text("Sign in"),
                  icon: const Icon(Icons.person),
                )
              ],
            ),
            body: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      //username field
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Username"),
                        validator: (value) =>
                            value!.isEmpty ? "Username already taken" : null,
                        onChanged: (text) {
                          _username = text;
                        },
                      ),
                      SizedBox(height: 20),
                      //email field
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Email"),
                        validator: (value) =>
                            value!.isEmpty ? "Enter an email" : null,
                        onChanged: (text) {
                          _email = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      //password field
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "Password"),
                        validator: (value) => (value!.length < 6)
                            ? "Password must be more than 6 chars long"
                            : null,
                        obscureText: true,
                        onChanged: (text) {
                          _password = text;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text("Register"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic userInfo = await _auth
                                .registerEmailnPassword(_username, _email, _password);
                            if (userInfo == null) {
                              setState(() {
                                loading = false;
                                error = ('Please supply a valid email');
                              });
                            }
                          }
                        },
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
