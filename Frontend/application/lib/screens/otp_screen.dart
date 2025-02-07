import 'package:flutter/material.dart';
import 'home_screen.dart'; // ✅ Import your HomeScreen file

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
  List.generate(5, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // ✅ Prevents default back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ✅ Aligns back button & title
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'أدخل الرمز',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpeg', // ✅ Ensure correct path
              fit: BoxFit.contain, // ✅ Covers full screen
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subtitle (Below Title)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'تم إرسال الرمز لرقم هاتفك',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 160),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                        (index) => Container(
                      width: 59,
                      height: 59,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 24),
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 4) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 62),

                // Resend Code & Timer (Same Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '00:20',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(width: 10), // ✅ Spacing between text
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(), // ✅ Navigates to HomeScreen
                          ),
                        );
                      },
                      child: const Text(
                        'إعادة إرسال الرمز',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // ✅ Changed color for clickable effect
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
