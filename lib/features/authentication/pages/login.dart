import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the AuthController

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool _isObscured = true;

  // Inject LoginController instead of AuthController

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/pw.webp',
              fit: BoxFit.cover, // Ensures the image takes up the whole screen
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double widthFactor = constraints.maxWidth > 600 ? 0.4 : 0.9;
                double contentWidth = screenWidth * widthFactor;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight, // Ensures full-screen height
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: screenHeight * 0.05),
                      child: Center(
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
              // Trigger login function from LoginController

            },
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),
        )

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
            onPressed: () {},
            child: Text('Sign Up', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}