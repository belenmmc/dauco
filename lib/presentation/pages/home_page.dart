import 'package:dauco/domain/usecases/get_current_user_use_case.dart';
import 'package:dauco/domain/usecases/pick_file_use_case.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/blocs/get_current_user_bloc.dart';
import 'package:dauco/presentation/pages/minor_info_page.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/import_results_dialog.dart';
import 'package:dauco/presentation/widgets/export_dialog.dart';
import 'package:dauco/presentation/blocs/export_bloc.dart';
import 'package:dauco/domain/usecases/export_minor_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_for_export_use_case.dart';
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
  int _selectedIndex = -1;
  bool _isLoading = false;
  int _page = 0;
  bool _hasNextPage = true;
  bool _hasPreviousPage = false;
  SearchFilters _searchFilters = SearchFilters();
  String? _filterManagerId;

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
          return AppScaffold(
            floatingActionButton:
                BlocBuilder<GetAllMinorsBloc, GetAllMinorsState>(
              builder: (context, minorsState) {
                if (minorsState is GetMinorsSuccess &&
                    minorsState.minors.isNotEmpty) {
                  // Check if admin needs filters applied
                  bool isAdmin = state is GetCurrentUserSuccess &&
                      state.getCurrentUser.role == 'admin';
                  bool hasFilters = !_searchFilters.isEmpty;
                  bool canExport = !isAdmin || hasFilters;

                  return FloatingActionButton.extended(
                    onPressed: canExport
                        ? () => _showExportDialog(minorsState.minors)
                        : null,
                    icon: Icon(
                      Icons.download,
                      color: canExport
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                    label: Text(
                      isAdmin && !hasFilters
                          ? 'Aplicar filtros para exportar'
                          : 'Exportar Menores',
                      style: TextStyle(
                        color: canExport
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    backgroundColor: canExport
                        ? const Color.fromARGB(255, 97, 135, 174)
                        : const Color.fromARGB(255, 97, 135, 174)
                            .withOpacity(0.5),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
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
                          child: SearchBarWidget(
                            onChanged: (filters) {
                              setState(() {
                                _searchFilters = filters;

                                // Extract all filters
                                _filterManagerId = filters
                                    .filters[SearchField.managerId]
                                    ?.toString();
                                final filterName = filters
                                    .filters[SearchField.name]
                                    ?.toString();
                                final filterSex = filters
                                    .filters[SearchField.sex]
                                    ?.toString();
                                final filterZipCode = filters
                                    .filters[SearchField.zipCode]
                                    ?.toString();

                                DateTime? filterBirthdateFrom;
                                DateTime? filterBirthdateTo;
                                if (filters.filters[SearchField.birthdate]
                                    is Map<String, DateTime>) {
                                  final dateRange =
                                      filters.filters[SearchField.birthdate]
                                          as Map<String, DateTime>;
                                  filterBirthdateFrom = dateRange['from'];
                                  filterBirthdateTo = dateRange['to'];
                                }

                                // Reload from page 0 when filters change
                                _page = 0;
                                _hasPreviousPage = false;
                                BlocProvider.of<GetAllMinorsBloc>(context).add(
                                  LoadMoreMinorsEvent(
                                    _page,
                                    filterManagerId: _filterManagerId,
                                    filterName: filterName,
                                    filterSex: filterSex,
                                    filterZipCode: filterZipCode,
                                    filterBirthdateFrom: filterBirthdateFrom,
                                    filterBirthdateTo: filterBirthdateTo,
                                  ),
                                );
                              });
                            },
                            onAdvancedFiltersToggle: (isExpanded) {
                              // El espacio ahora se maneja automáticamente con Expanded
                            },
                            role: state is GetCurrentUserSuccess
                                ? state.getCurrentUser.role
                                : '',
                            showBackButton: false,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: BlocListener<LoadFileBloc, LoadFileState>(
                              listener: (context, state) {
                                if (state is LoadFileSuccess) {
                                  print('LoadFileSuccess triggered');
                                  _showLoading();
                                  BlocProvider.of<GetAllMinorsBloc>(context)
                                      .add(GetEvent());
                                } else if (state is LoadFileCompleted) {
                                  print(
                                      'LoadFileCompleted triggered with results: ${state.getImportResults}');
                                  _hideLoading();
                                  _showImportResultsDialog(
                                      context, state.getImportResults);
                                  BlocProvider.of<GetAllMinorsBloc>(context)
                                      .add(GetEvent());
                                } else if (state is LoadFileLoading) {
                                  print('LoadFileLoading triggered');
                                  _showLoading();
                                } else if (state is LoadFileError) {
                                  print(
                                      'LoadFileError triggered: ${state.error}');
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text('Selección de archivo cancelada'),
                                    backgroundColor:
                                        Color.fromARGB(255, 55, 57, 82),
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
                                    return BlocBuilder<GetCurrentUserBloc,
                                        GetCurrentUserState>(
                                      builder: (context, userState) {
                                        String userRole = '';
                                        if (userState
                                            is GetCurrentUserSuccess) {
                                          userRole = userState.currentUser.role;
                                        }

                                        return MinorsListWidget(
                                          minors: state.minors,
                                          screenWidth: screenWidth,
                                          selectedIndex: _selectedIndex,
                                          onItemSelected: (index) async {
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MinorInfoPage(
                                                  minor: state.minors[index],
                                                  role: userRole,
                                                ),
                                              ),
                                            );

                                            if (result == true) {
                                              context
                                                  .read<GetAllMinorsBloc>()
                                                  .add(GetEvent());
                                            }
                                          },
                                          onNextPage: () =>
                                              _goToNextPage(context),
                                          onPreviousPage: () =>
                                              _goToPreviousPage(context),
                                          hasNextPage: _hasNextPage,
                                          hasPreviousPage: _hasPreviousPage,
                                          searchFilters: _searchFilters,
                                          role: userRole,
                                        );
                                      },
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
                          ),
                        ),
                      ],
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

      _applyFiltersAndLoadPage(context);

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

      _applyFiltersAndLoadPage(context);

      _hideLoading();
    }
  }

  void _applyFiltersAndLoadPage(BuildContext context) {
    final filterName = _searchFilters.filters[SearchField.name]?.toString();
    final filterSex = _searchFilters.filters[SearchField.sex]?.toString();
    final filterZipCode =
        _searchFilters.filters[SearchField.zipCode]?.toString();

    DateTime? filterBirthdateFrom;
    DateTime? filterBirthdateTo;
    if (_searchFilters.filters[SearchField.birthdate]
        is Map<String, DateTime>) {
      final dateRange = _searchFilters.filters[SearchField.birthdate]
          as Map<String, DateTime>;
      filterBirthdateFrom = dateRange['from'];
      filterBirthdateTo = dateRange['to'];
    }

    BlocProvider.of<GetAllMinorsBloc>(context).add(
      LoadMoreMinorsEvent(
        _page,
        filterManagerId: _filterManagerId,
        filterName: filterName,
        filterSex: filterSex,
        filterZipCode: filterZipCode,
        filterBirthdateFrom: filterBirthdateFrom,
        filterBirthdateTo: filterBirthdateTo,
      ),
    );
  }

  void _showImportResultsDialog(
      BuildContext context, Map<String, Map<String, int>> importResults) {
    print('_showImportResultsDialog called with results: $importResults');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ImportResultsDialog(importResults: importResults);
      },
    );
  }

  void _showExportDialog(List<Minor> allMinors) {
    // Apply the same filtering logic as MinorsListWidget
    List<Minor> minorsToExport = _getFilteredMinors(allMinors);

    print('🔍 HOME PAGE: Total minors: ${allMinors.length}');
    print('🔍 HOME PAGE: Filtered minors: ${minorsToExport.length}');
    print(
        '🔍 HOME PAGE: Filter applied: zipCode=${_searchFilters.filters[SearchField.zipCode]}');

    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => ExportBloc(
          exportMinorUseCase: appInjector.get<ExportMinorUseCase>(),
          getAllMinorsForExportUseCase:
              appInjector.get<GetAllMinorsForExportUseCase>(),
        ),
        child: ExportDialog(
          minors: minorsToExport, // Use filtered minors instead of all minors
          title: 'Exportar Todos los Menores',
          filterType: _searchFilters.filters[SearchField.zipCode] != null
              ? 'geographical'
              : null,
          filterValue: _searchFilters.filters[SearchField.zipCode]?.toString(),
        ),
      ),
    );
  }

  // Copy the same filtering logic from MinorsListWidget
  List<Minor> _getFilteredMinors(List<Minor> allMinors) {
    if (_searchFilters.isEmpty) {
      return allMinors;
    }

    return allMinors.where((minor) {
      // Apply zipCode filter (exact same logic as MinorsListWidget)
      final zipCodeFilter = _searchFilters.filters[SearchField.zipCode];
      if (zipCodeFilter != null && zipCodeFilter.toString().isNotEmpty) {
        if (!minor.zipCode
            .toString()
            .toLowerCase()
            .contains(zipCodeFilter.toString().toLowerCase())) {
          return false;
        }
      }

      // Add other filters as needed...
      return true;
    }).toList();
  }
}
