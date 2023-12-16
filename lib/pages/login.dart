import 'package:chatify/pages/home.dart';
import 'package:chatify/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool visible = false;
  var icon = Icons.visibility_off;
  void verifyLogin() async {
    String userEmail = email.text.trim();
    String userPassword = password.text.trim();
    if (userEmail == "" || userPassword == "") {
      print("fill all fields");
    } else {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 16,
              ),
              const Center(
                  child: Text("Chatify", style: TextStyle(fontSize: 35))),
              Container(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                        labelText: "Enter Email",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2))),
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    controller: password,
                    obscureText: visible,
                    decoration: InputDecoration(
                        labelText: "Enter Password",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2)),
                        suffixIcon: IconButton(
                          icon: Icon(icon),
                          onPressed: () {
                            if (visible == true) {
                              visible = false;
                              icon = Icons.visibility;
                            } else {
                              visible = true;
                              icon = Icons.visibility_off;
                            }
                            setState(() {});
                          },
                        )),
                  ),
                  Container(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: Size.zero, // Set this
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            print('hi');
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () => {
                      print(
                        'PRESSED ${email.text.toString()} ${password.text.toString()}',
                      ),
                      verifyLogin()
                    },
                    child: const Text('Login'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()));
                      },
                      child: const Text('new user? signup',
                          style: TextStyle(fontSize: 10)))
                ],
              ),
            ],
          ),
        ));
  }
}
