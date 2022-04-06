import 'package:auto_id/cubit/auth_bloc/auth_status_bloc.dart';
import 'package:auto_id/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/main_screen.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/resources/string_manager.dart';
import 'package:auto_id/view/start_screen/signing/widgtes/main_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorManager.whiteColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                topWidget(),
                const SizedBox(
                  height: 40,
                ),
                BlocListener<AuthStatusBloc, AuthStates>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.success) {
                      navigateAndPush(context, MainScreen());
                    }
                  },
                  child: const MainLoginWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            StringManger.appName,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: ColorManager.mainOrange),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            StringManger.appSlogan,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorManager.darkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
