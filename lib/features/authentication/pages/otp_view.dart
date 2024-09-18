import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/authentication/repository/otp_repository.dart';

import '../models/otp_request.dart';
import '../state_management/otp_cubit.dart';
import 'home.dart';
import 'otp_input.dart';


class OTPView extends StatefulWidget {
  final String? email;

  OTPView({Key? key, required this.email}) : super(key: key);

  @override
  _OTPViewState createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  String _errorMessage = '';
  String _enteredOtp = ''; // Store the entered OTP

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return  BlocConsumer<OtpCubit, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            print('navigating...');
            // Navigate to the next screen or show a success message
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('OTP verification successful!')),
            );
          } else if (state is OtpError) {
            setState(() {
              _errorMessage = state.errorMessage;
            });
          } else if (state is SignUpLoading) {
            // Show loading indicator or any UI changes for loading
            setState(() {
              _errorMessage = "Verifying OTP...";
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: otpBodySection(
                  screenHeight,
                  screenWidth,
                ),
              ),
            ),
          );
        },

    );
  }

  SingleChildScrollView otpBodySection(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Color(0xD8BFD8),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              otpPageHeader(),
              SizedBox(height: screenHeight * 0.02),
              imageSection(),
              const Text(
                'We have sent you an OTP to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(height: screenHeight * 0.03),
              otpInputSectionText(),
              SizedBox(height: screenHeight * 0.04),
              OtpInput(onOtpCompleted: _onOtpCompleted), // Pass callback
              SizedBox(height: screenHeight * 0.02),
              didntReceivedCodeSection(),
              SizedBox(height: screenHeight * 0.02),
              VerifyButton(screenHeight: screenHeight, screenWidth: screenWidth),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOtpCompleted(String otp) async {
    setState(() {
      _enteredOtp = otp; // Update local OTP variable
    });
  }

  Widget VerifyButton({required double screenHeight, required double screenWidth}) {
    return ElevatedButton(
      onPressed: () {
        final otpRequest = OtpRequestModel(
          email: widget.email,
          code: _enteredOtp,
        );
        context.read<OtpCubit>().Otpval(otpRequest); // Trigger OTP verification
      },
      child: Text("Verify"),
    );
  }

  Widget otpPageHeader() {
    return const Text(
      'Verify Account',
      style: TextStyle(
          color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 30),
    );
  }

  Widget didntReceivedCodeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Didn\'t receive the code?',
          style: TextStyle(color: Colors.grey, fontSize: 20),
        ),
        TextButton(
          onPressed: () {
            // Logic for resending OTP
            print('Resend OTP');
          },
          child: Text(
            'Resend',
            style: TextStyle(color: Colors.purple, fontSize: 20),
          ),
        ),
      ],
    );
  }

  Widget imageSection() {
    return Image.asset(
      'assets/images/otp_image.webp',
      height: 200,
      width: 200,
      fit: BoxFit.fill,
    );
  }

  Widget otpInputSectionText() {
    return Text(
      'We have sent an OTP to your email: ${widget.email.toString()}. Please enter it below to complete the verification.',
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.grey, fontSize: 20),
    );
  }
}

