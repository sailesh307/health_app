import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_app/globals.dart';
import 'package:health_app/screens/doctor/main_page_doctor.dart';
import 'package:health_app/screens/patient/main_page_patient.dart';

class DoctorOrPatient extends StatefulWidget {
  const DoctorOrPatient({Key? key}) : super(key: key);

  @override
  State<DoctorOrPatient> createState() => _DoctorOrPatientState();
}

class _DoctorOrPatientState extends State<DoctorOrPatient> {
  bool _isLoading = true;
  void _setUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    var basicInfo = snap.data() as Map<String, dynamic>;

    isDoctor = basicInfo['type'] == 'doctor' ? true : false;
    print('isdoctor : $isDoctor');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _setUser();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : isDoctor
            ? const MainPageDoctor()
            : const MainPagePatient();
  }
}
