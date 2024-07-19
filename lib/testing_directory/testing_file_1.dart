// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestingFile1 extends StatefulWidget {
  const TestingFile1({Key? key}) : super(key: key);

  @override
  State<TestingFile1> createState() => _TestingFile1State();
}

class _TestingFile1State extends State<TestingFile1> {
  String mydata = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("REST API Call"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getUser(1);
        },
        child: const Icon(Icons.refresh),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Data: $mydata"),
          ],
        ),
      ),
    );
  }

  Future<void> getUser(int uid) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://tictacshift.infinityfreeapp.com/get_user.php?uid=$uid'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == null || data['success'] == false) {
          setState(() {
            mydata = 'Failed to load user: ${data['error']}';
          });
        } else {
          setState(() {
            mydata =
                'Username: ${data['username']}, Email: ${data['email']}'; // Adjust based on your data structure
          });
        }
      } else {
        setState(() {
          mydata = 'Failed to load user: Status Code ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        mydata = 'Failed to load user: $e';
      });
    }
  }

// void fetchData() async {
//   const url = "https://randomuser.me/api/?results=1";
//   final uri = Uri.parse(url);
//   final response = await http.get(uri);
//   final body = response.body;
//   final jason = jsonDecode(body);
//   // users = jason['results'];
//   // print(users);
//   // setState(() {
//   //   mydata = users.toString();
//   });
// }
}
