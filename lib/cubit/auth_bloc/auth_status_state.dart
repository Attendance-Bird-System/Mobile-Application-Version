part of "auth_status_bloc.dart";

enum AuthStatus {
  initial,
  submittingEmail,
  submittingGoogle,
  sendingConfirm,
  doneConfirm,
  success,
  error,
}

class AuthStates extends Equatable {
  final AuthStatus status;
  final AppUser user;
  final bool changeUi;

  const AuthStates(
      {required this.status, required this.user, this.changeUi = false});

  factory AuthStates.initial() {
    FirebaseAuth auth = FirebaseAuth.instance;
    AppUser tempUser = AppUser.empty;
    if (auth.currentUser != null) {
      tempUser = AppUser(
          id: auth.currentUser!.uid,
          email: auth.currentUser!.email,
          photoUrl: auth.currentUser!.photoURL,
          name: auth.currentUser!.displayName);
    }
    return AuthStates(
        status: AuthStatus.initial, user: tempUser, changeUi: false);
  }

  @override
  List<Object?> get props => [status, changeUi];

  AuthStates copyWith(
      {AuthStatus? status, AppUser? user, bool changeUi = false}) {
    return AuthStates(
      status: status ?? this.status,
      user: user ?? this.user,
      changeUi: changeUi ? !this.changeUi : changeUi,
    );
  }
}
