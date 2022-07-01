import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:health_app/globals.dart';

class UpdateUserDetails extends StatefulWidget {
  final String label;
  final String field;
  final String value;
  const UpdateUserDetails(
      {Key? key, required this.label, required this.field, required this.value})
      : super(key: key);

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  final TextEditingController _textcontroller = TextEditingController();
  late FocusNode f1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? userID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
    userID = user!.uid;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    _textcontroller.text = widget.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        // back button
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.indigo,
          ),
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: GoogleFonts.lato(
              color: Colors.indigo,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: _textcontroller,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onFieldSubmitted: (String data) {
                  _textcontroller.text = data;
                },
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter the ${widget.label}';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  updateData();
                  Navigator.of(context).pop(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Colors.indigo.withOpacity(0.9),
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    FirebaseFirestore.instance
        .collection(isDoctor ? 'doctor' : 'patient')
        .doc(userID)
        .set({
      widget.field: _textcontroller.text,
    }, SetOptions(merge: true));
    if (widget.field.compareTo('name') == 0) {
      await user!.updateDisplayName(_textcontroller.text);
    }
  }
}
