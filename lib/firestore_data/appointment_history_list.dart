import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/globals.dart';
import 'package:intl/intl.dart';

class AppointmentHistoryList extends StatefulWidget {
  const AppointmentHistoryList({Key? key}) : super(key: key);

  @override
  State<AppointmentHistoryList> createState() => _AppointmentHistoryListState();
}

class _AppointmentHistoryListState extends State<AppointmentHistoryList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late String _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser!;
  }

  String _dateFormatter(String timestamp) {
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(timestamp));
    return formattedDate;
  }

  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection('all')
        .doc(docID)
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .doc(user.uid)
              .collection('all')
              .orderBy('date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.size == 0
                ? Text(
                    'History Appears here...',
                    style: GoogleFonts.lato(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            padding: const EdgeInsets.only(left: 10, top: 5),
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blueGrey[50],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // doctor name
                                Text(
                                  '${index + 1}. ${isDoctor ? '${document['patientName']}' : '${document['doctorName']}'}',
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                  ),
                                ),
                                // date
                                Text(
                                  _dateFormatter(
                                      document['date'].toDate().toString()),
                                  style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                // reason
                                Text(
                                    document['description'] ?? 'No description')
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
