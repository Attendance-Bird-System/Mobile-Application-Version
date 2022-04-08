part of "admin_data_bloc.dart";

enum AdminDataStatus { initial, loading, loaded, error }

abstract class AdminDataStates extends Equatable {
  final AdminDataStatus status;
  final CardStudent cardStudent;
  final List<GroupDetails> groupList;

  const AdminDataStates(
      {this.status = AdminDataStatus.initial,
      required this.cardStudent,
      required this.groupList});

  @override
  List<Object?> get props => [status];
}

class GetInitialDataState extends AdminDataStates {
  const GetInitialDataState(
      {AdminDataStatus status = AdminDataStatus.initial,
      required CardStudent cardStudent,
      List<GroupDetails> groupList = const []})
      : super(status: status, cardStudent: cardStudent, groupList: groupList);

  factory GetInitialDataState.initial() {
    return GetInitialDataState(
        status: AdminDataStatus.initial, cardStudent: CardStudent.empty);
  }

  // GetInitialDataState copyWith(
  //     {AdminDataStatus? status,
  //     CardStudent? cardStudent,
  //     List<GroupDetails>? groupList}) {
  //   return GetInitialDataState(
  //     status: status ?? this.status,
  //     cardStudent: cardStudent ?? this.cardStudent,
  //     groupList: groupList ?? this.groupList,
  //   );
  // }

  @override
  List<Object?> get props => [status, cardStudent, groupList.length];
}
