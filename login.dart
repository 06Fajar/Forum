import 'package:flutter/material.dart';
import 'package:flutter_application_1/apiresponse_check.dart';
import 'package:flutter_application_1/forum_page.dart';
import 'package:flutter_application_1/model/login_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _boxUser = Hive.box('LocalStorage');

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  // String username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),

            // logo
            Icon(
              Icons.lock,
              size: 100,
            ),

            const SizedBox(height: 50),

            Text('Silahkan Masuk',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                )),

            SizedBox(height: 25),

            //username textfield
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 148, 142, 142))),
                  fillColor: Color.fromARGB(255, 255, 254, 254),
                  filled: true,
                ),
              ),
            ),
            SizedBox(height: 10),

            //password textfield
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 148, 142, 142))),
                  fillColor: Color.fromARGB(255, 255, 254, 254),
                  filled: true,
                ),
                obscureText: true,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            // sign in
            GestureDetector(
              onTap: () {
                print('onTap pressed');
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  print('not blank');

                  setState(() {
                    loading = true;
                  });
                  getAPI(usernameController.text, passwordController.text)
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    if (value == true) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ForumPage();
                      }));
                    }
                  });
                } else
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("tidak dapat masuk")));
              },
              child: Container(
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: loading == true
                      ? CircularProgressIndicator()
                      : Text(
                          'Masuk',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<dynamic> getAPI(
    String enteredUsername,
    String enteredPassword,
  ) async {
    print('API start');
    var response = await http.post(
      Uri.parse('https://jakaset.jakarta.go.id/stagingaset/login'),
      headers: {'versionName': '1.5.1', 'versionCode': '91'},
      body: {'user': enteredUsername, 'password': enteredPassword},
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      final responseCheck = responseCheckFromMap(response.body);

      print('api 01');
      if (responseCheck.success == true) {
        print('api 02');
        final loginData = loginDataFromMap(response.body);
        _boxUser.put('token', loginData.token);
        _boxUser.put('username', loginData.user!.username);
        
        return true;
      } else {
        print('api false 1');
        return false;
      }
    } else {
      print('api false 2');
      return false;
    }
  }
}
