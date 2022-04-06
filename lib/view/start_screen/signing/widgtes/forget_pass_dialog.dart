import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'form_field.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatelessWidget {
  ForgetPassword({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forget password",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: ColorManager.mainOrange),
          ),
          Text(
            "Reset mail will be sent to you ",
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            key: formKey,
            child: DefaultFormField(
              controller: emailController,
              fillHint: AutofillHints.email,
              title: "Email",
              prefix: FontAwesomeIcons.user,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email cannot be empty';
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorManager.mainOrange)),
                onPressed: () {
                  if (formKey.currentState!.validate()) {}
                },
                child: Text(
                  "Send mail",
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
