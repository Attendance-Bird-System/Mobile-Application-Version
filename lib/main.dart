import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cubit/cubit.dart';
import 'layouts/sign_pages/login_page.dart';
import 'layouts/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc.observer = MyBlocObserver();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.orange, // status bar color
  ));

  final prefs = await SharedPreferences.getInstance();
  bool? userHere = prefs.getBool("rememberMe");

  runApp(MyApp(userHere ?? false));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool isHere;
  MyApp(this.isHere);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getUserLoginData(isHere),
      child: MaterialApp(
        title: 'ID APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: isHere ? MainScreen() : LoginPage(),
      ),
    );
  }
}
