import '../../view/shared/functions/dialogs.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/admin_cubit.dart';
import '../../bloc/admin_states.dart';
import 'edit_user.dart';

// ignore: must_be_immutable
class UserScreen extends StatelessWidget {
  late int groupIndex;
  late int userIndex;

  UserScreen(int indexUser, int indexGroup) {
    userIndex = indexUser;
    groupIndex = indexGroup;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (BuildContext context, AdminCubitStates state) {},
      builder: (BuildContext context, AdminCubitStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                if (cubit.showedUserData['ID'].toString().isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditUserScreen(
                        cubit.showedUserData['ID'] ?? '-', groupIndex, true);
                  }));
                }
              }),
          appBar: AppBar(
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              title: Text(
                'User Information',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: state is DeletePersonLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Icon(Icons.restore_from_trash_outlined),
                  onPressed: () {
                    //print(userIndex);
                    customChoiceDialog(context,
                        title: "Warning",
                        content: "Are you sure you want to delete user ",
                        yesFunction: () {
                      cubit.deleteUser(userIndex + 2, groupIndex, context);
                    });
                  },
                )
              ]),
          body: state is GetGroupPersonLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                        itemCount: cubit.showedUserData.length + 1,
                        itemBuilder: (context, index) {
                          return inputBuilder(index - 1, context, cubit);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 15,
                          );
                        }),
                  ),
                ),
        );
      },
    );
  }

  Widget inputBuilder(int index, BuildContext context, AdminCubit cubit) {
    if (index == -1) {
      return Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
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
                        return Container(
                          height: 150,
                          child: Center(
                            child: Image.asset('images/avatar.png'),
                          ),
                        );
                      },
                      image: cubit.showedUserData['userImageUrl'],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              cubit.showedUserData['Name'] == null
                  ? "-"
                  : cubit.showedUserData['Name'].toString(),
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            cubit.showedUserData['ID'] == null
                ? "-"
                : 'ID : ${cubit.showedUserData['ID']}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );
    }
    if (cubit.showedUserData.keys.toList()[index].trim() == 'Name' ||
        cubit.showedUserData.keys.toList()[index].trim() == 'ID') {
      return Container();
    }

    if (cubit.showedUserData.keys.toList()[index].toString().contains('/')) {
      return Wrap(children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            ':  ${cubit.showedUserData.keys.toList()[index]}',
            style: TextStyle(
              color: ColorManager.darkGrey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        SelectableText(
          cubit.showedUserData.values.toList()[index].toString().isEmpty
              ? 'absent'
              : 'done',
          style: TextStyle(fontSize: 15, color: Colors.blue),
        ),
      ]);
    }

    return Wrap(children: [
      Text(
        '${cubit.showedUserData.keys.toList()[index]} : ',
        style: TextStyle(
          color: ColorManager.darkGrey,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      SizedBox(
        width: 10,
      ),
      SelectableText(
        cubit.showedUserData.values.toList()[index].toString().isEmpty
            ? 'empty'
            : '${cubit.showedUserData.values.toList()[index]}',
        style: TextStyle(fontSize: 15, color: Colors.blue),
      ),
    ]);
  }
}
