import 'package:basketball_project_owen_wang/Firebase/Auth.dart';
import 'package:basketball_project_owen_wang/History.dart';
import 'package:flutter/material.dart';
import '/SplashScreen.dart';
import '/Login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUp_pageState();
}

class _SignUp_pageState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Sign Up Page"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.check, size: 24),
                label: const Text("Submit", style: TextStyle(fontSize: 24)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange, width: 2), // Border color and width
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AuthenticationHelper()
                        .signUp(
                      email: _usernameController.text,
                      password: _passwordController.text,
                    )
                        .then((result) {
                      if (result == null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const History(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.login, size: 24),
                label: const Text("Login", style: TextStyle(fontSize: 24)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange, width: 2), // Border color and width
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Login_page(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
