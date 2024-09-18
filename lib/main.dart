import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/authentication/pages/forget_password.dart';
import 'package:note_app/features/authentication/pages/login.dart';
import 'package:note_app/features/authentication/repository/reqpass_reset_repository.dart';
import 'package:note_app/features/authentication/repository/reset_password_repository.dart';

import 'features/authentication/pages/otp_view.dart';
import 'features/authentication/pages/sign_up.dart';
import 'features/authentication/repository/login_repository.dart';
import 'features/authentication/repository/otp_repository.dart';
import 'features/authentication/repository/signUp_repository.dart';
import 'features/authentication/state_management/login_cubit.dart';
import 'features/authentication/state_management/otp_cubit.dart';
import 'features/authentication/state_management/reqpass_reset_cubit.dart';
import 'features/authentication/state_management/reset_password_cubit.dart';
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
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(LoginRepository()),
        child: LoginPage(),
        ),
        BlocProvider<ReqpassResetCubit>(
          create: (context) => ReqpassResetCubit(reqpassResetRepository: ReqpassResetRepository()),
          //child: ForgetPassword(email: ''),// the email i pass via the Navigator will take precedence, and the empty email in the main will no longer matter once you navigate with the correct email.
        ),
        BlocProvider<ResetPasswordCubit>(
          create: (context) => ResetPasswordCubit(resetPasswordRepository:ResetPasswordRepository()),
          child: LoginPage(),
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