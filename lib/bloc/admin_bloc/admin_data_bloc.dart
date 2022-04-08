import 'package:auto_id/model/module/card_student.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/module/app_admin.dart';
import '../../model/repository/realtime_firebase.dart';

part 'admin_data_event.dart';
part 'admin_data_state.dart';

class AdminDataBloc extends Bloc<AdminDataEvent, AdminDataStates> {
  static AppAdmin admin = AppAdmin.empty;
  final AdminDataRepository _adminDataRepository = AdminDataRepository();

  AdminDataBloc() : super(GetInitialDataState.initial()) {
    on<StartDataOperations>(_startGettingDataHandler);
    on<CardDataChangedEvents>(_cardDataChangesHandler);
  }

  Future<void> _startGettingDataHandler(
      StartDataOperations event, Emitter emit) async {
    if (!event.currentUser.isEmpty) {
      admin = event.currentUser;
      await _readInitialFireData(emit);
    }
  }

  _cardDataChangesHandler(CardDataChangedEvents event, Emitter emit) {
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: state.cardStudent.edit(event.key, event.value),
        groupList: state.groupList));
  }

  ///*************************Helper functions***************************/
  Future<void> _readInitialFireData(Emitter emit) async {
    emit(GetInitialDataState(
        status: AdminDataStatus.loading,
        cardStudent: CardStudent(state: StudentState.empty)));
    CardStudent cardStudent = await _adminDataRepository.readAdminData();
    List<GroupDetails> groups = await _adminDataRepository.getGroupNames();
    emit(GetInitialDataState(
        status: AdminDataStatus.loaded,
        cardStudent: cardStudent,
        groupList: groups));
    // _startListen
    _adminDataRepository.buildListener((key, value) {
      add(CardDataChangedEvents(key, value));
    });
  }
}
