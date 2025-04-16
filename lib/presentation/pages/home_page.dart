import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excel/excel.dart';

import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/get_minors_use_case.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/presentation/blocs/get_minors_bloc.dart';
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
  Excel? _file;
  bool _hasNextPage = true;
  bool _hasPreviousPage = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoadFileBloc(
            loadFileUseCase: appInjector.get<LoadFileUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => GetMinorsBloc(
            importMinorsUseCase: appInjector.get<GetMinorsUseCase>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 167, 168, 213),
            appBar: SearchBarWidget(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
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
                                  _file = state.file;
                                  BlocProvider.of<GetMinorsBloc>(context)
                                      .add(GetEvent(state.file));
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
                              child:
                                  BlocConsumer<GetMinorsBloc, GetMinorsState>(
                                listener: (context, state) {
                                  if (state is GetMinorsError ||
                                      state is GetMinorsSuccess) {
                                    _hideLoading();
                                  } else if (state is GetMinorsLoading) {
                                    _showLoading();
                                  }
                                },
                                builder: (context, state) {
                                  if (_isLoading) {
                                    return _buildProgressIndicator();
                                  } else if (state is GetMinorsInitial) {
                                    return _buildFileSelectionButton(context);
                                  } else if (state is GetMinorsSuccess) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: constraints.maxHeight - 20,
                                        minHeight: 40,
                                      ),
                                      child: MinorsListWidget(
                                        file: _file!,
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
                                  } else if (state is GetMinorsError) {
                                    return Text('Error: ${state.error}');
                                  }
                                  return const Text('No minors added');
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

  Widget _buildFileSelectionButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Selecciona un archivo .xlsx para cargar los datos',
          style: GoogleFonts.inter(
            fontSize: 24,
            color: Color.fromARGB(255, 43, 45, 66),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 300,
          height: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 247, 238, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () {
              context.read<LoadFileBloc>().add(LoadFileEvent());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Seleccionar\narchivo',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      color: Color.fromARGB(255, 43, 45, 66),
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(width: 40),
                const Icon(Icons.upload_file,
                    size: 64, color: Color.fromARGB(255, 157, 137, 180)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _goToNextPage(BuildContext context) {
    if (!_isLoading && _file != null) {
      _showLoading();
      setState(() {
        _page++;
        _hasPreviousPage = true;
      });

      BlocProvider.of<GetMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_file!, _page));

      _hideLoading();
    }
  }

  void _goToPreviousPage(BuildContext context) {
    if (!_isLoading && _file != null && _page > 1) {
      _showLoading();
      setState(() {
        _page--;
        _hasNextPage = true;
        _hasPreviousPage = _page > 1;
      });

      BlocProvider.of<GetMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_file!, _page));

      _hideLoading();
    }
  }
}
