import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginapi/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Welcome LogIn Screen',
                    style: TextStyle(fontSize: 30),
                  ),
                  textSelection(),
                  buttonSection()
                ],
              ),
      ),
    );
  }

  Container textSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          textEmail("Email", Icons.email),
          const SizedBox(
            height: 20,
          ),
          textPassword("Password", Icons.lock)
        ],
      ),
    );
  }

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  Container buttonSection() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () {
          setState(() {
            _isLoading = true;
          });
          signIn(emailController.text, passwordController.text);
        },
        child: const Text(
          "Sign In",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  signIn(String email, password) async {
    Map data = {'email': email, 'password': password};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response =
        await http.post(Uri.parse("https://reqres.in/api/login"), body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) {
          return const Homepage();
        }), (route) => false);
      });
    } else {
      print(response.body);
    }
  }

  TextFormField textEmail(String title, IconData icon) {
    return TextFormField(
      controller: emailController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.black),
          icon: Icon(icon)),
    );
  }

  TextFormField textPassword(String title, IconData icon) {
    return TextFormField(
      controller: passwordController,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.black),
          icon: Icon(icon)),
    );
  }
}
