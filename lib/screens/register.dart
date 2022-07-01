import 'dart:math';
import 'package:health_app/globals.dart' as globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/screens/sign_in.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  int type = -1;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                    child: _signUp(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUp() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 50),
              child: Text(
                'Sign up',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // display name
            TextFormField(
              focusNode: f1,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _displayName,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Name',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f1.unfocus();
                FocusScope.of(context).requestFocus(f2);
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter the Name';
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),

            // email
            TextFormField(
              focusNode: f2,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Email',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f2.unfocus();
                if (_passwordController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f3);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Email';
                } else if (!emailValidate(value)) {
                  return 'Please enter correct Email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),

            // password
            TextFormField(
              focusNode: f3,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              //keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Password',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f3.unfocus();
                if (_passwordConfirmController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(f4);
                }
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),
            const SizedBox(
              height: 25.0,
            ),

            // confirm password
            TextFormField(
              focusNode: f4,
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              controller: _passwordConfirmController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[350],
                hintText: 'Confirm Password',
                hintStyle: GoogleFonts.lato(
                  color: Colors.black26,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onFieldSubmitted: (value) {
                f4.unfocus();
              },
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the Password';
                } else if (value.compareTo(_passwordController.text) != 0) {
                  return 'Password not Matching';
                } else {
                  return null;
                }
              },
              obscureText: true,
            ),

            const SizedBox(
              height: 20,
            ),
            // type of account
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        primary: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        side: BorderSide(
                          width: 5.0,
                          color: Colors.black38,
                          style:
                              type == 0 ? BorderStyle.solid : BorderStyle.none,
                        )),
                    child: Text(
                      "Doctor",
                      style: GoogleFonts.lato(
                        color: type == 0 ? Colors.black38 : Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'or',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      primary: Colors.grey[350],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      side: BorderSide(
                        style: type == 1 ? BorderStyle.solid : BorderStyle.none,
                        width: 5,
                        color: Colors.black38,
                      ),
                    ),
                    child: Text(
                      "Patient",
                      style: GoogleFonts.lato(
                        color: type == 1 ? Colors.black38 : Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // signin button
            Container(
              padding: const EdgeInsets.only(top: 25.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && type != -1) {
                      showLoaderDialog(context);
                      _registerAccount();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    primary: Colors.indigo[900],
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // divider
            Container(
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                thickness: 1.5,
              ),
            ),

            // signin page option
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.lato(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () => _pushPage(context, const SignIn()),
                    child: Text(
                      'Sign in',
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Navigator.pop(context);
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: GoogleFonts.lato(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context);
        FocusScope.of(context).requestFocus(f2);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Error!",
        style: GoogleFonts.lato(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Email already Exists",
        style: GoogleFonts.lato(),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool emailValidate(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }

  void _registerAccount() async {
    User? user;
    UserCredential? credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } catch (error) {
      if (error.toString().compareTo(
              '[firebase_auth/email-already-in-use] The email address is already in use by another account.') ==
          0) {
        showAlertDialog(context);
      }
      print(error.toString());
    }
    user = credential!.user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateDisplayName(_displayName.text);

      String name =
          (type == 0) ? 'Dr. ${_displayName.text}' : _displayName.text;
      String accountType = (type == 0) ? 'doctor' : 'patient';
      FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'type': accountType,
        'email': user.email,
      }, SetOptions(merge: true));

      // set data according to type (doctor or patient)
      Map<String, dynamic> mp = {
        'id': user.uid,
        'type': accountType,
        'name': name,
        'birthDate': null,
        'email': user.email,
        'phone': null,
        'bio': null,
        'address': null,
        'profilePhoto': null,
      };
      // if doctor
      if (type == 0) {
        mp.addAll({
          'openHour': "09:00",
          'closeHour': "21:00",
          'rating': double.parse(
              (3 + Random().nextDouble() * 1.9).toStringAsPrecision(2)),
          'specification': null,
          'specialization': 'general',
        });
        globals.isDoctor = true;
      }

      // sep
      FirebaseFirestore.instance.collection(accountType).doc(user.uid).set(mp);

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    } else {}
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
