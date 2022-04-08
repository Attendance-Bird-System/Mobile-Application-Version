part of "admin_data_bloc.dart";

abstract class AdminDataEvent extends Equatable {
  const AdminDataEvent();

  @override
  List<Object?> get props => [];
}

class StartDataOperations extends AdminDataEvent {
  final AppAdmin currentUser;

  const StartDataOperations(this.currentUser);
}

class CardDataChangedEvents extends AdminDataEvent {
  final String key;
  final String value;

  const CardDataChangedEvents(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}
