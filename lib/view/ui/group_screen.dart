import 'package:flutter/services.dart';

import '../../view/shared/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/admin_cubit.dart';
import '../../bloc/admin_states.dart';
import '../../view/shared/widgets/toast_helper.dart';

// ignore: must_be_immutable
class GroupScreen extends StatelessWidget {
  late int groupIndex;
  GroupScreen(int index, {Key? key}) : super(key: key) {
    groupIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (BuildContext context, AdminCubitStates state) {},
      builder: (BuildContext context, AdminCubitStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return Scaffold(
            appBar: AppBar(
              actions: [
                if (state is GetGroupLinkLoading)
                  const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                else
                  IconButton(
                    onPressed: () {
                      var id = cubit.groups![groupIndex].id;
                      Clipboard.setData(ClipboardData(
                          text: "https://docs.google.com/spreadsheets/d/" +
                              id +
                              "/edit?usp=sharing"));
                      showToast("The sheet Link copied to clipboard",
                          type: ToastType.success);
                    },
                    icon: const Icon(Icons.link),
                    iconSize: 30,
                  ),
                if (state is DeleteGroupLoading)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  )
                else
                  IconButton(
                    onPressed: () {
                      customChoiceDialog(context,
                          title: "Warning",
                          content: "Are you sure you want to delete user ",
                          yesFunction: () {
                        cubit.deleteGroup(groupIndex, context);
                      });
                    },
                    icon: const Icon(Icons.restore_from_trash_outlined),
                    iconSize: 30,
                  )
              ],
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              title: Text(
                '${cubit.groups?[groupIndex - 1].name}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
                padding: const EdgeInsets.all(15),
                child: state is GetGroupNamesLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount:
                            cubit.groups?[groupIndex].columnNames?.length ?? 0,
                        itemBuilder: (context, index) {
                          return groupItemBuilder(
                              index, context, cubit, groupIndex, state);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 10,
                          );
                        })));
      },
    );
  }

  Widget groupItemBuilder(int index, BuildContext context, AdminCubit cubit,
      int groupIndex, state) {
    return state is GetGroupPersonLoading
        ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: LinearProgressIndicator(minHeight: 10),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(115, 115, 115, 1.0),
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
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      index < 9 ? '0${index + 1}' : '${index + 1}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        cubit.groups![groupIndex].studentNames![index],
                        style: const TextStyle(
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
