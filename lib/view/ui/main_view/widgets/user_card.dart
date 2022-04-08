import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/model/module/card_student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/color_manager.dart';
import 'add_bottom_sheet.dart';

// ignore: must_be_immutable
class UserCard extends StatelessWidget {
  final CardStudent cardStudent;
  bool loading;
  UserCard(this.cardStudent, this.loading, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(loading);
    if (loading) {
      return const CardBox(
          child: SizedBox(
        width: double.infinity,
        height: 150,
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      ));
    }
    switch (cardStudent.state) {
      case StudentState.empty:
        return CardBox(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.label_off,
              color: Colors.grey,
              size: 80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "No id scanned",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ],
        ));
      case StudentState.newStudent:
        return CardBox(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'User doesn\'t exist',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'ID : ${cardStudent.id}',
                        style: const TextStyle(
                            color: ColorManager.darkGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: TextButton(
                              child: const Text("Add the user",
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15)),
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                      const EdgeInsets.all(15)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              const BorderSide(color: Colors.green)))),
                              onPressed: () => showBottomSheet(context)),
                        ),
                      ),
                    ]),
              ),
            ),
            cardImage(),
          ],
        ));
      default:
        return CardBox(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          '${cardStudent.name}',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Group : ${context.read<AdminDataBloc>().state.groupList[cardStudent.groupIndex!].name}'),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('ID : ${cardStudent.id}'),
                      const SizedBox(
                        height: 5,
                      ),
                      cardStudent.state == StudentState.notRegistered
                          ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const [
                                Text(
                                  'not Registered ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                )
                              ],
                            )
                          : Wrap(
                              children: const [
                                Text(
                                  'Process completed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              ],
                            ),
                    ]),
              ),
            ),
            cardImage(),
          ],
        ));
    }
  }

  Widget cardImage() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/avatar.png',
                    imageErrorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return SizedBox(
                        width: 50,
                        child: Center(
                          child: Image.asset('images/avatar.png'),
                        ),
                      );
                    },
                    image: '${cardStudent.imgUrl}',
                  )),
            ),
          ),
        ),
      );

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return const AddBottomSheet();
        });
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  const CardBox({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        // height: 200,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Last Scan',
                style: TextStyle(
                    color: ColorManager.darkGrey,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
            child
          ],
        ));
  }
}
