import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../home.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool visible = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value!.length == 0) {
                return "Email cannot be empty";
              }
              if (!RegExp(
                  "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                  .hasMatch(value)) {
                return ("Please enter a valid email");
              } else {
                return null;
              }
            },
            onSaved: (value) {
              emailController.text = value!;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                RegExp regex = new RegExp(r'^.{6,}$');
                if (value!.isEmpty) {
                  return "Password cannot be empty";
                }
                if (!regex.hasMatch(value)) {
                  return ("please enter valid password min. 6 character");
                } else {
                  return null;
                }
              },
              onSaved: (value) {
                passwordController.text = value!;
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  visible = true;
                });
                signIn(
                    emailController.text, passwordController.text);
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
