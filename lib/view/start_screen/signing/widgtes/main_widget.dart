import 'dart:ui';

import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'clip_pathes.dart';
import 'forget_pass_dialog.dart';
import 'form_field.dart';

class MainLoginWidget extends StatefulWidget {
  const MainLoginWidget({Key? key}) : super(key: key);

  @override
  State<MainLoginWidget> createState() => _MainLoginWidgetState();
}

class _MainLoginWidgetState extends State<MainLoginWidget> {
  bool isLogin = true;
  bool showPassText = true;
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var passCheckerController = TextEditingController();
  var loginGlobalKey = GlobalKey<FormState>();
  var signUpGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width * 0.95,
        child: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.easeInOut,
          child: defaultMainWidget(),
        ),
      ),
    );
  }

  Widget defaultMainWidget() {
    return CustomPaint(
        key: isLogin ? const Key("login") : const Key("signUp"),
        painter: isLogin ? LoginShadowPaint() : SignUpShadowPaint(),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => changeScreenMode(),
              child: ClipPath(
                clipper: isLogin ? SignUpClipper() : LoginClipper(),
                child: Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width * 0.92,
                  color: ColorManager.lightOrange.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: isLogin
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                        child: Text(
                          isLogin ? "Sign Up" : "Sign In",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: ColorManager.darkGrey.withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLogin ? logInWidget() : signUpWidget(),
          ],
        ));
  }

  Widget logInWidget() {
    return ClipPath(
      clipper: LoginClipper(),
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width * 0.92,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 30, top: 40, bottom: 5),
              child: const Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    color: ColorManager.darkGrey),
              ),
            ),
            underLine(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                  key: loginGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DefaultFormField(
                        prefix: Icons.mail,
                        controller: emailController,
                        fillHint: AutofillHints.email,
                        title: "Email Address",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultFormField(
                        prefix: Icons.lock,
                        controller: passController,
                        fillHint: AutofillHints.password,
                        title: "Password",
                        isPass: !showPassText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        suffix: IconButton(
                          icon: Icon(showPassText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassText = !showPassText;
                            });
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: ForgetPassword(),
                                //  contentPadding: const EdgeInsets.all(0.0),
                              ),
                            );
                          });
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: ColorManager.mainOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            usedButton(
                const Text(
                  "Sign In",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                ), () {
              if (loginGlobalKey.currentState!.validate()) {}
            }),
            const SizedBox(
              height: 15,
            ),
            usedButton(
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Login using Google account",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white),
                    )
                  ],
                ),
                () {})
          ],
        ),
      ),
    );
  }

  Widget signUpWidget() {
    return ClipPath(
      clipper: SignUpClipper(),
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width * 0.92,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      underLine(width: 100),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                  key: signUpGlobalKey,
                  child: Column(
                    children: [
                      DefaultFormField(
                        prefix: Icons.mail,
                        controller: emailController,
                        fillHint: AutofillHints.email,
                        title: "Email Address",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultFormField(
                        prefix: Icons.lock,
                        controller: passController,
                        fillHint: AutofillHints.newPassword,
                        title: "Password",
                        isPass: !showPassText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        suffix: IconButton(
                          icon: Icon(showPassText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassText = !showPassText;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DefaultFormField(
                        prefix: Icons.lock,
                        controller: passCheckerController,
                        fillHint: AutofillHints.newPassword,
                        title: "Password",
                        isPass: !showPassText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password cannot be empty';
                          } else if (value != passController.text) {
                            return 'Password must be the same';
                          } else {
                            return null;
                          }
                        },
                        suffix: IconButton(
                          icon: Icon(showPassText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPassText = !showPassText;
                            });
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            usedButton(
                const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                ), () {
              if (signUpGlobalKey.currentState!.validate()) {}
            }),
          ],
        ),
      ),
    );
  }

  Widget underLine({double width = 75}) {
    return Container(
        width: width,
        margin: const EdgeInsets.only(
          left: 30,
        ),
        height: 12,
        child: const Card(elevation: 2, color: ColorManager.mainOrange));
  }

  void forgetPassword() {}

  Widget orLineWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          const Text(
            '  OR  ',
            style: TextStyle(color: Colors.grey),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget usedButton(Widget child, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorManager.mainOrange,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        elevation: 2,
        child: child,
      ),
    );
  }

  void changeScreenMode() {
    passCheckerController.clear();
    passController.clear();
    emailController.clear();
    showPassText = false;
    isLogin = !isLogin;
    setState(() {});
  }
}
