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
  ScrollController scrollController = ScrollController();
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
      if (mainUser != opposite) {
        querySnapshot = await db
            .collection('Conversations')
            .where('sender', isEqualTo: opposite)
            .where('receiver', isEqualTo: mainUser)
            .get();
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          conversations.add(docSnapshot.data());
        }
      }
      conversations.sort((a, b) => a['time'].compareTo(b['time']));
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
    scrollToBottom();
  }

  Future<void> sendMessage() async {
    if (sendmsg.text.trim() == '') {
      return;
    }
    print(Timestamp.now());
    Map<String, dynamic> newmsg = {
      'sender': useremail?.substring(0, useremail?.indexOf('@')),
      'receiver': oppositeUser?['email']
          .substring(0, oppositeUser?['email'].indexOf('@')),
      'message': sendmsg.text.trim(),
      'time': Timestamp.now()
    };
    conversations.add(newmsg);
    setState(() {});
    var db = FirebaseFirestore.instance;
    try {
      await db.collection('Conversations').add(newmsg).then(
          (documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"));
      sendmsg.clear();
    } catch (e) {
      print(e);
    }
    scrollToBottom();
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    String s = formatTime(dateTime);
    return s;
  }

  String formatTime(DateTime time) {
    int t = time.hour;
    String zone = 'am';
    if (time.hour > 12) {
      t -= 12;
      zone = 'pm';
    }
    return "$t:${_twoDigits(time.minute)}$zone";
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  String formatDate(Timestamp timestamp) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
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
                controller: scrollController,
                itemBuilder: (context, index) {
                  bool user = oppositeUser?['email']
                      .contains(conversations[index]['sender']);
                  if (!user) {
                    return Column(
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set the border color here
                              width: 2.0,           // Set the border width here
                            ),
                          borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: (index == 0)
                              ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(formatDate(conversations[index]['time']),),
                              )
                              : null,
                        ),
                        Container(
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set the border color here
                              width: 2.0,           // Set the border width here
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: (index != 0 &&
                                  formatDate(conversations[index]['time']) !=
                                      formatDate(
                                          conversations[index - 1]['time']))
                              ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(formatDate(conversations[index]['time'])),
                              )
                              : null,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin:
                                const EdgeInsets.only(right: 10.0, bottom: 2),
                            constraints: const BoxConstraints(
                                minWidth: 70, maxWidth: 300),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    conversations[index]['message'] as String,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    formatTimestamp(
                                        conversations[index]['time']),
                                    style: const TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set the border color here
                              width: 2.0,           // Set the border width here
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: (index == 0)
                              ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(formatDate(conversations[index]['time'])),
                              )
                              : null,
                        ),
                        Container(
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Set the border color here
                              width: 2.0,           // Set the border width here
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: (index != 0 &&
                                  formatDate(conversations[index]['time']) !=
                                      formatDate(
                                          conversations[index - 1]['time']))
                              ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(formatDate(conversations[index]['time'])),
                              )
                              : null,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, bottom: 2),
                            constraints: const BoxConstraints(
                                minWidth: 70, maxWidth: 300),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    conversations[index]['message'] as String,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    formatTimestamp(
                                        conversations[index]['time']),
                                    style: const TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 30,
                child: IconButton(
                    onPressed: () => scrollToBottom(),
                    icon: const Icon(Icons.arrow_downward)),
              )),
          TextField(
            controller: sendmsg,
            decoration: InputDecoration(
                labelText: "Message",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    sendMessage();
                  },
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2))),
          )
        ],
      ),
    );
  }
}
