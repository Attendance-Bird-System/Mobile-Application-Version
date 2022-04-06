import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:auto_id/reusable/reuse_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ChangePassword extends StatelessWidget {
  var passController_1 = TextEditingController();
  var passController_2 = TextEditingController();
  var formKey = GlobalKey<FormState>();

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
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                      controller: passController_1,
                                      obscureText: cubit.hidePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'password cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Enter new password",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(cubit.hidePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      controller: passController_2,
                                      obscureText: cubit.hidePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'password cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Re enter new password",
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(cubit.hidePassword
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: state is UserChangePasswordLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                if (passController_2.text ==
                                                    passController_1.text) {
                                                  cubit.changePassword(context,
                                                      passController_1.text);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        Future.delayed(
                                                            Duration(
                                                                seconds: 1),
                                                            () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        });
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .deepOrange)),
                                                          title: Text(
                                                            "Passwords must be the same",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          backgroundColor:
                                                              Colors.orange,
                                                        );
                                                      });
                                                }
                                                // here
                                              }
                                            },
                                            child: Text('Change password',
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
