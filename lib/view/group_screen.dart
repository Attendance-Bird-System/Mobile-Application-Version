import 'package:flutter/services.dart';

import '../shared/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';
import '../shared/widgets/toast_helper.dart';

// ignore: must_be_immutable
class GroupScreen extends StatelessWidget {
  late int groupIndex;
  GroupScreen(int index) {
    groupIndex = index;
    print(groupIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              actions: [
                state is GetGroupLinkLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : IconButton(
                        onPressed: () {
                          var id = cubit.groups![groupIndex].id;
                          Clipboard.setData(ClipboardData(
                              text: "https://docs.google.com/spreadsheets/d/" +
                                  id +
                                  "/edit?usp=sharing"));
                          showToast("The sheet Link copied to clipboard",
                              type: ToastType.success);
                        },
                        icon: Icon(Icons.link),
                        iconSize: 30,
                      ),
                state is DeleteGroupLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : IconButton(
                        onPressed: () {
                          customChoiceDialog(context,
                              title: "Warning",
                              content: "Are you sure you want to delete user ",
                              yesFunction: () {
                            cubit.deleteGroup(groupIndex, context);
                          });
                        },
                        icon: Icon(Icons.restore_from_trash_outlined),
                        iconSize: 30,
                      )
              ],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              title: Text(
                '${cubit.groups?[groupIndex - 1].name}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
                padding: EdgeInsets.all(15),
                child: state is GetGroupNamesLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount:
                            cubit.groups?[groupIndex].columnNames?.length ?? 0,
                        itemBuilder: (context, index) {
                          return groupItemBuilder(
                              index, context, cubit, groupIndex, state);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        })));
      },
    );
  }

  Widget groupItemBuilder(
      int index, BuildContext context, AppCubit cubit, int groupIndex, state) {
    return state is GetGroupPersonLoading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: LinearProgressIndicator(minHeight: 10),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(115, 115, 115, 1.0),
            ),
            child: InkWell(
              onTap: () {
                cubit.goToUser(groupIndex, index, context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.orange,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      index < 9 ? '0${index + 1}' : '${index + 1}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '${cubit.groups![groupIndex].studentNames![index]}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
