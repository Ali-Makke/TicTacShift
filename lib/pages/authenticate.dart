import 'package:flutter/material.dart';
import 'package:tic_tac_shift/pages/register_page.dart';
import 'package:tic_tac_shift/pages/sign_in_page.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignInPage = true;

  void toggleView() {
    showSignInPage = !showSignInPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return showSignInPage
        ? SignInPage(toggleView: toggleView)
        : RegisterPage(toggleView: toggleView);
  }
}
