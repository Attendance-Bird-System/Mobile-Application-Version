import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:auto_id/reusable/reuse_components.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class SheetFeatures extends StatelessWidget {
  var wifiNameController = TextEditingController();
  var passController = TextEditingController();
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Change the ESP WIFI Configuration',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: ColorManager.darkGrey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Connect to wifi ESP with password <88888888>',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.deepOrange),
                          ),
                        ),
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
                                      controller: wifiNameController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Wifi NAME cannot be empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: "WIFI name",
                                        prefixIcon: Icon(Icons.wifi),
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: state is SendToEspLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : ElevatedButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                cubit.sendToEsp(
                                                    context,
                                                    wifiNameController.text,
                                                    passController.text);
                                              }
                                            },
                                            child: Text('Send Configuration',
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
