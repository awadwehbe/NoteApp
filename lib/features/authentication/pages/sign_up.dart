import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login.dart';


// First, create the StatefulWidget class for RegistrationPage
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool rememberMe = false;
  bool _isObscured = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/pw.webp', // Path to your image asset
                fit: BoxFit.cover,        // Adjusts the image to cover the entire screen
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double widthFactor = constraints.maxWidth > 600 ? 0.4 : 0.8;
                  double contentWidth = MediaQuery.of(context).size.width * widthFactor;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            _buildHeader(),
                            SizedBox(height: 30),
                            _buildFields(context, contentWidth), // Using contentWidth
                            SizedBox(height: 10),
                            _buildRememberMeAndForgotPassword(context, contentWidth),
                            SizedBox(height: 20),
                            _buildSignUpButton(contentWidth),
                            SizedBox(height: 20),
                            _buildLoginLink(contentWidth),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  }

  // Build header function
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Icon(Icons.menu, color: Colors.purple, size: 40),
      ],
    );
  }

  // Build fields function with consistent width
  Widget _buildFields(BuildContext context, double contentWidth) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create an account',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20),
          _buildTextField(_firstNameController, 'First Name', Icons.person, contentWidth),
          SizedBox(height: 20),
          _buildTextField(_lastNameController, 'Last Name', Icons.person, contentWidth),
          SizedBox(height: 20),
          _buildTextField(_emailController, 'Email', Icons.mail, contentWidth),
          SizedBox(height: 20),
          _buildPasswordField(_passwordController, 'Password', contentWidth),
          SizedBox(height: 20),
          _buildPasswordField(_confirmPasswordController, 'Confirm Password', contentWidth),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, double contentWidth) {
    return Container(
      width: contentWidth,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(icon),
          prefixIconColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText, double contentWidth) {
    return Container(
      width: contentWidth,
      child: TextField(
        controller: controller,
        obscureText: _isObscured,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.lock),
          prefixIconColor: Colors.white,
          hintText: hintText,
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
    );
  }

  // Updated remember me and forgot password row
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
              // Handle forgot password logic here
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

  Widget _buildSignUpButton(double contentWidth) {
    return Container(
      width: contentWidth,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // Debugging: Log the user input data
            print('Sign Up button pressed');


            // Fetch user input data


            // Debugging: Log the user data

          },
          child: Text('SIGN UP', style: TextStyle(fontSize: 18, color: Colors.purple)),
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
          Text('Already have an account?'),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
    );
  }
}