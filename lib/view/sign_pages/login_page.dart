import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:auto_id/reusable/reuse_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../forgetPassPage.dart';
import 'create_acount.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var inBefore = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return SafeArea(
            child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: state is CheckUserStateLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        upperTriangle(context),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Form(
                            key: formKey,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.withOpacity(0.15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'User name cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "User name",
                                        prefixIcon: Icon(Icons.person),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orange, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      controller: passController,
                                      obscureText: cubit.hidePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'password cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(cubit.hidePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            print(passController.text);
                                            cubit.changePassShowClicked();
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.orange, width: 2.0),
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      )),
                                  Container(
                                    child: CheckboxListTile(
                                        title: Text(
                                          "Remember me",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: cubit.rememberMe,
                                        onChanged: (newValue) {
                                          cubit.rememberMeBoxClicked();
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .leading, //  <-- leading Checkbox
                                        contentPadding: EdgeInsets.all(0.0)),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: state is UserLogInLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                cubit.userLogIn(
                                                    context,
                                                    phoneController.text,
                                                    passController.text);
                                              }
                                            },
                                            child: Text('Log In',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.all(15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12), // <-- Radius
                                              ),
                                            ),
                                          ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Forget the password',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TextButton(
                                              child: Text(
                                                'Click Here',
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return ForgetPassPage();
                                                  },
                                                ));
                                              }),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Doesn\'t have sheet ',
                                            style: TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          TextButton(
                                              child: Text(
                                                'Create one',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.orange,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset: Offset(1, 1),
                                                        blurRadius: 2.0,
                                                        color: Colors
                                                            .orangeAccent),
                                                  ],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return NewSheetPage();
                                                  },
                                                ));
                                              }),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        lowerTriangle(context),
                      ],
                    ),
                  ),
          ),
        ));
      },
    );
  }
}
