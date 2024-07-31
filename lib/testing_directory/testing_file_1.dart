import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestingFile1(),
    );
  }
}

class TestingFile1 extends StatefulWidget {
  const TestingFile1({super.key});

  @override
  State<TestingFile1> createState() => _TestingFile1State();
}

class _TestingFile1State extends State<TestingFile1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () {
            updateUser("6Mh40R3AO5VE2Y3DPVZy4Nrwwd23", true, 100);
            updateUser("Dgavk2N1lnZq5jv6seahxQo5URo1", false, 100);
          },
          child: const Text("show")),
    );
  }
}

const String _baseUrl = "tictacshift.scienceontheweb.net";

Future<void> updateUser(String uid, bool won, double timePlayedSeconds) async {
  try {
    final url = Uri.http(_baseUrl, '/update_user_stats.php');
    final response = await http.post(
      url,
      body: {
        'uid': uid,
        'won': won.toString(),
        'time_played_seconds': timePlayedSeconds.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('User Stats updated');
      print(response.body);
    } else {
      print('Failed to update user');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}