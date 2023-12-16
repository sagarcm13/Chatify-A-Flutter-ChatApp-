import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Texting extends StatefulWidget {
  Map<String, String>? oppositeUser;
  Texting(this.oppositeUser);
  @override
  State<StatefulWidget> createState() => TextPage(oppositeUser);
}

class TextPage extends State<Texting> {
  Map<String, String>? oppositeUser;
  List<Map<String, dynamic>> oppositeText = [
    {"message": "hi", "time": 1},
    {"message": "hi2", "time": 3},
    {"message": "hi3", "time": 4},
    {"message": "hi4", "time": 6},
    {"message": "hi5", "time": 8},
  ];
  List<Map<String, dynamic>> userText = [
    {"message": "hi", "time": 2},
    {"message": "hi2", "time": 5},
    {"message": "hi3", "time": 7},
    {"message": "hi4", "time": 9}
  ];
  List<Map<String, dynamic>> universal = [
    {"message": "hi", "time": 1},
    {"message": "hi", "time": 2},
    {"message": "hi2", "time": 3},
    {"message": "hi3", "time": 4},
    {"message": "hi2", "time": 5},
    {"message": "hi4", "time": 6},
    {"message": "hi3", "time": 7},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi5", "time": 8},
    {"message": "hi4", "time": 9},
  ];
  TextPage(this.oppositeUser);
  @override
  Widget build(BuildContext context) {
    String? name = oppositeUser?['name'] ?? '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade700,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("lib/images/back.jpg"),
            ),
            Container(
              width: 20,
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: universal.length,
                itemBuilder: (context, index) {
                  bool isPresent = userText.any((userMap) =>
                      userMap["message"] == universal[index]["message"] &&
                      userMap["time"] == universal[index]["time"]);
                  if (isPresent) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              universal[index]['message'] as String,
                              style: TextStyle(fontSize: 20),
                            ),Text("${universal[index]['time']}",style: TextStyle(fontSize: 10),)
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              universal[index]['message'] as String,
                              style: TextStyle(fontSize: 20),
                            ),Text("${universal[index]['time']}",style: TextStyle(fontSize: 10),)
                          ],
                        ),
                      ),
                    );
                  }
                }),
          ),
          TextField(
            decoration: InputDecoration(
                labelText: "Message",
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    print('hi');
                  },
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2))),
          )
        ],
      ),
    );
  }
}
