import 'package:auto_id/bloc/admin_bloc/admin_data_bloc.dart';
import 'package:auto_id/view/resources/styles_manager.dart';
import 'package:auto_id/view/ui/main_view/widgets/group_list.dart';
import 'package:auto_id/view/ui/main_view/widgets/user_card.dart';

import 'package:auto_id/view/ui/start_screen/signing/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../shared/functions/navigation_functions.dart';
import '../esp_config.dart';

class MainScreen extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  MainScreen({Key? key}) : super(key: key);

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
      body: SmartRefresher(
          enablePullUp: false,
          controller: _refreshController,
          onRefresh: () {
            context
                .read<AdminDataBloc>()
                .add(StartDataOperations(AdminDataBloc.admin));
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocConsumer<AdminDataBloc, AdminDataStates>(
                  buildWhen: (prev, next) => next is GetInitialDataState,
                  listenWhen: (prev, next) => next is GetInitialDataState,
                  listener: (_, state) {
                    if (state.status != AdminDataStatus.loading &&
                        _refreshController.isLoading) {
                      _refreshController.refreshCompleted();
                    }
                  },
                  builder: (_, state) {
                    if (state.status == AdminDataStatus.error) {
                      return emptyGroups();
                    } else {
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
                    }
                  }),
            ),
          )),
    );
  }

  Widget emptyGroups() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            FontAwesomeIcons.rightFromBracket,
            color: Colors.grey,
            size: 100,
          ),
          Text(
            "No internet",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
          )
        ],
      );
}
