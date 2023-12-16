import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatify/pages/login.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  void createAccount() async {
    String userEmail = email.text.trim();
    String userName = name.text.trim();
    String userPassword = password.text.trim();
    String userCPassword = cpassword.text.trim();
    if (userEmail == "" ||
        userPassword == "" ||
        userCPassword == "" ||
        userName == "") {
      print("fill all fields");
    } else if (userCPassword != userPassword) {
      print("cpassword is not same as password");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userEmail, password: userPassword);
        print('created');
      } on FirebaseAuthException catch (e) {
        print(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 60,
          ),
          const Center(child: Text("Chatify", style: TextStyle(fontSize: 25))),
          Container(
            height: 40,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InputBox(name, "User Name"),
              Container(
                height: 10,
              ),
              InputBox(email, "Email"),
              Container(
                height: 10,
              ),
              InputBox(password, 'Password'),
              Container(
                height: 10,
              ),
              InputBox(cpassword, 'Confirm Password'),
              Container(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => {
                        print(
                            'PRESSED ${name.text.toString()} ${email.text.toString()} ${password.text.toString()}'),
                        createAccount()
                      },
                  child: Text('Login')),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: const Text(
                    'have an account? login',
                    style: TextStyle(fontSize: 10),
                  ))
            ],
          ),
        ],
      ),
    ));
  }
}

class InputBox extends StatefulWidget {
  TextEditingController type;
  String fieldName;
  bool isPassword = false;

  InputBox(this.type, this.fieldName, {super.key}) {
    if (fieldName.contains('Password')) {
      isPassword = true;
    }
  }

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  bool visible = false;

  var icon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.type,
      obscureText: visible,
      decoration: InputDecoration(
          labelText: "Enter ${widget.fieldName}",
          suffixIcon: (widget.isPassword)
              ? IconButton(
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
                )
              : const Text(''),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2))),
    );
  }
}
