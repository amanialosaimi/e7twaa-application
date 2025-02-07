import 'package:flutter/material.dart';
import 'Volunteer_Journey.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
     print('Tapped index: $index');

     if (index == _selectedIndex) return;

     switch (index) {
      case 0:
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 1:
         setState(() {
          _selectedIndex = index;
        });
        break;
      case 2:
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VolunteerJourneyScreen()),
        );
        break;
      default:
         break;
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
                    children: [
                      const Text(
                        'احتواء',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/Logo.jpeg',
                        width: 40,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                 Container(
                  padding: const EdgeInsets.only(right: 23),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'مرحبًا بك لمياء',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  padding: const EdgeInsets.only(right: 23),
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'ساهمت بـ 100 ساعة تطوعية في كسوة فرح',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 80),
                 Center(
                  child: Container(
                    width: 330,
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            width: 130,
                            height: 130,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBB040),
                              shape: BoxShape.circle,
                             ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.touch_app, color: Colors.white, size: 35),
                                SizedBox(height: 5),
                                Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(Icons.access_time_outlined, '09:00 PM', 'تسجيل الدخول', Colors.black),
                            _buildStatItem(Icons.access_time_outlined, '12:00 PM', 'تسجيل الخروج', Colors.black),
                            _buildStatItem(Icons.access_time_outlined, '03:00', 'ساعات اليوم', Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String time, String label, Color iconColor) {
    return Column(
      children: [
        Icon(icon, size: 30, color: iconColor),
        const SizedBox(height: 5),
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
