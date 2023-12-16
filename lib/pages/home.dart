import 'package:chatify/pages/texting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InnerHome();
}

class InnerHome extends State<Home> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> members = [
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
      {"email": "sagarcm067@gmail.com", "name": 'Sagar CM6'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chatify",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
              onPressed: () {
                logOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            width: 1000,
            color: Colors.blue.shade700,
            child: const Center(
              child: Text(
                "Chats",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Texting(members[index])));
                    },
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero, // Set this
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black,),
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage("lib/images/back.jpg"),
                        ),
                        title: Text(
                          members[index]['name'] as String,
                        ),
                        subtitle: Text(members[index]['email'] as String,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
