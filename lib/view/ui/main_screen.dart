import '../../model/module/card_student.dart';
import 'package:auto_id/view/resources/color_manager.dart';
import 'package:auto_id/view/ui/start_screen/signing/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/admin_cubit.dart';
import '../../bloc/admin_states.dart';
import '../../view/shared/functions/navigation_functions.dart';
import 'esp_config.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminCubitStates>(
      listener: (BuildContext context, AdminCubitStates state) {},
      builder: (BuildContext context, AdminCubitStates state) {
        AdminCubit cubit = AdminCubit.get(context);

        // if (cubit.groupsExist == false && !(state is GetGroupDataLoading)) {
        //   cubit.getGroupNames();
        // }
        // if (cubit.groupsExist == true && cubit.currentUserId == "") {
        //   cubit.getFireData();
        // }

        return Scaffold(
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              leading: Icon(
                Icons.credit_card,
                color: Colors.white,
              ),
              title: Text(
                'DashBoard',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      navigateAndPush(context, SheetFeatures());
                    }),
                IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      // cubit.userLogOut(context);
                      navigateAndReplace(context, LoginView());
                    }),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                cubit.addGroup(context);
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    cubit.cardStudent.state == StudentState.loading
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(20)),
                                width: double.infinity,
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.label_off,
                                      color: Colors.grey,
                                      size: 80,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "No ID yet",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  ],
                                )),
                          )
                        : Container(
                            child: cubit.cardStudent.state != StudentState.newStudent
                                ? Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.orange),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Last Scan',
                                            style: TextStyle(
                                                color: ColorManager.darkGrey,
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        state is FireDataGetting ||
                                                cubit.groups != null
                                            ? Container(
                                                width: double.infinity,
                                                height: 180,
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 20,
                                                ),
                                              )
                                            : Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                '${cubit.cardStudent.name}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .orange,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                'Group : ${cubit.groups?[cubit.cardStudent.groupIndex ?? 0].name}'),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                'ID : ${cubit.cardStudent.id}'),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            cubit.cardStudent
                                                                        .state ==
                                                                    StudentState
                                                                        .notRegistered
                                                                ? Wrap(
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        'not Registered ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .error_outline,
                                                                        color: Colors
                                                                            .red,
                                                                      )
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      Text(
                                                                        'Process completed',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      )
                                                                    ],
                                                                  ),
                                                          ]),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.orange,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    'images/avatar.png',
                                                                imageErrorBuilder:
                                                                    (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Container(
                                                                    width: 50,
                                                                    child:
                                                                        Center(
                                                                      child: Image
                                                                          .asset(
                                                                              'images/avatar.png'),
                                                                    ),
                                                                  );
                                                                },
                                                                image:
                                                                    '${cubit.cardStudent.imgUrl}',
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.orange),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Text(
                                            'Last Scan',
                                            style: TextStyle(
                                                color: ColorManager.darkGrey,
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (state is FireDataGetting ||
                                            cubit.groups == null)
                                          Container(
                                            width: double.infinity,
                                            height: 150,
                                            child: CupertinoActivityIndicator(
                                              radius: 20,
                                            ),
                                          )
                                        else
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            'User doesn\'t exist',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          'ID : ${cubit.cardStudent.id}',
                                                          style: TextStyle(
                                                              color:
                                                                  ColorManager
                                                                      .darkGrey,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15.0),
                                                          child: Center(
                                                            child: TextButton(
                                                                child: Text(
                                                                    "Add the user",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            15)),
                                                                style: ButtonStyle(
                                                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                                                        EdgeInsets.all(
                                                                            15)),
                                                                    foregroundColor:
                                                                        MaterialStateProperty.all<Color>(Colors
                                                                            .lightGreen),
                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(18.0),
                                                                        side: BorderSide(color: Colors.green)))),
                                                                onPressed: () {
                                                                  showGeneralDialog(
                                                                    barrierLabel:
                                                                        "Barrier",
                                                                    barrierDismissible:
                                                                        true,
                                                                    barrierColor: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                700),
                                                                    context:
                                                                        context,
                                                                    pageBuilder:
                                                                        (_, __,
                                                                            ___) {
                                                                      return Align(
                                                                        alignment:
                                                                            Alignment.bottomCenter,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              200,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  'Adding the user to sheet ',
                                                                                  style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: Colors.orange),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Text(
                                                                                  'step 1 : choose the group',
                                                                                  style: TextStyle(decoration: TextDecoration.none, fontSize: 15, color: ColorManager.darkGrey),
                                                                                ),
                                                                                Expanded(
                                                                                  child: ListView.separated(
                                                                                      scrollDirection: Axis.horizontal,
                                                                                      itemCount: cubit.groups?.length ?? 0,
                                                                                      itemBuilder: (context, index) {
                                                                                        return menuItemBuilder(index, context, cubit, state);
                                                                                      },
                                                                                      separatorBuilder: (context, index) {
                                                                                        return SizedBox(
                                                                                          width: 10,
                                                                                        );
                                                                                      }),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          margin: EdgeInsets.only(
                                                                              bottom: 50,
                                                                              left: 12,
                                                                              right: 12),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(40),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    transitionBuilder: (_,
                                                                        anim,
                                                                        __,
                                                                        child) {
                                                                      return SlideTransition(
                                                                        position:
                                                                            Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                                                                        child:
                                                                            child,
                                                                      );
                                                                    },
                                                                  );
                                                                }),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: Colors.orange,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Container(
                                                            height: 150,
                                                            child: Center(
                                                              child: Image.asset(
                                                                  'images/avatar.png'),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ],
                                    ),
                                  )),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    state is GetGroupDataLoading
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            child: cubit.groups == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_note_sharp,
                                        color: Colors.grey,
                                        size: 100,
                                      ),
                                      Text(
                                        "no groups yet",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )
                                    ],
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: cubit.groups!.length,
                                    itemBuilder: (context, index) {
                                      return groupItemBuilder(
                                          index, context, cubit, state);
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    }),
                          )
                  ],
                ),
              ),
            ));
      },
    );
  }

  Widget groupItemBuilder(
      int index, BuildContext context, AdminCubit cubit, state) {
    return (state is GetGroupNamesLoading )
        ? Center(
            child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CupertinoActivityIndicator(
              radius: 15,
            ),
          ))
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorManager.darkGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  cubit.getGroupNamesData(index + 1, context);
                },
                child: Column(
                  children: [
                    Text(
                      cubit.groups![index].name,
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget menuItemBuilder(
      int index, BuildContext context, AdminCubit cubit, state) {
    return Center(
      child: TextButton(
          child: Text("${cubit.groups?[index].name}",
              style: TextStyle(color: Colors.orange, fontSize: 12)),
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(4)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.orange)))),
          onPressed: () {
            cubit.goToEditUser(index + 1, context);
          }),
    );
  }
}
