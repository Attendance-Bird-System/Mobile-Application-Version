import 'dart:async';

import 'package:auto_id/bloc/cubit.dart';
import 'package:auto_id/model/module/group_details.dart';
import 'package:firebase_database/firebase_database.dart';

import '../module/students/card_student.dart';

class AdminDataRepository {
  final DatabaseReference _dataBase = FirebaseDatabase.instance.ref();
  StreamSubscription? listener;

  Future<CardStudent> readAdminData() async {
    DataSnapshot snap =
        await _dataBase.child(AppCubit.appAdmin.id).child("lastCard").get();
    if (snap.exists) {
      return CardStudent.fromFireBase(snap.value);
    } else {
      return CardStudent();
    }
  }

  Future<List<GroupDetails>> getGroupNames() async {
    DataSnapshot snap =
        await _dataBase.child(AppCubit.appAdmin.id).child("groups").get();
    if (snap.exists) {
      return snap.children
          .map((e) =>
              GroupDetails(name: e.key.toString(), id: e.value.toString()))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> deleteGroup(String groupName) async {
    await _dataBase
        .child(AppCubit.appAdmin.id)
        .child("groups")
        .child(groupName)
        .remove();
  }

  Future<void> updateCardState() async {
    await _dataBase
        .child(AppCubit.appAdmin.id)
        .child("lastCard")
        .update({"state": "problem"});
  }

  Future<void> createGroup(GroupDetails group) async {
    await _dataBase
        .child(AppCubit.appAdmin.id)
        .child("groups")
        .update({group.name: group.id});
  }

  Future<void> buildListener(Function(CardStudent student) onData) async {
    await cancelListener();
    listener = _dataBase
        .child(AppCubit.appAdmin.id)
        .child("lastCard")
        .onChildChanged
        .listen((event) {
      onData(CardStudent.fromFireBase(event.snapshot.value));
    });
  }

  Future<void> cancelListener() async {
    if (listener != null) await listener?.cancel();
  }
}
