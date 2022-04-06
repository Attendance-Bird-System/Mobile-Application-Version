import 'package:auto_id/cubit/cubit.dart';
import 'package:auto_id/cubit/states.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// ignore: must_be_immutable
class EditUserScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  final TextEditingController typeAheadController = TextEditingController();

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
          typeAheadController.text = cubit.userData['Name'];
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
                  for (int i = 0; i < cubit.activeGroupColumns.length; i++) {
                    if (!cubit.activeGroupColumns[i].contains('/')) {
                      if (cubit.activeGroupColumns[i].trim() == 'Name') {
                        dataToSent[cubit.activeGroupColumns[i]] =
                            this.typeAheadController.text;
                      } else if (cubit.activeGroupColumns[i].trim() != 'ID') {
                        dataToSent[cubit.activeGroupColumns[i]] =
                            cubit.editUserController[i].text.isEmpty
                                ? "Empty"
                                : cubit.editUserController[i].text;
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
                        for (var i in cubit.activeGroupNames) {
                          if (i.contains(pattern)) {
                            sug.add(i);
                          }
                        }
                        return sug;
                      },
                      onSuggestionSelected: (suggestion) {
                        print(cubit.activeGroupNames);
                        int userIndex = cubit.activeGroupNames
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
                              itemCount: cubit.activeGroupColumns.length,
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
    if (cubit.editUserController.length < cubit.activeGroupColumns.length) {
      cubit.editUserController.add(TextEditingController());
      print(cubit.editUserController.length);
      print('index $index');
    }

    if (cubit.activeGroupColumns[index].contains('/')) {
      // photo
      return Container();
    }

    if (cubit.activeGroupColumns[index].trim() == 'Name' ||
        cubit.activeGroupColumns[index].trim() == 'ID') {
      return Container();
    }

    print(cubit.userData);
    if ((dataHere && dataWritten) || state is GetGroupPersonDone) {
      cubit.editUserController[index].text =
          cubit.userData.values.toList()[index];
      dataWritten = false;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      cubit.emit(GetGroupPersonError());
    }
    return TextFormField(
        controller: cubit.editUserController[index],
        validator: (value) {
          if (value!.isEmpty) {
            return 'that field cannot be empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: "${cubit.activeGroupColumns[index]}",
          prefixIcon: Icon(Icons.input),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ));
  }
}
