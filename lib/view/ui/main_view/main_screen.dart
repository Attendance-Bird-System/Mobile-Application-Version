import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:auto_id/view/ui/main_view/widgets/group_list.dart';
import 'package:auto_id/view/ui/main_view/widgets/user_card.dart';

import 'package:auto_id/view/ui/start_screen/signing/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/functions/navigation_functions.dart';
import '../esp_config.dart';

// ignore: must_be_immutable
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          shape: StyLeManager.appBarShape,
          leading: const Icon(
            Icons.credit_card,
          ),
          title: const Text(
            'DashBoard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  navigateAndPush(context, SheetFeatures());
                }),
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // cubit.userLogOut(context);
                  navigateAndReplace(context, const LoginView());
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 40,
            color: Colors.white,
          ),
          onPressed: () {
            // cubit.addGroup(context);
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<AdminDataBloc, AdminDataStates>(
                buildWhen: (prev, next) => next is GetInitialDataState,
                builder: (context, state) {
                  return Column(
                    children: [
                      UserCard((state).cardStudent,
                          state.status == AdminDataStatus.loading),
                      const SizedBox(
                        height: 20,
                      ),
                      GroupList(state.groupList,
                          state.status == AdminDataStatus.loading),
                    ],
                  );
                }),
          ),
        ));
  }
}
