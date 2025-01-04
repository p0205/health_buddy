import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/sport/sport_main/blocs/sport_main_bloc.dart';
import 'package:health_buddy/meal_and_sport/src/user/blocs/user_event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../meal_and_sport/src/calories_counter/calories_counter_main/blocs/calories_counter_main_bloc.dart';
import '../../../meal_and_sport/src/user/blocs/user_bloc.dart';
import '../widgets/buttonDefault.dart';
import '../widgets/textFieldDefault.dart';
import '../widgets/textFieldPassword.dart';
import 'first_register_page.dart';
import 'main_menu_screen.dart';
import '../widgets/loadingDefault.dart';
import '../widgets/popupDialogDefault.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      setState(() {
        _isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'];
          final userId = data['userId'];
          final email = data['email'];
          final name = data['name'];

          // Guard context usage with mounted check
          if (mounted) {
            final userBloc = context.read<UserBloc>(); // Safe to use context here
            userBloc.add(LoginSuccessEvent(userId: userId, email: email, name: name,token:token));
            final caloriesBloc = context.read<CaloriesCounterMainBloc>();
            caloriesBloc.add(LoadUserIdAndDateEvent(userId: userId, date: DateTime.now()));
            final sportBloc = context.read<SportMainBloc>();
            sportBloc.add(SportLoadUserIdAndDateEvent(userId: userId, date: DateTime.now()));
            final prefs = await SharedPreferences.getInstance();
            if (_rememberMe) {
              await prefs.setString('email', email);
              await prefs.setString('password', password);
            } else {
              await prefs.remove('email');
              await prefs.remove('password');
            }


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                MultiBlocProvider(
                  providers: [
                    BlocProvider<SportMainBloc>.value(
                      value: context.read<SportMainBloc>(),
                    ),
                    BlocProvider<CaloriesCounterMainBloc>.value(
                      value: context.read<CaloriesCounterMainBloc>(),
                    ),
                  ],
                  child: MainMenuScreen(token: token),
                  ),
                )

            );
          }
        } else {
          final error = jsonDecode(response.body)['message'];
          if (mounted) {
            showPopupDialog(context, error);
          }
        }
      } catch (error) {
        if (mounted) {
          showPopupDialog(context, 'Failed to login: $error');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BACKGROUND.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 45),
              Center(
                child: Text(
                  'Health Buddy',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    shadows: [
                      Shadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/LOGO.png',
                                width: 180,
                                height: 180,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 45.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.0),
                          DefaultTextFormField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          PasswordTextFormField(
                            controller: _passwordController,
                            labelText: 'Password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remember Me',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          _isLoading
                              ? LoadingIndicator()
                              : DefaultButton(
                            text: 'Login',
                            onPressed: _login,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FirstRegisterPage()),
                              );
                            },
                            child: Text(
                              'Don’t have an account? Register here',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF1B5E20),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}