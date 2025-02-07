import 'package:flutter/material.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 200),

                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right:0),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Text(
                    'أدخل الهوية الوطنية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                 Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '111*********',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 30),

                 Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Text(
                    'رقم الجوال',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                 Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        '+966',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '5X XXX XXXX',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                 SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OtpScreen(),
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
                      'المتابعة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                 Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 100,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
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
