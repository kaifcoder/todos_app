import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          try {
                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            print(userCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'unknown') {
                              print('Input all the fields');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'user is already registered. please log in');
                            } else if (e.code == 'weak-password') {
                              print('please enter a strong password');
                            } else if (e.code == 'invalid-email') {
                              print('Invalid Email');
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.lightBlueAccent),
                        ),
                        child: const Text("Register",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  );

                default:
                  return const Text("Loading...");
              }
            },
          ),
        ));
  }
}
