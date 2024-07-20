import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_shift/models/user_model.dart';
import 'package:tic_tac_shift/pages/authenticate.dart';
import 'package:tic_tac_shift/pages/home_page.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserModel?>(context);

    return (userInfo == null) ? const Authenticate() : const HomePage();
  }
}
