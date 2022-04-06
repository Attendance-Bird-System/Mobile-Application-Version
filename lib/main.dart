import 'package:auto_id/view/main_screen.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:auto_id/view/start_screen/signing/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth_bloc/auth_status_bloc.dart';
import 'cubit/cubit.dart';
import 'model/local/pref_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.orange, // status bar color
  ));

  await Firebase.initializeApp();
  await PreferenceRepository.initializePreference();

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthStatusBloc()),
        BlocProvider(create: (_) => AppCubit()..getUserLoginData(false)),
      ],
      child: MaterialApp(
        title: StringManger.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // primarySwatch: ColorManager.mainOrange,
          primaryColor: ColorManager.mainOrange,
        ),
        home: context.read<AuthStatusBloc>().state.user.isEmpty
            ? LoginView()
            : MainScreen(),
      ),
    );
  }
}
