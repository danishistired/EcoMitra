import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  void _navigateToHome() {
    String username = _usernameController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter Your Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Username",
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToHome,
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
