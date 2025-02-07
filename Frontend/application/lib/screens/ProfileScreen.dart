import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'volunteer_journey.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

   void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const VolunteerJourneyScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFBB040),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: '',
          ),
        ],
      ),
      body: Stack(
        children: [
           Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/background_image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFF939597), width: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'الملف الشخصي',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                 Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'لمياء السحيباني',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          'عضو نشط',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                 _buildProfileOption(
                  'بياناتي ',
                  Icons.assignment_ind_outlined,
                  onTap: () {
                     print("بياناتي tapped");
                  },
                ),
                _buildProfileOption(
                  'الشهادات ',
                  Icons.insert_drive_file_outlined,
                  onTap: () {
                     print("الشهادات tapped");
                  },
                ),
                _buildProfileOption(
                  'اتصل بنا ',
                  Icons.phone_outlined,
                  onTap: () {
                     print("اتصل بنا tapped");
                  },
                ),
                _buildProfileOption(
                  'تسجيل الخروج ',
                  Icons.exit_to_app,
                  color: Colors.red,
                  onTap: () {
                     print("تسجيل الخروج tapped");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildProfileOption(String title, IconData icon,
      {Color color = Colors.black, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          children: [
             Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: color == Colors.red ? Colors.red : const Color(0xFFFBB040),
              ),
            ),
             Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: color == Colors.red ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(icon, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
