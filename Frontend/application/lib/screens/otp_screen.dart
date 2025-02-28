import 'package:flutter/material.dart';
import 'home_screen.dart';  
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController()); // Fix: 4 controllers

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("خطأ"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("حسناً"),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser(String otpCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(otpCode);
    final String nationalId = prefs.getString('NationalID') ?? 'User';
    final String phoneNumber = prefs.getString('PhoneNumber') ?? 'User';

    setState(() => isLoading = true);

    try {
      // Ensure apiService is defined
      final response = await apiService.login(nationalId, phoneNumber, otpCode);

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showErrorDialog("بيانات تسجيل الدخول غير صحيحة");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,  
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,  
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
              'assets/background_image.jpeg',  
              fit: BoxFit.contain,  
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
                    'الرجاء ادخال رمز التسجيل الخاص بك',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 160),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4, // Ensure only 4 fields
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
                          if (value.isNotEmpty) {
                            if (index < 3) { // Ensure correct focus handling
                              FocusScope.of(context).nextFocus();
                            } else {
                              // Check if all fields are filled
                              String otpCode = _controllers.map((c) => c.text).join();
                              if (otpCode.length == 4) { // Validate for 4-digit OTP
                                loginUser(otpCode);
                              }
                            }
                          }
                        },
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
