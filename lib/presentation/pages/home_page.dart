import 'package:dauco/domain/usecases/import_minors_use_case.dart';
import 'package:dauco/presentation/blocs/import_minors_bloc.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:dauco/domain/usecases/load_file_use_case.dart';
import 'package:dauco/presentation/blocs/load_file_bloc.dart';
import 'package:dauco/presentation/widgets/background_widget.dart';
import 'package:dauco/presentation/widgets/minors_list_widget.dart';

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
          create: (context) => ImportMinorsBloc(
            importMinorsUseCase: appInjector.get<ImportMinorsUseCase>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Stack(
              children: [
                const Background(
                  title: 'Cargar archivo',
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          BlocListener<LoadFileBloc, LoadFileState>(
                            listener: (context, state) {
                              if (state is LoadFileSuccess) {
                                _file = state.file;
                                BlocProvider.of<ImportMinorsBloc>(context)
                                    .add(ImportEvent(state.file));
                              } else if (state is LoadFileError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('File picker cancelled'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: BlocBuilder<ImportMinorsBloc,
                                ImportMinorsState>(
                              builder: (context, state) {
                                if (state is ImportMinorsInitial ||
                                    state is ImportMinorsLoading) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        height: 150,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 247, 238, 255),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<LoadFileBloc>()
                                                .add(LoadFileEvent());
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Seleccionar\narchivo',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Color.fromARGB(
                                                      255, 43, 45, 66),
                                                ),
                                              ),
                                              SizedBox(width: 40),
                                              Icon(Icons.upload_file,
                                                  size: 64,
                                                  color: Color.fromARGB(
                                                      255, 157, 137, 180)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (state is ImportMinorsInitial)
                                        const Text('No users added'),
                                    ],
                                  );
                                } else if (state is ImportMinorsSuccess) {
                                  return MinorsListWidget(
                                    children: state.minors,
                                    screenWidth: screenWidth,
                                    selectedIndex: _selectedIndex,
                                    onItemSelected: (index) {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    onNextPage: () => _goToNextPage(
                                        context), // Pass the context
                                    onPreviousPage: () => _goToPreviousPage(
                                        context), // Pass the context
                                    hasNextPage: _hasNextPage,
                                    hasPreviousPage: _hasPreviousPage,
                                  );
                                } else if (state is ImportMinorsError) {
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _goToNextPage(BuildContext context) {
    if (!_isLoading && _file != null) {
      setState(() {
        _isLoading = true;
        _page++; // Increment the page
        _hasPreviousPage = true; // Enable the "Previous Page" button
      });

      // Fetch the next page of users
      BlocProvider.of<ImportMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_file!, _page));

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToPreviousPage(BuildContext context) {
    if (!_isLoading && _file != null && _page > 1) {
      setState(() {
        _isLoading = true;
        _page--; // Decrement the page
        _hasNextPage = true; // Enable the "Next Page" button
        _hasPreviousPage = _page >
            1; // Disable the "Previous Page" button if on the first page
      });

      // Fetch the previous page of users
      BlocProvider.of<ImportMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_file!, _page));

      setState(() {
        _isLoading = false;
      });
    }
  }
}
