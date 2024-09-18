import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


import 'package:flutter/material.dart';
import 'package:note_app/features/authentication/models/reset_password_request.dart';
import 'package:note_app/features/authentication/pages/login.dart';
import 'package:note_app/features/authentication/state_management/reset_password_cubit.dart';

class ResetPassword extends StatefulWidget {
  final String email; // Email passed from previous screen

  const ResetPassword({required this.email, super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isObscuredNewPassword = true;
  bool _isObscuredConfirmPassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false; // Replace GetX loading state

  @override
  void initState() {
    super.initState();
    // Initialize the emailController with the passed email
    emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is ResetPasswordSuccess){
          print('Success state reached, navigating to the next screen');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
              builder: (_) => LoginPage()),);
        }
        else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      builder: (context, state) {
        if (state is ResetPasswordLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/pw.webp', // Background image
                  fit: BoxFit.cover,
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
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : _buildResetButton(contentWidth),
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
            'Reset password',
            style: TextStyle(
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width > 600 ? 40 : 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          // Email field
          Container(
            width: contentWidth,
            child: TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white), // Input text color
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20),
          // New Password field
          Container(
            width: contentWidth,
            child: TextField(
              controller: newPasswordController,
              style: TextStyle(color: Colors.white), // Input text color
              obscureText: _isObscuredNewPassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'New Password',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscuredNewPassword ? Icons.visibility : Icons
                        .visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscuredNewPassword = !_isObscuredNewPassword;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Confirm Password field
          Container(
            width: contentWidth,
            child: TextField(
              controller: confirmPasswordController,
              style: TextStyle(color: Colors.white), // Input text color
              obscureText: _isObscuredConfirmPassword,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Code',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscuredConfirmPassword ? Icons.visibility : Icons
                        .visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
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

  Widget _buildResetButton(double contentWidth) {
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
            if (newPasswordController.text.isNotEmpty &&
                confirmPasswordController.text.isNotEmpty &&
                emailController.text.isNotEmpty) {
              // Show a loading indicator during the reset process
            final req= ResetPasswordRequestModel(
              email: emailController.text,
              code: confirmPasswordController.text,
              newPassword: newPasswordController.text
            );
            context.read<ResetPasswordCubit>().resetPassword(req);
            }
            else if(emailController.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("fill the fealds")),
              );
            }
          },
          child: Text(
            'RESET PASSWORD',
            style: TextStyle(fontSize: 18, color: Colors.purple),
          ),
        ),
      ),
    );
  }
}


