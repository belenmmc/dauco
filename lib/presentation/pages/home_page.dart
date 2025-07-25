import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/domain/usecases/pick_file_use_case.dart';
import 'package:dauco/presentation/blocs/get_current_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/get_all_minors_use_case.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/presentation/blocs/get_all_minors_bloc.dart';
import 'package:dauco/presentation/blocs/load_file_bloc.dart';
import 'package:dauco/presentation/widgets/minors_list_widget.dart';
import 'package:dauco/presentation/widgets/search_bar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? _selectedIndex;
  int _page = 1;
  bool _isLoading = false;
  bool _hasNextPage = true;
  bool _hasPreviousPage = false;
  String _searchQuery = '';

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
          create: (context) => LoadFileBloc(
            loadFileUseCase: appInjector.get<LoadFileUseCase>(),
            pickFileUseCase: appInjector.get<PickFileUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => GetAllMinorsBloc(
            getAllMinorsUseCase: appInjector.get<GetAllMinorsUseCase>(),
          )..add(GetEvent()),
        ),
      ],
      child: BlocBuilder<GetCurrentUserBloc, GetCurrentUserState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 167, 168, 213),
            appBar: SearchBarWidget(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              role: state is GetCurrentUserSuccess
                  ? state.getCurrentUser.role
                  : '',
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 1200,
                          minWidth: 600,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocListener<LoadFileBloc, LoadFileState>(
                              listener: (context, state) {
                                if (state is LoadFileSuccess) {
                                  _showLoading();
                                  BlocProvider.of<GetAllMinorsBloc>(context)
                                      .add(GetEvent());
                                } else if (state is LoadFileLoading) {
                                  _showLoading();
                                } else if (state is LoadFileError) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('File picker cancelled'),
                                    duration: Duration(seconds: 2),
                                  ));
                                  _hideLoading();
                                }
                              },
                              child: BlocConsumer<GetAllMinorsBloc,
                                  GetAllMinorsState>(
                                listener: (context, state) {
                                  if (state is GetAllMinorsError ||
                                      state is GetMinorsSuccess) {
                                    _hideLoading();
                                  } else if (state is GetMinorsLoading) {
                                    _showLoading();
                                  }
                                },
                                builder: (context, state) {
                                  if (_isLoading) {
                                    return _buildProgressIndicator();
                                  } else if (state is GetMinorsSuccess) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: constraints.maxHeight - 20,
                                        minHeight: 40,
                                      ),
                                      child: MinorsListWidget(
                                        minors: state.minors,
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
                                        searchQuery: _searchQuery,
                                      ),
                                    );
                                  } else if (state is GetAllMinorsError) {
                                    return Text('Error: ${state.error}');
                                  }
                                  return Text(
                                      'No hay datos, por favor, añada un archivo',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 43, 45, 66),
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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

      BlocProvider.of<GetAllMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_page));

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

      BlocProvider.of<GetAllMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_page));

      _hideLoading();
    }
  }
}
