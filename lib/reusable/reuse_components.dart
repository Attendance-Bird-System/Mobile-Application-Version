import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color customGray = Color.fromRGBO(64, 64, 64, 1);

void errDialog(BuildContext context, String text, int sec) {
  showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: sec), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(text),
          backgroundColor: Colors.red,
        );
      });
}

void navigateAndReplace(BuildContext context, Widget newScreen) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return newScreen;
  }));
}

void navigateAndPush(BuildContext context, Widget newScreen) {
  Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return newScreen;
    },
  ));
}

Widget upperTriangle(BuildContext context) {
  return Expanded(
    child: Stack(children: [
      Container(
        child: MediaQuery.of(context).size.height < 400
            ? Container()
            : Image.asset(
                'images/p1.png',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width / 2,
              ),
      ),
      Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          'Easy Tag',
          style: TextStyle(
              color: Colors.orange,
              fontSize: MediaQuery.of(context).size.height / 20,
              fontWeight: FontWeight.bold),
        ),
      ))
    ]),
  );
}

Widget lowerTriangle(BuildContext context) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          child: MediaQuery.of(context).size.height < 400
              ? Container()
              : Image.asset(
                  'images/p2.png',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width / 2,
                ),
        ),
      ],
    ),
  );
}
