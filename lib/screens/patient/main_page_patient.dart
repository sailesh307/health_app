import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_app/screens/chat/chats.dart';
import 'package:health_app/screens/my_profile.dart';
import 'package:health_app/screens/patient/doctor_list.dart';
import 'package:health_app/screens/patient/home_page.dart';
import 'package:health_app/screens/patient/appointments.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class MainPagePatient extends StatefulWidget {
  const MainPagePatient({Key? key}) : super(key: key);

  @override
  State<MainPagePatient> createState() => _MainPagePatientState();
}

class _MainPagePatientState extends State<MainPagePatient> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const DoctorsList(),
    const Appointments(),
    const Chats(),
    const MyProfile(),
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: Colors.grey.shade300,
                hoverColor: Colors.grey.shade100,
                haptic: true,
                tabBorderRadius: 20,
                gap: 5,
                activeColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 200),
                tabBackgroundColor: Colors.blue.withOpacity(0.7),
                textStyle: GoogleFonts.lato(
                  color: Colors.white,
                ),
                tabs: const [
                  GButton(
                    iconSize: 28,
                    icon: Icons.home,
                    // text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    // text: 'Search',
                  ),
                  GButton(
                    iconSize: 28,
                    icon: Typicons.calendar,
                    // text: 'Appointments',
                  ),
                  GButton(
                    iconSize: 28,
                    icon: Icons.chat,
                    // text: 'Chat',
                  ),
                  GButton(
                    iconSize: 28,
                    icon: Typicons.user,
                    // text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
