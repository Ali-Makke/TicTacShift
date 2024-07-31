import 'package:flutter/material.dart';
import 'package:tic_tac_shift/common/loading.dart';
import 'package:tic_tac_shift/services/database.dart';

import '../common/constants.dart';

class FriendInvite extends StatefulWidget {
  const FriendInvite({super.key});

  @override
  State<FriendInvite> createState() => _FriendInviteState();
}

class _FriendInviteState extends State<FriendInvite> {
  String name = "";
  List<String>? data;
  bool _loading = false;

  void found(String message) {
    setState(() {
      _loading = false;
      print("\n\n$_loading\n\n");
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        title: sandText("Challenge Friend"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: "Search by username...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.brown.shade300),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (input) {
                  setState(() {
                    name = input;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 1000,
                height: 300,
                child: _loading
                    ? const Loading()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 200,
                            margin: const EdgeInsets.only(right: 10),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  data?[index] ?? "Empty...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Text("Status"),
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://plus.unsplash.com/premium_vector-1682269287900-d96e9a6c188b?q=80&w=1800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  List<String>? result = await DatabaseService()
                      .searchForUser(found, name.trim().toLowerCase());
                  setState(() {
                    data = result;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: Colors.brown[400],
                ),
                child: const Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
