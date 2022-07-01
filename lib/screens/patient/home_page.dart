import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/carousel_slider.dart';
import 'package:health_app/firestore_data/notification_list.dart';
import 'package:health_app/firestore_data/search_list.dart';
import 'package:health_app/firestore_data/top_rated_list.dart';
import 'package:health_app/model/card_model.dart';
import 'package:health_app/screens/explore_list.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = TextEditingController();
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message = "Good";
    DateTime now = DateTime.now();
    String currentHour = DateFormat('kk').format(now);
    int hour = int.parse(currentHour);

    setState(
      () {
        if (hour >= 5 && hour < 12) {
          message = 'Good Morning';
        } else if (hour >= 12 && hour <= 17) {
          message = 'Good Afternoon';
        } else {
          message = 'Good Evening';
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[Container()],
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                //width: MediaQuery.of(context).size.width/1.3,
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: GoogleFonts.lato(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                width: 55,
              ),
              IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.notifications_active),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => const NotificationList()));
                },
              ),
            ],
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text(
                      "Hello ${user?.displayName}",
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20, bottom: 25),
                    child: Text(
                      "Let's Find Your\nDoctor",
                      style: GoogleFonts.lato(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.search,
                      controller: _doctorName,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search doctor',
                        hintStyle: GoogleFonts.lato(
                          color: Colors.black26,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            color: Colors.white,
                            icon: const Icon(Icons.search),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      onFieldSubmitted: (String value) {
                        setState(
                          () {
                            value.isEmpty
                                ? Container()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchList(
                                        searchKey: value,
                                      ),
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 23, bottom: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "We care for you",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Carouselslider(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Specialists",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.only(top: 14),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        //print("images path: ${cards[index].cardImage.toString()}");
                        return Container(
                          margin: const EdgeInsets.only(right: 14),
                          height: 150,
                          width: 140,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(cards[index].cardBackground),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: const Offset(3, 3),
                                ),
                              ]
                              // image: DecorationImage(
                              //   image: AssetImage(cards[index].cardImage),
                              //   fit: BoxFit.fill,
                              // ),
                              ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExploreList(
                                          type: cards[index].doctor,
                                        )),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 29,
                                    child: Icon(
                                      cards[index].cardIcon,
                                      size: 26,
                                      color: Color(cards[index].cardBackground),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    cards[index].doctor,
                                    style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Top Rated",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: const TopRatedList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
