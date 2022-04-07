import 'package:equatable/equatable.dart';

enum AdminCubitStatus { initial, loading, loaded, error }

abstract class AdminCubitStates extends Equatable {
  final AdminCubitStatus status;
  AdminCubitStates({this.status = AdminCubitStatus.initial});

  @override
  List<Object?> get props => [status];
}

//TODO : CHANGE STATES
class AppInitial extends AdminCubitStates {}

class CheckUserStateLoading extends AdminCubitStates {}

class ChangeAddTabState extends AdminCubitStates {}

class UseSheetRowAsNameError extends AdminCubitStates {}

class UseSheetRowAsNameLoading extends AdminCubitStates {}

class UseSheetRowAsNameDone extends AdminCubitStates {}

class ColumnPlusOne extends AdminCubitStates {}

class ChangeNeededColumnsState extends AdminCubitStates {}

class GetGroupDataLoading extends AdminCubitStates {}

class GetGroupNamesLoading extends AdminCubitStates {}

class GetGroupNamesError extends AdminCubitStates {}

class GetGroupNamesDone extends AdminCubitStates {}

class GetGroupPersonLoading extends AdminCubitStates {}

class GetGroupPersonError extends AdminCubitStates {}

class GetGroupPersonDone extends AdminCubitStates {}

class GoToEditUserLoading extends AdminCubitStates {}

class GoToEditUserError extends AdminCubitStates {}

class GoToEditUserDone extends AdminCubitStates {}

class TestLinkLoading extends AdminCubitStates {}

class TestLinkError extends AdminCubitStates {}

class TestLinkDone extends AdminCubitStates {}

class CreateSpreadSheetLoading extends AdminCubitStates {}

class SendToEspLoading extends AdminCubitStates {}

class SendToEspError extends AdminCubitStates {}

class GetGroupLinkLoading extends AdminCubitStates {}

class FireDataGetting extends AdminCubitStates {}

class SendToEspDone extends AdminCubitStates {}

class SendToEditLoading extends AdminCubitStates {}

class SendToEditError extends AdminCubitStates {}

class SendToEditDone extends AdminCubitStates {}

class AddGroupState extends AdminCubitStates {}

class DeletePersonLoading extends AdminCubitStates {}

class DeletePersonError extends AdminCubitStates {}

class DeletePersonDone extends AdminCubitStates {}

class DeleteGroupLoading extends AdminCubitStates {}
