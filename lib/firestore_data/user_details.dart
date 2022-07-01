import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/globals.dart';
import 'package:health_app/model/update_user_details.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  // map of all the details
  Map<String, dynamic> details = {};

  Future<void> _getUser() async {
    user = _auth.currentUser!;

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(isDoctor ? 'doctor' : 'patient')
        .doc(user.uid)
        .get();

    setState(() {
      details = snap.data() as Map<String, dynamic>;
    });
    print(snap.data());
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        controller: ScrollController(),
        shrinkWrap: true,
        itemCount: details.length,
        itemBuilder: (context, index) {
          String key = details.keys.elementAt(index);
          String value =
              details[key] == null ? 'Not Added' : details[key].toString();
          String label = key[0].toUpperCase() + key.substring(1);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: InkWell(
              splashColor: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateUserDetails(
                      label: label,
                      field: key,
                      value: value,
                    ),
                  ),
                ).then((value) {
                  // reload page
                  _getUser();
                  setState(() {});
                });
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.substring(0, min(20, value.length)),
                        style: GoogleFonts.lato(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
