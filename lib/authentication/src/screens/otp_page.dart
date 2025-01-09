import 'package:flutter/material.dart';
import '../widgets/popupDialogDefault.dart';
import 'login_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_buddy/constants.dart' as Constants;

class OTPPage extends StatefulWidget {

  final String email;
  final String name;
  final String password;
  final String? gender;
  final int age;
  final double weight;
  final double height;

  const OTPPage({super.key, required this.email, required this.name,required this.password,required this.gender, required this.age,required this.weight,
    required this.height});

  @override
  _OTPPageState createState() => _OTPPageState();
}



class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  Timer? _timer;
  int _remainingTime = 120; // 2 minutes in seconds
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    sendOtp(widget.email);
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
      _remainingTime = 120; // Reset the timer to 2 minutes
    });

    _timer?.cancel(); // Cancel any previous timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResend = true; // Allow user to resend after 2 minutes
        });
      }
    });
  }

  Future<void> _register() async {

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(Constants.BaseUrl + Constants.AunthenticationPort + '/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': widget.name,
          'email': widget.email,
          'password': widget.password,
          'password_confirmation': widget.password,
          'gender': widget.gender,
          'age': widget.age,
          'weight': widget.weight,
          'height': widget.height,
        }),
      );

      if (response.statusCode == 201) {
        showPopupDialog(
          context,
          'Registration successful! ',
          onOkPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Registration failed';
        showPopupDialog(context, errorMessage);
      }

    } catch (e) {
      showPopupDialog(context, 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  void _validateOTP() {
    final enteredOTP = _otpControllers.map((controller) => controller.text).join();
    if (enteredOTP.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      verifyOtp(enteredOTP,widget.email).then((_) {
        setState(() {
          _isLoading = false;
        });

      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
        showPopupDialog(context, "Invalid OTP! Please try again.");
      });
    } else {
      showPopupDialog(context, "Invalid OTP! Please try again.");
    }
  }

  Future<void> sendOtp(String email) async {
    final url = Constants.BaseUrl + Constants.AunthenticationPort + '/send-otp'; // Change to your Laravel backend URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('OTP sent to email!');
      } else {
        print('Failed to send OTP: ${response.body}');
      }
    } catch (error) {
      print('Error sending OTP: $error');
    }
  }

  Future<void> verifyOtp(String otp, String email) async {
    final url = Constants.BaseUrl + Constants.AunthenticationPort + '/verify-otp'; // Change to your Laravel backend URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'otp': otp,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {

        _register();
        // Proceed with the next step (e.g., navigate to the next screen)
      } else {
        showPopupDialog(context, "Invalid OTP! Please try again.");
        // Show error to the user
      }
    } catch (error) {
      showPopupDialog(context, "Error verifying OTP: $error");
    }
  }

  // Function to show popup messages
  void showPopupDialog(BuildContext context, String message, {VoidCallback? onOkPressed}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopupDialog(
          message: message,
          onOkPressed: onOkPressed,
        );
      },
    );
  }

  void _resendOTP() {
    if (_canResend) {
      sendOtp(widget.email);
      _startTimer(); // Restart the timer for new OTP resend
      showPopupDialog(context, "OTP resent successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/BACKGROUND.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter OTP',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                    (index) => _buildOTPTextField(index),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _canResend
                  ? "You can resend OTP now."
                  : "Resend OTP in ${_remainingTime ~/ 60}:${_remainingTime % 60}".padLeft(2, '0'),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _canResend ? _resendOTP : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                backgroundColor: _canResend ? Colors.pink.shade100 : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Resend OTP"),
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _validateOTP,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.pink.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPTextField(int index) {
    return Container(
      width: 40,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
