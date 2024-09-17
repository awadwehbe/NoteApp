import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/pages/otp_view.dart';
import 'features/authentication/pages/sign_up.dart';
import 'features/authentication/repository/otp_repository.dart';
import 'features/authentication/repository/signUp_repository.dart';
import 'features/authentication/state_management/otp_cubit.dart';
import 'features/authentication/state_management/sign_up_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(UserRepository()),
        ),
        BlocProvider<OtpCubit>(
          create: (context) => OtpCubit(OtpRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RegistrationPage(),
      ),
    );
  }
}