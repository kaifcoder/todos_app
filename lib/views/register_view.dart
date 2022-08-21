import 'package:flutter/material.dart';
import 'package:todos_app/constants/routes.dart';
import 'package:todos_app/services/auth/auth_exceptions.dart';
import 'package:todos_app/services/auth/auth_service.dart';
import 'package:todos_app/utilities/dialogs/error_dialog.dart';

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
        child: Column(
          children: [
            const SizedBox(
              height: 30.0,
            ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyemailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                      context, 'please enter a strong password');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                      context, 'user is already registered. please log in');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'Invalid Email');
                } on UnknownAuthException {
                  await showErrorDialog(context, 'Input all the fields');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Failed to register');
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
              ),
              child: const Text("Register",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Log In!',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
