import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../resources/color_manager.dart';

// ignore: must_be_immutable
class NewSheetPage extends StatelessWidget {
  var inBefore = false;
  var formKey = GlobalKey<FormState>();
  var userName = TextEditingController();
  var passController_1 = TextEditingController();
  var passController_2 = TextEditingController();
  var phoneController = TextEditingController();
  var validateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        if (!inBefore) {
          cubit.validateNumberForFirst = false;
          inBefore = true;
        }
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: ColorManager.darkGrey,
            appBar: AppBar(
              backgroundColor: ColorManager.darkGrey,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(
                        child: Text(
                      'Create account',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange),
                    )),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Form(
                              key: formKey,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    // user name
                                    TextFormField(
                                        controller: userName,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'User name cannot be empty';
                                          } else if (value.contains('!')) {
                                            return 'User name cannot contain !';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: "User name",
                                          prefixIcon: Icon(Icons.person),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // phone number
                                    TextFormField(
                                        enabled: !cubit.validateNumberForFirst,
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Phone number cannot be empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          hintText: '01------',
                                          labelText: "Phone number",
                                          suffixIcon: state
                                                  is UserValidateLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.textsms_outlined,
                                                    color: Colors.deepOrange,
                                                  ),
                                                  onPressed: () {
                                                    cubit.sendVerificationSms(
                                                        context,
                                                        phoneController.text);
                                                  }),
                                          prefixIcon: Icon(Icons.phone_android),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // otp
                                    TextFormField(
                                        enabled: cubit.validateNumberForFirst,
                                        controller: validateController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (cubit.validateNumberForFirst) {
                                            if (value!.isEmpty) {
                                              return 'check your message and type it';
                                            } else {
                                              return null;
                                            }
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Validate number",
                                          prefixIcon:
                                              Icon(Icons.check_box_outlined),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.check_circle_outlined,
                                              color: Colors.deepOrange,
                                            ),
                                            onPressed: () {
                                              cubit.checkUserFirstOtp(context,
                                                  validateController.text);
                                            },
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.orange,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        )),
                                    Container(
                                      child: cubit.userISoK
                                          ? Text(
                                              'number verified successfully',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          : Container(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // pass 1
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
                                          labelText: "Password",
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
                                                color: Colors.orange,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // pass 2
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
                                          labelText: "Confirm password",
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
                                                color: Colors.orange,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        )),
                                    // button
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      width: double.infinity,
                                      child: state is UserSignUpLoading
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  if (passController_2.text ==
                                                      passController_1.text) {
                                                    if (cubit.userISoK) {
                                                      cubit.signUp(
                                                          context: context,
                                                          userName:
                                                              userName.text,
                                                          phoneNumber:
                                                              phoneController
                                                                  .text,
                                                          password:
                                                              passController_1
                                                                  .text);
                                                    }
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () {
                                                            Navigator.of(
                                                                    context)
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
                                                }
                                              },
                                              child: Text('Create account',
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
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
