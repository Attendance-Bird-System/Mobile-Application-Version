import 'package:flutter/material.dart';

void customChoiceDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function yesFunction,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              OutlinedButton(
                  //  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "no",
                    style: TextStyle(color: Colors.green),
                  )),
              OutlinedButton(
                  //isDefaultAction: true,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    yesFunction();
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
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
