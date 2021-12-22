import 'dart:async';
import 'dart:convert';
import 'package:auto_id/layouts/User_screen.dart';
import 'package:auto_id/layouts/add_group.dart';
import '../layouts/sign_pages/change_password.dart';
import 'package:auto_id/layouts/edit_user.dart';
import 'package:auto_id/layouts/group_screen.dart';
import '../layouts/sign_pages/login_page.dart';
import 'package:auto_id/layouts/main_screen.dart';
import 'package:auto_id/reusable/reuse_components.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);

  bool hidePassword = true;
  bool rememberMe = false;
  bool validateNumber = false;
  int groupLen = 0;
  bool groupsExist = false;
  String userPhone = '';
  String verifiedID = '';
  late FirebaseAuth _auth;
  String phone = "";
  bool validateNumberForFirst = false;
  bool userISoK = false;
  final dataBase = FirebaseDatabase.instance.reference();
  int addIndex = 0;
  bool useSheetRowAsName = true;
  List<DataColumn> tableNameColumns = [];
  List<DataRow> tableNameRows = [];
  int tableNumberOfUnnamedColumns = 0;
  int currentColumnToFill = 65;
  List<String> renameRowsName = [];
  List<bool> neededColumns = [
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> neededColumnsNames = [
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
  List<String> groupNames = [];
  List editUserController = [];
  Map<String, dynamic> userData = {};
  List<String> activeGroupNames = [];
  List<String> activeGroupColumns = [];
  int activeGroup = 0;
  String userImageUrl = '';
  String currentUserId = "";
  String currentUserState = "";
  String lastUserName = "";
  int lastUserGroupIndex = 0;
  String currentUserGroupImageUrl = "";
  StreamSubscription? listener;

  void getFireData() {
    emit(FireDataGetting());
    print("fire data");
    dataBase.child(phone).once().then((snap) {
      this.currentUserId = "${snap.value['lastID'].split(',')[0]}";
      this.currentUserState = "${snap.value['lastID'].split(',')[1]}";

      var data = snap.value['data'].split(',');
      var temp = '';
      if (data[0].toString().isNotEmpty) {
        temp = data[0].substring(1, data[0].toString().length);
        if (temp.toString().isNotEmpty) lastUserGroupIndex = int.parse(temp);
        lastUserName = data[1];
        temp = data[2];
      }
      currentUserGroupImageUrl = '';
      if (temp.toString().contains("drive.google.com")) {
        currentUserGroupImageUrl =
            "https://drive.google.com/uc?export=view&id=" + temp.split('/')[5];
      }
    }).then((value) {
      emit(FireDataGot());
    });
    listener = dataBase.child(this.phone).onChildChanged.listen((event) {
      emit(FireDataGetting());
      DataSnapshot snap = event.snapshot;
      switch (snap.key) {
        case "lastID":
          this.currentUserId = "${snap.value.split(',')[0]}";
          this.currentUserState = "${snap.value.split(',')[1]}";
          emit(FireDataGot());
          break;
        case "data":
          var data = snap.value.split(',');
          if (data[0].toString().isNotEmpty) {
            var temp = data[0].substring(1, data[0].toString().length);
            if (temp.toString().isNotEmpty)
              lastUserGroupIndex = int.parse(temp);
            lastUserName = data[1];
            temp = data[2];
            currentUserGroupImageUrl = '';
            if (temp.toString().contains("drive.google.com")) {
              currentUserGroupImageUrl =
                  "https://drive.google.com/uc?export=view&id=" +
                      temp.split('/')[5];
            }
          }
          break;
      }
      emit(FireDataGot());
    });
  }

  void getGroupLink(BuildContext context) {
    emit(GetGroupLinkLoading());
    dataBase.child(phone).child('Groups').once().then((value) {
      var id = value.value['g$activeGroup'].split(',')[0];
      Clipboard.setData(ClipboardData(
          text: "https://docs.google.com/spreadsheets/d/" +
              id +
              "/edit?usp=sharing"));
      Fluttertoast.showToast(
          msg: "The sheet Link copied to clipboard",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Color.fromRGBO(64, 64, 6, 64),
          textColor: Colors.white,
          fontSize: 16.0);
      emit(GetGroupLinkDone());
    });
  }

  void sendEditData(
      int groupIndex, String id, Map dataToSent, BuildContext context) {
    emit(SendToEditLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbxx3WO2ZZQ0jSInhHwsl6p3ZvnM4NAVP-ka0ecbqkZJRnOlj8G7qTyvZcZdknsQGvk/exec?fun=edit" +
            "&group=$groupIndex" +
            "&user_data=$dataToSent" +
            "&person_id=$id" +
            "&userName=$phone");
    print(url);
    http.read(url).then((value) {
      print("returned Data");
      print(value);
      if (currentUserState == "notfound" && currentUserId == id) {
        currentUserState = "new";
        lastUserName = dataToSent['Name'];
        lastUserGroupIndex = activeGroup;
        currentUserGroupImageUrl = "";
        dataBase.child(phone).update({
          "lastID": "$currentUserId,new",
          "data": "g$groupIndex,$lastUserName,photo"
        });
      }
      activeGroup = 0;
      navigateAndReplace(context, MainScreen());
    }).catchError((err) {
      print("error is $err");
      emit(SendToEditError());
    });
  }

  void goToUser(int groupIndex, int userIndex, BuildContext context) {
    userData = {};
    emit(GetGroupPersonLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?" +
            "userName=$phone" +
            "&group=$groupIndex" +
            "&index=${userIndex + 1}");
    http.read(url).catchError((err) {
      emit(GetGroupPersonError());
    }).then((value) {
      if (!value.startsWith('<!DOCTYPE')) {
        value = '{"$value"}';
        value = value.replaceAll(',', '","');
        value = value.replaceAll('https":"', "https:");
        value = value.replaceAll('http":"', "http:");
        userData = json.decode(value);
      }
      userImageUrl = "";
      for (var v in userData.values) {
        if (v.contains('drive.google.com')) {
          userImageUrl =
              "https://drive.google.com/uc?export=view&id=" + v.split('/')[5];
        }
      }
      navigateAndPush(context, UserScreen(userIndex, groupIndex));
      emit(GetGroupPersonDone());
    }).catchError((onError) {
      emit(GetGroupPersonError());
      print(onError);
    });
  }

  void goToEditUser(int index, BuildContext context) {
    editUserController = [];
    emit(GoToEditUserLoading());
    if (index != activeGroup) {
      activeGroup = index;
      activeGroupNames = [];
      var url = Uri.parse(
          "https://script.google.com/macros/s/AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?" +
              "userName=$phone" +
              "&group=$index");
      http.read(url).then((value) {
        if (!value.startsWith('<!DOCTYPE')) {
          var list = value.split("!");
          activeGroupNames = list[0].split(',');
          activeGroupColumns = list[1].split(',');
        }
        navigateAndPush(context, EditUserScreen(currentUserId, index, false));
        emit(GoToEditUserDone());
      }).catchError((onError) {
        emit(GoToEditUserError());
        print(onError);
      });
    } else {
      navigateAndPush(context, EditUserScreen(currentUserId, index, false));
      emit(GetGroupNamesDone());
    }
  }

  void getUserData(int groupIndex, int userIndex, BuildContext context) {
    userData = {};
    emit(GetGroupPersonLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzAWq8QxQDISfOGFEougyd4gK29jQr3SWRUbDBgAR4Q6E-rekQbHqkrouqkidbG5SY/exec?" +
            "userName=$phone" +
            "&group=$groupIndex" +
            "&index=${userIndex + 1}");
    http.read(url).catchError((err) {
      print(err);
      emit(GetGroupPersonError());
    }).then((value) {
      if (!value.startsWith('<!DOCTYPE')) {
        value = '{"$value"}';
        value = value.replaceAll(',', '","');
        value = value.replaceAll('https":"', "https:");
        value = value.replaceAll('http":"', "http:");
        userData = json.decode(value);
      }
      emit(GetGroupPersonDone());
    });
  }

  void getGroupNamesData(int index, BuildContext context) {
    emit(GetGroupNamesLoading());
    if (index != activeGroup) {
      activeGroup = index;
      activeGroupNames = [];
      var url = Uri.parse(
          "https://script.google.com/macros/s/AKfycbwCgPd0uvbcYCrn3D5v-4GsH_E9OhMUakXe2D3tY0phqN3nxivfWn3efJ4TE6ckqgXa/exec?" +
              "userName=$phone" +
              "&group=$index");
      http.read(url).catchError((err) {
        print(err);
        emit(GetGroupNamesError());
      }).then((value) {
        if (!value.startsWith('<!DOCTYPE')) {
          var list = value.split("!");
          activeGroupNames = list[0].split(',');
          activeGroupColumns = list[1].split(',');
        }
        navigateAndPush(context, GroupScreen(index));
        emit(GetGroupNamesDone());
      });
    } else {
      navigateAndPush(context, GroupScreen(index));
      emit(GetGroupNamesDone());
    }
  }

  Future<void> getGroupNames() async {
    emit(GetGroupDataLoading());
    print("phone $phone");
    if (phone.isNotEmpty) {
      dataBase.child(phone).once().then((snap) {
        var doc = snap.value;
        print(doc);
        groupLen = doc['nGroups'];
        dataBase.child(phone).child("Groups").once().then((snap) {
          doc = snap.value;
          groupNames = [];
          for (int i = 1; i <= groupLen; i++) {
            groupNames.add(doc['g$i'].split(',')[1]);
          }
          groupsExist = true;
          emit(GetGroupDatDone());
        });
      });
    }
  }

  void getNamesFromBoolean() {
    renameRowsName = [];
    for (int i = 0; i < 11; i++) {
      if (neededColumns[i]) {
        renameRowsName.add(neededColumnsNames[i]);
      }
    }
  }

  void changeNeededColumns(int index) {
    neededColumns[index] = !neededColumns[index];
    emit(ChangeNeededColumnsState());
  }

  void addColumnNames(String id, String groupName, BuildContext context) {
    // run the script to make a column with the id
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbyDVddZV5IbMoj93yxZKY7tPdcyxG7pqjq5wkNTOxPHAKUsLZdvZoWZsjfmCJbhhO6NHA/exec?id=" +
            id +
            "&list=$renameRowsName");
    http.read(url).catchError((err) {
      print(err);
    }).then((value) {
      if (value.trim() == '1') {
        createGroup(id, groupName, context);
      }
    });
  }

  Future<void> createGroup(String id, String name, BuildContext context) async {
    var data = dataBase.child(phone);
    groupLen++;
    String childName = "g$groupLen";
    data.update({'nGroups': groupLen});
    groupNames.add(name);
    data.child('Groups').update({childName: "$id,$name"}).catchError((err) {
      print(err);
      emit(CreateGroupError());
    }).then((value) {
      navigateAndReplace(context, MainScreen());
    });
  }

  Future<String> createSpreadSheet(String groupName, BuildContext context) {
    emit(CreateSpreadSheetLoading());
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbz3o9eqSWAGqFUf1C2Vk1waU6DgaqyVUjPtSyz9rw8ZQ-o_8U_aAwnnCaunX1Heo3Vn/exec?name=" +
            phone +
            " " +
            groupName);
    return http.read(url);
  }

  void addRowName(String value, BuildContext context) {
    if (currentColumnToFill - 64 <= tableNumberOfUnnamedColumns) {
      renameRowsName.add(value.replaceAll(" ", "-"));
      currentColumnToFill++;
      emit(ColumnPlusOne());
    } else {
      errDialog(context, "You name all column click the create button", 4);
    }
  }

  void createTable(String value) {
    tableNameColumns = [];
    tableNameRows = [];
    tableNumberOfUnnamedColumns =
        int.parse(value.split('}{')[0].split('->')[1]);
    List<String> row1 = value
        .split('}{')[1]
        .split("->")[1]
        .split('][')[0]
        .replaceAll(' [[', '')
        .split(',');
    List<String> row2 = value
        .split('}{')[1]
        .split("->")[1]
        .split('][')[1]
        .replaceAll(']]}', '')
        .split(',');
    List<DataCell> dCells1 = [];
    List<DataCell> dCells2 = [];

    for (var i = 0; i < tableNumberOfUnnamedColumns; i++) {
      tableNameColumns.add(
        DataColumn(
            label: Text(String.fromCharCode(i + 65),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      );
      dCells1.add(DataCell(Text(row1[i])));
      dCells2.add(DataCell(Text(row2[i])));
    }
    tableNameRows = [DataRow(cells: dCells1), DataRow(cells: dCells2)];
  }

  void testLink(BuildContext context, String groupName, String link) {
    emit(TestLinkLoading());
    emit(CreateSpreadSheetLoading());
    String id = link.split('/')[5];
    var url = Uri.parse(
        "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
            id);
    http.read(url).catchError((err) {
      print(err);
      errDialog(
          context, "Error happened while reading the data please try again", 2);
      emit(TestLinkError());
    }).then((value) {
      if (value.trim() == '-1') {
        errDialog(
            context,
            "Invalid sheet please make sure that the url is public and editor",
            4);
        emit(TestLinkError());
      } else {
        // Link Is Ok
        createGroup(id, groupName, context);
        emit(TestLinkDone());
      }
    });
  }

  void useSheetRowAsNameCheckBox(BuildContext context, String link) {
    emit(UseSheetRowAsNameLoading());
    renameRowsName = [];
    currentColumnToFill = 65;
    if (useSheetRowAsName) {
      useSheetRowAsName = !useSheetRowAsName;
      String id = link.split('/')[5];
      var url = Uri.parse(
          "https://script.google.com/macros/s/AKfycbzi7OBUEk5ZaBWeOjelTJMVMaJnK4zTU78UwB59qJW0GvJBnZ_daHmY_VPusN3xCZb0jw/exec?id=" +
              id);
      http.read(url).catchError((err) {
        print(err);
        useSheetRowAsName = !useSheetRowAsName;
        errDialog(context,
            "Error happened while reading the data please try again", 2);
        emit(UseSheetRowAsNameError());
      }).then((value) {
        if (value.trim() == '-1') {
          useSheetRowAsName = !useSheetRowAsName;
          errDialog(
              context,
              "Invalid sheet please make sure that the url is public and editor",
              2);
          emit(UseSheetRowAsNameError());
        } else {
          createTable(value);
          emit(UseSheetRowAsNameDone());
        }
      });
    } else {
      useSheetRowAsName = !useSheetRowAsName;
      emit(UseSheetRowAsNameDone());
    }
  }

  void changeAddTab(index) {
    currentColumnToFill = 65;
    renameRowsName = [];
    addIndex = index;
    emit(ChangeAddTabState());
  }

  void sendToEsp(BuildContext context, String wifiName, String wifiPassword) {
    emit(SendToEspLoading());
    var url = Uri.parse(
        'http://192.168.4.1/data?user=$phone&wifi=$wifiName&pass=$wifiPassword');
    http.read(url).catchError((e) {
      errDialog(context,
          "Error happened ,make sure you connect to ESP wifi and try again", 2);
      print(e);
      emit(SendToEspError());
    }).then((value) {
      if (value.trim() != "Failed") {
        navigateAndReplace(context, MainScreen());
        emit(SendToEspDone());
      } else {
        errDialog(context,
            "Error happened ,make sure Your WIFI and pass is correct ", 4);
        emit(SendToEspError());
      }
    });
  }

  void addGroup(BuildContext context) {
    addIndex = 0;
    useSheetRowAsName = true;
    tableNameColumns = [];
    tableNameRows = [];
    tableNumberOfUnnamedColumns = 0;
    currentColumnToFill = 65;
    renameRowsName = [];
    navigateAndPush(context, AddGroup());
    emit(AddGroupState());
  }

  signUp({
    required BuildContext context,
    required String phoneNumber,
    required String userName,
    required String password,
  }) async {
    this.phone = userName;
    emit(UserSignUpLoading());
    // write data

    DataSnapshot snapshot = await dataBase.child(phone).once();
    var doc = snapshot.value;

    if (doc != null) {
      emit(UserSignUpError());
      errDialog(context, "Sorry user name already exist", 2);
    } else {
      dataBase.child(phone).update({
        'userNumber': phoneNumber,
        'Password': password,
        'nGroups': 0,
        'lastID': 'NULL,NULL',
        'data': ',,'
      }).catchError((onError) {
        emit(UserSignUpError());
      }).then((value) {
        userISoK = false;
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.orange));
        navigateAndReplace(context, MainScreen());
        emit(UserSignUpDone());
      });
    }
    // if ok
  }

  checkUserFirstOtp(BuildContext context, String otp) async {
    await _auth
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verifiedID, smsCode: otp))
        .then((value) {
      if (value.user != null) {
        userISoK = true;
        emit(UserValidateDone());
      }
    }).catchError((error) {
      errDialog(context, "Wrong OTP", 2);
      emit(UserValidateError());
    });
  }

  sendVerificationSms(BuildContext context, String sendPhone) async {
    emit(UserValidateLoading());
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    await _auth
        .verifyPhoneNumber(
            phoneNumber: '+2' + sendPhone,
            verificationCompleted: (value) {},
            verificationFailed: (value) {
              validateNumberForFirst = false;
              emit(UserSignUpError());
              errDialog(context, "Enter a valid number", 2);
            },
            codeSent: (String verificationId, [code]) {
              validateNumberForFirst = true;
              emit(UserValidateDone());
              this.verifiedID = verificationId;
            },
            timeout: Duration(seconds: 120),
            codeAutoRetrievalTimeout: (String timeout) {
              return null;
            })
        .then((value) {
      validateNumberForFirst = true;
      emit(UserValidateDone());
    });
  }

  Future changePassword(BuildContext context, String newPass) async {
    emit(UserChangePasswordLoading());
    await dataBase.child(phone).update({'Password': newPass}).catchError((_) {
      emit(UserChangePasswordError());
    }).then((v) {
      navigateAndReplace(context, LoginPage());
      emit(UserChangePasswordDone());
    });
  }

  // get data from the shared preferences to login .....
  void getUserLoginData(bool isHere) async {
    emit(CheckUserStateLoading());
    final prefs = await SharedPreferences.getInstance();
    if (isHere) {
      String phone = prefs.getString("phone")!;
      this.phone = phone;
      emit(UserLogInDone());
    }
    emit(CheckUserStateDone());
  }

  // get the phone and password to login
  void userLogIn(BuildContext context, String phone, String pass) async {
    this.phone = phone;
    emit(UserLogInLoading());

    DataSnapshot snapshot = await dataBase.child(phone).once();
    var doc = snapshot.value;
    if (doc != null) {
      if (pass == '${doc['Password']}') {
        saveData(phone);
        navigateAndReplace(context, MainScreen());
      } else {
        errDialog(context, "Wrong Password", 2);
        emit(UserLogInError());
      }
    } else {
      errDialog(context, "user doesn't exist", 2);
      emit(UserLogInError());
    }
  }

  void verifyOtp(BuildContext context, String otp) async {
    await _auth
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verifiedID, smsCode: otp))
        .then((value) {
      if (value.user != null) {
        emit(UserValidateDone());
        validateNumber = false;
        navigateAndReplace(context, ChangePassword());
      }
    }).catchError((error) {
      errDialog(context, "Wrong OTP", 2);
      emit(UserValidateError());
    });
  }

  void userValidate(BuildContext context, String phone) async {
    this.phone = phone;
    emit(UserValidateLoading());

    DataSnapshot snapshot = await dataBase.child(phone).once();
    var doc = snapshot.value;
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;

    if (doc != null) {
      userPhone = '${doc['userNumber']}';
      await _auth
          .verifyPhoneNumber(
              phoneNumber: '+2' + userPhone,
              verificationCompleted: (value) {},
              verificationFailed: (value) {},
              codeSent: (String verificationId, [code]) {
                this.verifiedID = verificationId;
              },
              timeout: Duration(seconds: 120),
              codeAutoRetrievalTimeout: (String timeout) {
                return null;
              })
          .then((value) {
        validateNumber = true;
        emit(UserValidateDone());
      });
    } else {
      errDialog(context, "User doesn't exist", 2);
      emit(UserValidateError());
    }
  }

  void userLogOut(BuildContext context) async {
    emit(UserLogOutLoading());
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', false);
    hidePassword = true;
    rememberMe = false;
    validateNumber = false;
    groupLen = 0;
    userPhone = '';
    verifiedID = '';
    phone = "";
    validateNumberForFirst = false;
    userISoK = false;
    addIndex = 0;
    useSheetRowAsName = true;
    tableNameColumns = [];
    tableNameRows = [];
    tableNumberOfUnnamedColumns = 0;
    currentColumnToFill = 65;
    renameRowsName = [];
    neededColumns = [
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    groupNames = [];
    editUserController = [];
    userData = {};
    activeGroupNames = [];
    activeGroupColumns = [];
    activeGroup = 0;
    userImageUrl = '';
    activeGroup = 0;
    userImageUrl = '';
    currentUserId = "";
    currentUserState = "";
    lastUserName = "";
    lastUserGroupIndex = 0;
    currentUserGroupImageUrl = "";
    groupsExist = false;
    currentUserId = "";
    listener!.cancel();
    navigateAndReplace(context, LoginPage());
  }

  void saveData(String phone) async {
    this.phone = phone;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe);
    if (rememberMe) {
      prefs.setString('phone', phone);
    }
  }

  void changePassShowClicked() {
    hidePassword = !hidePassword;
    emit(ChangePassShowState());
  }

  void rememberMeBoxClicked() {
    rememberMe = !rememberMe;
    emit(ChangeRememberBoxShowState());
  }
}
