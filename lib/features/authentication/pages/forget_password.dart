import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:note_app/features/authentication/pages/reset_password.dart';

import '../models/reqpass_reset_request.dart';
import '../state_management/reqpass_reset_cubit.dart';


class ForgetPassword extends StatefulWidget {
  final String email;
  const ForgetPassword({super.key, required this.email});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool rememberMe = false;
  bool _isObscured = true;
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return BlocConsumer<ReqpassResetCubit, ReqpassResetState>(
     listener: (context, state) {

       if (state is ReqpassResetSuccess) {
         print('Success state reached, navigating to the next screen');
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (_) => ResetPassword(email: emailController.text),
           ),
         );
       } else if (state is ReqpassResetError) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(state.error)),
         );
       }

  },
  builder: (context, state) {
    if (state is ReqpassResetLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Stack(
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

                return  SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight,
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
                            SizedBox(height: screenHeight * 0.05),
                            _buildSignUpButton(contentWidth),
                            // Error message display
                            if (emailController.text.isNotEmpty)
                              Text(
                                emailController.text,
                                style: TextStyle(color: Colors.red),
                              ),
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
            'Create an account',
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
            if(emailController.text.isNotEmpty){
              // Proceed with the login API call
              final ReqpassResetRequeset = ReqpassResetRequesetModel(
                email: emailController.text,
              );
              print('the request is :${ReqpassResetRequeset}');
              context.read<ReqpassResetCubit>().requestPasswordReset(ReqpassResetRequeset);
            }
            else if(emailController.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Email  can't be empty")),
              );
            }

          },
          child: Text('Reset Password', style: TextStyle(fontSize: 18, color: Colors.purple)),
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
            onPressed: () {},
            child: Text('Sign Up', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}

