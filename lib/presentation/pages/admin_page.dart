import 'package:dauco/domain/usecases/delete_user_use_case.dart';
import 'package:dauco/domain/usecases/get_all_users_use_case.dart';
import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/presentation/blocs/delete_user_bloc.dart';
import 'package:dauco/presentation/blocs/get_all_users_bloc.dart';
import 'package:dauco/presentation/blocs/get_current_user_bloc.dart';
import 'package:dauco/presentation/widgets/admin_search_bar_widget.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/users_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  int? _selectedIndex;
  int _page = 0;
  bool _isLoading = false;
  bool _hasNextPage = true;
  bool _hasPreviousPage = false;
  UserSearchFilters _searchFilters = UserSearchFilters();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCurrentUserBloc(
            getCurrentUserUseCase: appInjector.get<GetCurrentUserUseCase>(),
          )..add(GetUserEvent()),
        ),
        BlocProvider(
          create: (context) => GetAllUsersBloc(
            getAllUsersUseCase: appInjector.get<GetAllUsersUseCase>(),
          )..add(GetEvent()),
        ),
        BlocProvider(
          create: (context) => DeleteUserBloc(
            deleteUserUseCase: appInjector.get<DeleteUserUseCase>(),
          ),
        ),
      ],
      child: BlocBuilder<GetCurrentUserBloc, GetCurrentUserState>(
        builder: (context, state) {
          return BlocListener<DeleteUserBloc, DeleteUserState>(
            listener: (context, deleteState) {
              if (deleteState is DeleteUserSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Usuario eliminado correctamente')),
                );
                BlocProvider.of<GetAllUsersBloc>(context).add(GetEvent());
              } else if (deleteState is DeleteUserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(deleteState.error)),
                );
              }
            },
            child: AppScaffold(
              body: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1200,
                        minWidth: 600,
                      ),
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          SafeArea(
                            child: AdminSearchBarWidget(
                              onChanged: (filters) {
                                setState(() {
                                  _searchFilters = filters;
                                });
                              },
                              role: state is GetCurrentUserSuccess
                                  ? state.getCurrentUser.role
                                  : '',
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              child: BlocListener<GetAllUsersBloc,
                                  GetAllUsersState>(
                                listener: (context, state) {
                                  if (state is GetUsersLoading) {
                                    _showLoading();
                                  } else {
                                    _hideLoading();
                                  }
                                },
                                child: BlocBuilder<GetAllUsersBloc,
                                    GetAllUsersState>(
                                  builder: (context, state) {
                                    if (_isLoading)
                                      return _buildProgressIndicator();

                                    if (state is GetUsersSuccess) {
                                      return UsersListWidget(
                                        users: state.users,
                                        screenWidth: screenWidth,
                                        selectedIndex: _selectedIndex,
                                        onItemSelected: (index) {
                                          setState(() {
                                            _selectedIndex = index;
                                          });
                                        },
                                        onNextPage: () =>
                                            _goToNextPage(context),
                                        onPreviousPage: () =>
                                            _goToPreviousPage(context),
                                        hasNextPage: _hasNextPage,
                                        hasPreviousPage: _hasPreviousPage,
                                        searchFilters: _searchFilters,
                                        onRefreshUsers: () {
                                          BlocProvider.of<GetAllUsersBloc>(
                                                  context)
                                              .add(GetEvent());
                                        },
                                      );
                                    } else if (state is GetAllUsersError) {
                                      return Text('Error: ${state.error}');
                                    }

                                    return Text('No hay usuarios',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          color: const Color.fromARGB(
                                              255, 43, 45, 66),
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _goToNextPage(BuildContext context) {
    if (!_isLoading) {
      _showLoading();
      setState(() {
        _page++;
        _hasPreviousPage = true;
      });

      BlocProvider.of<GetAllUsersBloc>(context).add(LoadMoreUsersEvent(_page));

      _hideLoading();
    }
  }

  void _goToPreviousPage(BuildContext context) {
    if (!_isLoading && _page > 0) {
      _showLoading();
      setState(() {
        _page--;
        _hasNextPage = true;
        _hasPreviousPage = _page > 0;
      });

      BlocProvider.of<GetAllUsersBloc>(context).add(LoadMoreUsersEvent(_page));

      _hideLoading();
    }
  }
}
