import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:auto_id/model/repository/auth_repository.dart';
import 'package:auto_id/view/shared/widgets/toast_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../model/module/app_admin.dart';
import '../../model/repository/realtime_firebase.dart';
import '../../model/repository/web_sevices.dart';

part 'admin_data_event.dart';
part 'admin_data_state.dart';

class AdminDataBloc extends Bloc<AdminDataEvent, AdminDataStates> {
  AdminDataBloc() : super(GetInitialDataState.initial()) {
    on<StartDataOperations>(_startGettingDataHandler);
    on<CardDataChangedEvents>(_cardDataChangesHandler);
  }

  static AppAdmin admin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();
  final WebServices _webServices = WebServices();

  ///******************** Event handler functions **************************/
  Future<void> _startGettingDataHandler(
      StartDataOperations event, Emitter emit) async {
    if (!event.currentUser.isEmpty) {
      admin = event.currentUser;
      await _readInitialFireData(emit);
    }
  }

  void _cardDataChangesHandler(CardDataChangedEvents event, Emitter emit) {
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent.edit(event.key, event.value),
        groupList: state.groupList));
  }

  ///************************ need events **************************/

  Future<void> deleteUser(int userIndex, int groupIndex) async {
    try {
      await _webServices.deleteStudentFromSheet(userIndex, groupIndex);
      // user deleted successfully
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> sendEditData(int groupIndex, String id, Map dataToSent) async {
    try {
      await _webServices.sendStudentNewData(groupIndex, id, dataToSent);
      CardStudent student = state.cardStudent;
      if (student.state == StudentState.newStudent && student.id == id) {
        student = student.copyWith(
            name: dataToSent['Name'],
            groupIndex: groupIndex,
            state: StudentState.notRegistered);
        _adminDataRepository.updateCardState();
        // user edited successfully
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> getUserData(int groupIndex, int userIndex) async {
    try {
      Map<String, dynamic> showedUserData =
          await _webServices.getUserData(userIndex, groupIndex);
      // get user successfully
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> getGroupData(int groupIndex, {bool force = false}) async {
    if (state.groupList[groupIndex].columnNames == null) {
      try {
        state.groupList[groupIndex] = await _webServices.getGroupData(
            groupIndex, state.groupList[groupIndex]);
      } on DioErrors catch (err) {
        showToast(err.message, type: ToastType.error);
      }
    }
  }

  Future<String?> createSpreadSheet(String groupName) async {
    try {
      return await _webServices.createSpreadSheet(groupName);
      // user deleted successfully
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
      return null;
    }
  }

  Future<void> testLink(String groupName, String link) async {
    try {
      dynamic value = await _webServices.testSheetLink(groupName, link);
      if (value.toString().trim() == '-1') {
        showToast(
          "Invalid sheet please make sure that the url is public and editor",
        );
      } else {
        // table is good and returned first two rows
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> addSheetColumnNames(
      String id, String groupName, List<String> columnNames) async {
    try {
      bool success =
          await _webServices.addColumnNames(id, groupName, columnNames);
      if (success) {
        await _createGroup(id, groupName);
        // group created
      } else {
        showToast("can't Create group,try again", type: ToastType.error);
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
    }
  }

  Future<void> sendToEsp(String wifiName, String wifiPassword) async {
    try {
      bool success =
          await _webServices.sendCredentialsToEsp(wifiName, wifiPassword);
      if (success) {
      } else {
        showToast("Error happened ,make sure Your WIFI and pass is correct ");
      }
    } on DioErrors catch (err) {
      showToast(err.message, type: ToastType.error);
      showToast("Make sure you connect to device wifi and try again",
          type: ToastType.error);
    }
  }

  Future<void> signOut() async {
    await _adminDataRepository.cancelListener();
    await AuthRepository.signOut();
  }

  ///************************ Helper functions **************************/
  Future<void> _createGroup(String id, String name) async {
    await _adminDataRepository.createGroup(GroupDetails(name: name, id: id));
  }

  Future<void> _readInitialFireData(Emitter emit) async {
    emit(GetInitialDataState(
        status: AdminDataStatus.loading, cardStudent: CardStudent.empty));
    if (await _checkConnectivity()) {
      CardStudent cardStudent = await _adminDataRepository.readAdminData();
      List<GroupDetails> groups = await _adminDataRepository.getGroupNames();
      emit(GetInitialDataState(
          status: AdminDataStatus.loaded,
          cardStudent: cardStudent,
          groupList: groups));
      _adminDataRepository.buildListener((key, value) {
        add(CardDataChangedEvents(key, value));
      });
    } else {
      showToast("Please Check your internet connection");
      emit(GetInitialDataState(
          status: AdminDataStatus.error, cardStudent: CardStudent.empty));
    }
  }

  Future<bool> _checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    return ([
      ConnectivityResult.wifi,
      ConnectivityResult.mobile,
      ConnectivityResult.ethernet
    ].contains(connectivityResult));
  }
}
