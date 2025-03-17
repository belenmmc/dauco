import 'package:dauco/domain/usecases/get_minors_use_case.dart';
import 'package:dauco/presentation/blocs/get_minors_bloc.dart';
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
          create: (context) => GetMinorsBloc(
            importMinorsUseCase: appInjector.get<GetMinorsUseCase>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.4,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0.2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.menu, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(28),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    print('Search button pressed');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 58),
                        IconButton(
                          icon: Icon(
                            Icons.filter_alt_outlined,
                            size: 60,
                          ),
                          onPressed: () {
                            print('Filter button pressed');
                          },
                        ),
                        const SizedBox(width: 438),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                                BlocProvider.of<GetMinorsBloc>(context)
                                    .add(GetEvent(state.file));
                              } else if (state is LoadFileError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('File picker cancelled'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: BlocBuilder<GetMinorsBloc, GetMinorsState>(
                              builder: (context, state) {
                                if (state is GetMinorsInitial ||
                                    state is GetMinorsLoading) {
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
                                      if (state is GetMinorsInitial)
                                        const Text('No users added'),
                                    ],
                                  );
                                } else if (state is GetMinorsSuccess) {
                                  return MinorsListWidget(
                                    file: _file!,
                                    children: state.minors,
                                    screenWidth: screenWidth,
                                    selectedIndex: _selectedIndex,
                                    onItemSelected: (index) {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    onNextPage: () => _goToNextPage(context),
                                    onPreviousPage: () =>
                                        _goToPreviousPage(context),
                                    hasNextPage: _hasNextPage,
                                    hasPreviousPage: _hasPreviousPage,
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
        _page++;
        _hasPreviousPage = true;
      });

      BlocProvider.of<GetMinorsBloc>(context)
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
        _page--;
        _hasNextPage = true;
        _hasPreviousPage = _page > 1;
      });

      BlocProvider.of<GetMinorsBloc>(context)
          .add(LoadMoreMinorsEvent(_file!, _page));

      setState(() {
        _isLoading = false;
      });
    }
  }
}
