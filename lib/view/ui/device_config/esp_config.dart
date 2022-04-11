import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/device_config/widgets/main_widget.dart';
import 'package:flutter/material.dart';

class SendConfigScreen extends StatelessWidget {
  const SendConfigScreen({Key? key}) : super(key: key);

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
                MainConfigWidget()
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
            "Device configuration",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: ColorManager.mainOrange),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Connect to wifi <ESP> with password <88888888>',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ColorManager.darkGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
