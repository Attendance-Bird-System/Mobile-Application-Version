import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../bloc/cubit.dart';
import '../bloc/states.dart';

// ignore: must_be_immutable
class EditUserScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  final TextEditingController typeAheadController = TextEditingController();
  List editUserController = [];

  String id;
  int groupIndex;
  bool dataHere;
  bool dataWritten = true;

  EditUserScreen(this.id, this.groupIndex, this.dataHere);
  // id
  // Group name

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        if (dataHere && typeAheadController.text.isEmpty) {
          typeAheadController.text = cubit.showedUserData['Name'];
        }
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              foregroundColor: Colors.white,
              title: Text("Edit User"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(15),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ID : $id',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.darkGrey,
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                child: state is SendToEditLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        Icons.check,
                        size: 35,
                        color: Colors.white,
                      ),
                onPressed: () {
                  Map dataToSent = {};
                  for (int i = 0;
                      i < (cubit.groups?[groupIndex].columnNames?.length ?? 0);
                      i++) {
                    if (!cubit.groups![groupIndex].columnNames![i]
                        .contains('/')) {
                      if (cubit.groups![groupIndex].columnNames![i] == 'Name') {
                        dataToSent[cubit.groups![groupIndex].columnNames![i]] =
                            this.typeAheadController.text;
                      } else if (cubit.groups![groupIndex].columnNames![i]
                              .trim() !=
                          'ID') {
                        dataToSent[cubit.groups![groupIndex].columnNames![i]] =
                            editUserController[i].text.isEmpty
                                ? "Empty"
                                : editUserController[i].text;
                      }
                    }
                  }
                  cubit.sendEditData(groupIndex, id, dataToSent, context);
                }),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: TypeAheadField(
                      suggestionsCallback: (pattern) async {
                        List<String> sug = [];
                        for (var i
                            in cubit.groups![groupIndex].studentNames ?? []) {
                          if (i.contains(pattern)) {
                            sug.add(i);
                          }
                        }
                        return sug;
                      },
                      onSuggestionSelected: (suggestion) {
                        int userIndex = cubit.groups![groupIndex].studentNames!
                            .indexOf(suggestion.toString());
                        print(userIndex);
                        dataHere = true;
                        typeAheadController.text = suggestion.toString();
                        cubit.getUserData(groupIndex, userIndex, context);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                          leading: Icon(Icons.assignment_ind_outlined),
                        );
                      },
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: typeAheadController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ColorManager.darkGrey, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  state is GetGroupPersonLoading
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                          child: ListView.separated(
                              itemCount: cubit.groups?[groupIndex].columnNames
                                      ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return inputBuilder(index, cubit, state);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 15,
                                );
                              }),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget inputBuilder(int index, AppCubit cubit, AppStates state) {
    if (editUserController.length <
        (cubit.groups?[groupIndex].columnNames?.length ?? 0)) {
      editUserController.add(TextEditingController());
    }

    if (cubit.groups?[groupIndex].columnNames?[index].contains('/') ?? false) {
      // photo
      return Container();
    }

    if (cubit.groups?[groupIndex].columnNames?[index].trim() == 'Name' ||
        cubit.groups?[groupIndex].columnNames?[index].trim() == 'ID') {
      return Container();
    }

    print(cubit.showedUserData);
    if ((dataHere && dataWritten) || state is GetGroupPersonDone) {
      editUserController[index].text = cubit.showedUserData.values.toList()[index];
      dataWritten = false;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      cubit.emit(GetGroupPersonError());
    }
    return TextFormField(
        controller: editUserController[index],
        validator: (value) {
          if (value!.isEmpty) {
            return 'that field cannot be empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: "${cubit.groups?[groupIndex].columnNames?[index]}",
          prefixIcon: Icon(Icons.input),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
  }
}
