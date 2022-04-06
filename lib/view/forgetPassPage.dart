import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:auto_id/reusable/reuse_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ForgetPassPage extends StatelessWidget {
  var phoneController = TextEditingController();
  var validateController = TextEditingController();

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
            body: Container(
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
                                enabled: !cubit.validateNumber,
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
                                  labelText: "User Name",
                                  prefixIcon: Icon(Icons.person),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                child: !cubit.validateNumber
                                    ? Container()
                                    : Text(
                                        'The message sent to' +
                                            '*' * 7 +
                                            '${cubit.userPhone.substring(cubit.userPhone.length - 4, cubit.userPhone.length)} ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                                enabled: cubit.validateNumber,
                                controller: validateController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (cubit.validateNumber) {
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
                                  labelText: "Varification number",
                                  prefixIcon: Icon(Icons.check_box_outlined),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.orange, width: 2.0),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: state is UserValidateLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          if (!cubit.validateNumber) {
                                            cubit.userValidate(
                                                context, phoneController.text);
                                          } else {
                                            cubit.verifyOtp(context,
                                                validateController.text);
                                          }
                                        }
                                      },
                                      child: Text(
                                          cubit.validateNumber
                                              ? 'Validate'
                                              : 'Check Number',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
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
