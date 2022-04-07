import 'package:auto_id/shared/functions/navigation_functions.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

import '../signing/login_screen.dart';

// ignore: must_be_immutable
class OnBoardingView extends StatelessWidget {
  int index = 0;

  Widget _signUpButton(bool isDone, BuildContext context) {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: ColorManager.darkGrey,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          navigateAndPush(context, LoginView());
        },
        child: Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            isDone ? 'Done' : "Skip",
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.mainOrange,
      body: Onboarding(
        pages: List.generate(
            3,
            (index) => PageModel(
                  widget: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 45.0,
                            vertical: 90.0,
                          ),
                          child: FlutterLogo(
                            size: 120,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 45.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$index- EASY ACCESS',
                              style: pageTitleStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Reach your files anytime from any devices anywhere',
                              style: pageInfoStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIndicator(
                  netDragPercent: dragDistance,
                  pagesLength: pagesLength,
                  indicator: Indicator(
                    activeIndicator: ActiveIndicator(borderWidth: 8),
                    closedIndicator: ClosedIndicator(borderWidth: 5),
                    indicatorDesign: IndicatorDesign.line(
                      lineDesign: LineDesign(
                        lineType: DesignType.line_uniform,
                      ),
                    ),
                  ),
                ),
                _signUpButton(index == pagesLength - 1, context)
              ],
            ),
          );
        },
      ),
    );
  }
}