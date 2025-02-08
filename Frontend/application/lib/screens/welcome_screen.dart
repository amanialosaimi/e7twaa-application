import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
           Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpeg',
              fit: BoxFit.contain,
            ),
          ),

           Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.2),
            ),
          ),

           Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Image.asset(
                  'assets/Logo.jpeg',
                  width: 100,
                ),

                const SizedBox(height: 10),

                // Title
                const Text(
                  'احتواء',
                  style: TextStyle(
                    fontSize: 36,
                    color: Color(0xFF939597),
                  ),
                ),

                const SizedBox(height: 50),

                 const Text(
                  'مرحبًا بالمتطوع الكفو',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF939597),
                  ),
                ),

                const SizedBox(height: 20),

                 SizedBox(
                  width: 320,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBB040),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
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
}
