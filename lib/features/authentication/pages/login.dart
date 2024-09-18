import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:note_app/features/authentication/pages/sign_up.dart';

import '../models/login_request.dart';
import '../state_management/login_cubit.dart';
import 'forget_password.dart';
import 'home.dart';
import 'otp_view.dart';

// Import the AuthController

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool _isObscured = true;


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            final user = state.LoginresponseModel.user;

            if (user == null || user.email == null || user.isVerified == null) {
              print('Error: User or some user data is null');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid login response data')),
              );
              return;
            }

            // Proceed with verified status
            if (user.isVerified!) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => OTPView(email: user.email!),
                ),
              );
            }
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },


        builder: (context, state) {
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,  // Ensure it fills the entire height
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/pw.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double widthFactor = constraints.maxWidth > 600 ? 0.4 : 0.9;
                      double contentWidth = screenWidth * widthFactor;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: screenHeight * 0.05),
                              _buildHeader(),
                              SizedBox(height: screenHeight * 0.03),
                              _buildFields(context, contentWidth),
                              SizedBox(height: screenHeight * 0.02),
                              _buildRememberMeAndForgotPassword(context, contentWidth),
                              SizedBox(height: screenHeight * 0.05),
                              _buildLoginButton(contentWidth),
                              SizedBox(height: screenHeight * 0.03),
                              _buildLoginLink(contentWidth),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Icon(Icons.menu, color: Colors.purple, size: 40),
      ],
    );
  }

  Widget _buildFields(BuildContext context, double contentWidth) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 40 : 30, // Adjust for small screens
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: contentWidth,
            child: TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),  // This makes the input text white
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.mail),
                prefixIconColor: Colors.white,
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: contentWidth,
            child: TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.white),  // This makes the input text white
              obscureText: _isObscured,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.white,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword(BuildContext context, double contentWidth) {
    return Container(
      width: contentWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value!;
                  });
                },
                activeColor: Colors.white,
              ),
              Text(
                'Remember me',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim(); // Get the email from the input
              //final e=loginController.login(email, password)
              if (email.isNotEmpty) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ForgetPassword(email: email)));// Navigate with the email
              } else {
                const snackBar = SnackBar(
                  content: Text('Enter your email'),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(color: Colors.purple, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(double contentWidth) {
    return Container(
      width: contentWidth,
      child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Trigger login function from LoginController
              // Validate the fields before calling the login API
              if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email and password cannot be empty')),
                );
                return;
              }

              // Proceed with the login API call
              final loginRequest = LoginRequestModel(
                email: emailController.text,
                password: passwordController.text,
              );
              print('the request is :${loginRequest}');
              context.read<LoginCubit>().Login(loginRequest);
            },
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),


    );
  }

  Widget _buildLoginLink(double contentWidth) {
    return Container(
      width: contentWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              //direct him to sign up page.
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RegistrationPage()));
            },
            child: Text('Sign Up', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}
