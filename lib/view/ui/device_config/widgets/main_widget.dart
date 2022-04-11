import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/shared/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/color_manager.dart';
import '../../start_screen/signing/widgtes/clip_pathes.dart';

// ignore: must_be_immutable
class MainConfigWidget extends StatelessWidget {
  MainConfigWidget({Key? key}) : super(key: key);

  TextEditingController wifiNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool hidePassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 10.0,
          left: 10.0,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width * 0.95,
        child: defaultMainWidget(context),
      ),
    );
  }

  Widget defaultMainWidget(BuildContext context) => CustomPaint(
      painter: LoginShadowPaint(),
      child: Stack(
        children: [
          ClipPath(
            clipper: SignUpClipper(),
            child: Container(
              height: 500,
              width: MediaQuery.of(context).size.width * 0.92,
              color: ColorManager.lightOrange.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                    child: Text(
                      "Sign Up",
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
          logInWidget(context)
        ],
      ));

  Widget logInWidget(BuildContext context) => ClipPath(
        clipper: LoginClipper(),
        child: Container(
          height: 500,
          width: MediaQuery.of(context).size.width * 0.92,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.withOpacity(0.15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultFormField(
                          controller: wifiNameController,
                          title: "WIFI name",
                          prefix: Icons.wifi,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wifi NAME cannot be empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StatefulBuilder(
                            builder: (_, setState) => DefaultFormField(
                                  controller: passController,
                                  isPass: hidePassword,
                                  suffix: IconButton(
                                    icon: Icon(hidePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                  ),
                                  title: "Password name",
                                  prefix: Icons.lock,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'password NAME cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: BlocConsumer<AdminDataBloc, AdminDataStates>(
                              buildWhen: (perv, next) =>
                                  next is SendEspDataState,
                              listenWhen: (perv, next) =>
                                  next is SendEspDataState,
                              listener: (context, state) {
                                if ((state is SendEspDataState) &&
                                    (state.status == AdminDataStatus.loaded)) {
                                  Navigator.of(context).pop();
                                }
                              },
                              builder: (context, state) => usedButton(
                                      (state is SendEspDataState) &&
                                              (state.status ==
                                                  AdminDataStatus.loading)
                                          ? const CircularProgressIndicator()
                                          : const Text(
                                              "Send",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ), () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<AdminDataBloc>().add(
                                          SendConfigurationEvent(
                                              wifiNameController.text,
                                              passController.text));
                                    }
                                  })),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget usedButton(Widget child, Function() onPressed) => Container(
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
