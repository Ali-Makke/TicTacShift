import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/loading.dart';
import 'package:tic_tac_shift/services/auth_service.dart';

import '../common/constants.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;

  const SignInPage({super.key, required this.toggleView});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String _email = "";
  String _password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.amber[50],
            appBar: AppBar(
              backgroundColor: Colors.amber[100],
              elevation: 0.0,
              title: const Text("Sign In"),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    widget.toggleView();
                  },
                  label: const Text("Register"),
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
                        child: const Text("Sign In"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            await Future.delayed(
                                const Duration(milliseconds: 1100));
                            dynamic userInfo = await _auth.signInEmailnPassword(
                                _email, _password);
                            if (userInfo == null) {
                              setState(() {
                                loading = false;
                                error = 'Please supply a valid email';
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
