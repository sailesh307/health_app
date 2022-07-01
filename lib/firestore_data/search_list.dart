import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/screens/patient/doctor_profile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SearchList extends StatefulWidget {
  final String searchKey;

  const SearchList({Key? key, required this.searchKey}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .orderBy('name')
              .startAt(['Dr. ${widget.searchKey}']).endAt(
                  ['Dr. ${widget.searchKey}\uf8ff']).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.size == 0
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Doctor found!',
                          style: GoogleFonts.lato(
                            color: Colors.blue[800],
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Image(
                          image: AssetImage('assets/error-404.jpg'),
                          height: 250,
                          width: 250,
                        ),
                      ],
                    ),
                  )
                : Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doctor = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: Card(
                            color: Colors.blue[50],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 9,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorProfile(
                                        doctor: doctor['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(doctor['profilePhoto']),
                                      backgroundColor: Colors.blue,
                                      radius: 25,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doctor['name'],
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          doctor['specialization'],
                                          style: GoogleFonts.lato(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Typicons.star_full_outline,
                                              size: 20,
                                              color: Colors.indigo[400],
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              doctor['rating'].toString(),
                                              style: GoogleFonts.lato(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                          ],
                                        ),
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
          },
        ),
      ),
    );
  }
}
