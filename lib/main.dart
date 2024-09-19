import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/features/authentication/pages/forget_password.dart';
import 'package:note_app/features/authentication/pages/login.dart';
import 'package:note_app/features/authentication/repository/notes_repository.dart';
import 'package:note_app/features/authentication/repository/reqpass_reset_repository.dart';
import 'package:note_app/features/authentication/repository/reset_password_repository.dart';

import 'features/authentication/pages/otp_view.dart';
import 'features/authentication/pages/sign_up.dart';
import 'features/authentication/repository/login_repository.dart';
import 'features/authentication/repository/otp_repository.dart';
import 'features/authentication/repository/signUp_repository.dart';
import 'features/authentication/state_management/create_note_cubit.dart';
import 'features/authentication/state_management/delete_note_cubit.dart';
import 'features/authentication/state_management/get_note_cubit.dart';
import 'features/authentication/state_management/login_cubit.dart';
import 'features/authentication/state_management/otp_cubit.dart';
import 'features/authentication/state_management/reqpass_reset_cubit.dart';
import 'features/authentication/state_management/reset_password_cubit.dart';
import 'features/authentication/state_management/sign_up_cubit.dart';
import 'features/authentication/state_management/update_note_cubit.dart';
import 'hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsManager.init();



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
        ),
        BlocProvider<ReqpassResetCubit>(
          create: (context) => ReqpassResetCubit(reqpassResetRepository: ReqpassResetRepository()),
        ),
        BlocProvider<ResetPasswordCubit>(
          create: (context) => ResetPasswordCubit(resetPasswordRepository: ResetPasswordRepository()),
        ),
        BlocProvider<GetNoteCubit>(
          create: (context) => GetNoteCubit(notesRepository: NotesRepository()),
        ),
        BlocProvider<CreateNoteCubit>(
          create: (context) => CreateNoteCubit(NotesRepository()),
        ),
        BlocProvider<UpdateNoteCubit>(
          create: (context) => UpdateNoteCubit(NotesRepository()),
        ),
        BlocProvider<DeleteNoteCubit>(
          create: (context) => DeleteNoteCubit(NotesRepository()),
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