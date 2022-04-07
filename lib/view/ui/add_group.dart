import 'package:auto_id/view/resources/color_manager.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/admin_cubit.dart';
import '../../bloc/admin_states.dart';

List<String> neededColumnsNames = const [
  "ID",
  "Name",
  "Gender",
  "Department",
  "Image",
  "Phone",
  "second-Phone",
  "Email",
  "LinkedIn",
  "Facebook",
  "Address"
];

// ignore: must_be_immutable
class AddGroup extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();
  var sheetLinkController = TextEditingController();
  var columnNameController = TextEditingController();
  var sheetNameController = TextEditingController();
  int currentColumnToFill = 65;
  int addIndex = 0;
  List<bool> neededColumns =
      List.generate(neededColumnsNames.length, (index) => index < 2);
  List<String> renameRowsName = [];
  bool useSheetRowAsName = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (BuildContext context, AdminCubitStates state) {},
      builder: (BuildContext context, AdminCubitStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.darkGrey,
                child: state is CreateSpreadSheetLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.check,
                        size: 40,
                        color: Colors.white,
                      ),
                onPressed: () {
                  if (addIndex == 0) {
                    if (formKey3.currentState!.validate()) {
                      cubit.getNamesFromBoolean(neededColumns);
                      cubit
                          .createSpreadSheet(sheetNameController.text, context)
                          .then((value) {
                        print(value);
                        cubit.addColumnNames(
                            value, sheetNameController.text, context);
                      });
                    }
                  } else {
                    if (formKey.currentState!.validate()) {
                      if (useSheetRowAsName) {
                        cubit.testLink(context, sheetNameController.text,
                            sheetLinkController.text);
                      } else {
                        if (renameRowsName.length ==
                            cubit.tableNumberOfUnnamedColumns) {
                          cubit.addColumnNames(
                              sheetLinkController.text.split('/')[5],
                              sheetNameController.text,
                              context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 4), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  title: Text("make sure you name all columns"),
                                  backgroundColor: Colors.red,
                                );
                              });
                        }
                      }
                    }
                  }
                },
              ),
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.white,
                color: Colors.orange,
                items: [
                  Icon(
                    Icons.create_new_folder_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.folder_open_sharp,
                    size: 30,
                    color: Colors.white,
                  ),
                ],
                onTap: (index) {
                  //Handle button tap
                  addIndex = index;
                  cubit.changeAddTab();
                },
              ),
              appBar: AppBar(
                foregroundColor: Colors.white,
                title: Text('Add Group'),
              ),
              body: Container(
                child: addIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Create new Sheet',
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Form(
                                  key: formKey3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                          controller: sheetNameController,
                                          keyboardType: TextInputType.text,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Name cannot be empty';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Group name",
                                            prefixIcon: Icon(Icons
                                                .drive_file_rename_outline),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.orange,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          )),
                                    ],
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'specify your needed columns',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: ColorManager.darkGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "ID",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: true,
                                    onChanged: (newValue) {},
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Name",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: true,
                                    onChanged: (newValue) {},
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Gender",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[2],
                                    onChanged: (newValue) {
                                      neededColumns[2] = !neededColumns[2];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Department",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[3],
                                    onChanged: (newValue) {
                                      neededColumns[3] = !neededColumns[3];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Image URL",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[4],
                                    onChanged: (newValue) {
                                      neededColumns[4] = !neededColumns[4];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Phone number",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[5],
                                    onChanged: (newValue) {
                                      neededColumns[5] = !neededColumns[5];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Other phone number",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[6],
                                    onChanged: (newValue) {
                                      neededColumns[6] = !neededColumns[5];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "Email",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[7],
                                    onChanged: (newValue) {
                                      neededColumns[7] = !neededColumns[7];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "LinkedIn",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[8],
                                    onChanged: (newValue) {
                                      neededColumns[8] = !neededColumns[8];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "facebook",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[9],
                                    onChanged: (newValue) {
                                      neededColumns[9] = !neededColumns[9];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                              Container(
                                child: CheckboxListTile(
                                    title: Text(
                                      "address",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: neededColumns[10],
                                    onChanged: (newValue) {
                                      neededColumns[10] = !neededColumns[10];
                                      cubit.changeNeededColumns();
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                    contentPadding: EdgeInsets.all(0.0)),
                              ),
                            ],
                          ),
                        )),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: [
                                Form(
                                    key: formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'If you already have sheet',
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            'make sure that the link is "Editor" & "For every one" \nThe ID column should named as <ID>\nThe name column should named as <Name>"',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextFormField(
                                            controller: sheetNameController,
                                            keyboardType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Name cannot be empty';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Group name",
                                              prefixIcon: Icon(Icons
                                                  .drive_file_rename_outline),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                            controller: sheetLinkController,
                                            keyboardType: TextInputType.url,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Link cannot be empty';
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              enabled: useSheetRowAsName,
                                              labelText: "Sheet Link",
                                              prefixIcon: Icon(Icons.link),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.orange,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: CheckboxListTile(
                                              title: Text(
                                                "Use the first Row as columns name",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              value: useSheetRowAsName,
                                              onChanged: (newValue) {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit
                                                      .useSheetRowAsNameCheckBox(
                                                          context,
                                                          useSheetRowAsName,
                                                          sheetLinkController
                                                              .text);
                                                }
                                              },
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading, //  <-- leading Checkbox
                                              contentPadding:
                                                  EdgeInsets.all(0.0)),
                                        ),
                                      ],
                                    )),
                                Container(
                                    child: state is UseSheetRowAsNameLoading
                                        ? Center(
                                            child: CircularProgressIndicator())
                                        : useSheetRowAsName == true
                                            ? Container()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Text(
                                                        'specify column name',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: ColorManager
                                                                .darkGrey)),
                                                  ),
                                                  Form(
                                                    key: formKey2,
                                                    child: TextFormField(
                                                        controller:
                                                            columnNameController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'column name cannot be empty';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Column ${String.fromCharCode(currentColumnToFill)} name",
                                                          prefixIcon: Icon(Icons
                                                              .file_copy_outlined),
                                                          suffixIcon:
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (formKey2
                                                                        .currentState!
                                                                        .validate()) {
                                                                      cubit.addRowName(
                                                                          columnNameController
                                                                              .text,
                                                                          currentColumnToFill,
                                                                          context);
                                                                    }
                                                                    columnNameController
                                                                        .text = "";
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .next_plan_outlined,
                                                                    size: 25,
                                                                    color: Colors
                                                                        .orange,
                                                                  )),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color:
                                                                    ColorManager
                                                                        .darkGrey,
                                                                width: 2.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        )),
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: DataTable(
                                                      columns: cubit
                                                          .tableNameColumns,
                                                      rows: cubit.tableNameRows,
                                                    ),
                                                  ),
                                                ],
                                              )),
                              ],
                            ),
                          ),
                        ),
                      ),
              )),
        );
      },
    );
  }
}
