import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_timer/app/modules/home/controller/home_controller.dart';
import 'package:job_timer/app/modules/home/widgets/header_projects_menu.dart';
import 'package:job_timer/app/modules/home/widgets/project_tile.dart';
import 'package:job_timer/app/view_models/project_model.dart';

class HomePage extends StatelessWidget {
  final HomeController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeController, HomeState>(
      bloc: controller,
      listener: (context, state) {
        if (state.status == HomeStatus.failure) {
          asuka.AsukaSnackbar.alert('Erro ao buscar os projetos').show();
        }
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              // UserAccountsDrawerHeader(
              //   accountName: Text("macoratti@yahoo.com"),
              //   accountEmail: Text("macoratti@yahoo.com"),
              //   currentAccountPicture: CircleAvatar(
              //     backgroundColor: Colors.white,
              //     child: Icon(
              //       Icons.people_alt_outlined,
              //       size: 50,
              //     ),
              //   ),
              // ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                subtitle: Text(''),
                onTap: () => _confirmExitApp(context),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Projetos'),
              expandedHeight: 100,
              toolbarHeight: 100,
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
            ),
            SliverPersistentHeader(
              delegate: HeaderProjectsMenu(controller: controller),
              pinned: true,
            ),
            BlocSelector<HomeController, HomeState, bool>(
              bloc: controller,
              selector: (state) => state.status == HomeStatus.loading,
              builder: (context, showLoading) {
                return SliverVisibility(
                  visible: showLoading,
                  sliver: const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 50,
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  ),
                );
              },
            ),
            BlocSelector<HomeController, HomeState, List<ProjectModel>>(
              bloc: controller,
              selector: (state) => state.projects,
              builder: (context, projects) {
                return SliverList(
                  delegate: SliverChildListDelegate(
                    projects
                        .map(
                          (project) => ProjectTile(projectModel: project),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExitApp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                'Todos os seus projetos serão apagados. Confirma a saída do aplicativo. ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.logout();
                },
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
