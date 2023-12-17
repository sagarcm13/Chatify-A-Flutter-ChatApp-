import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Texting extends StatefulWidget {
  Map<String, dynamic>? oppositeUser;
  Texting(this.oppositeUser, {super.key});
  @override
  State<StatefulWidget> createState() => TextPage(oppositeUser);
}

class TextPage extends State<Texting> {
  List<Map<String, dynamic>> conversations = [];
  final Map<String, dynamic>? oppositeUser;
  TextPage(this.oppositeUser);
  String? useremail;
  TextEditingController sendmsg = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        useremail = '';
        print('User is currently signed out!');
      } else {
        useremail = user.email;
        print(useremail);
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    var db = FirebaseFirestore.instance;
    String opposite = oppositeUser?['email']
        .substring(0, oppositeUser?['email'].indexOf('@'));
    String? mainUser = useremail?.substring(0, useremail?.indexOf('@'));
    print('$opposite $mainUser');
    try {
      var querySnapshot = await db
          .collection('Conversations')
          .where('sender', isEqualTo: mainUser)
          .where('receiver', isEqualTo: opposite)
          .get();
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        conversations.add(docSnapshot.data());
      }
      querySnapshot = await db
          .collection('Conversations')
          .where('sender', isEqualTo: opposite)
          .where('receiver', isEqualTo: mainUser)
          .get();
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
        conversations.add(docSnapshot.data());
      }
      print(DateTime.now());
      conversations.sort((a, b) => a['time'].compareTo(b['time']));
      print(conversations);
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> sendMessage() async {
    print(DateTime.now());
    Map<String, dynamic> newmsg = {
      'sender': useremail?.substring(0, useremail?.indexOf('@')),
      'receiver': oppositeUser?['email']
          .substring(0, oppositeUser?['email'].indexOf('@')),
      'message': sendmsg.text.trim(),
      'time': Timestamp.now()
    };
    conversations.add(newmsg);
    var db = FirebaseFirestore.instance;
    try {
      db.collection('Conversations').add(newmsg).then((documentSnapshot) =>
          print("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    String formattedTime = '${dateTime.toLocal()}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    var name = oppositeUser?['name'] ?? '';
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
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  bool user = oppositeUser?['email']
                      .contains(conversations[index]['sender']);
                  if (!user) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10.0, bottom: 2),
                        constraints:
                            const BoxConstraints(minWidth: 70, maxWidth: 300),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                conversations[index]['message'] as String,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                formatTimestamp(conversations[index]['time']),
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, bottom: 2),
                        constraints:
                            const BoxConstraints(minWidth: 70, maxWidth: 300),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                conversations[index]['message'] as String,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                formatTimestamp(conversations[index]['time']),
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
          TextField(
            controller: sendmsg,
            decoration: InputDecoration(
                labelText: "Message",
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    print('hi');
                    sendMessage();
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
