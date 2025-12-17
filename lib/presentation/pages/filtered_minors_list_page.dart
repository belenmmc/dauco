import 'package:dauco/data/services/analytics_service.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/presentation/pages/minor_info_page.dart';
import 'package:dauco/presentation/widgets/app_background.dart';
import 'package:dauco/presentation/widgets/minors_list_widget.dart';
import 'package:dauco/presentation/widgets/search_bar_widget.dart';
import 'package:dauco/presentation/widgets/export_dialog.dart';
import 'package:dauco/presentation/blocs/export_bloc.dart';
import 'package:dauco/domain/usecases/export_minor_use_case.dart';
import 'package:dauco/domain/usecases/get_all_minors_for_export_use_case.dart';
import 'package:dauco/dependencyInjection/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredMinorsListPage extends StatefulWidget {
  final String filterType;
  final String filterValue;
  final String chartTitle;

  const FilteredMinorsListPage({
    super.key,
    required this.filterType,
    required this.filterValue,
    required this.chartTitle,
  });

  @override
  State<FilteredMinorsListPage> createState() => _FilteredMinorsListPageState();
}

class _FilteredMinorsListPageState extends State<FilteredMinorsListPage> {
  List<Minor> _minors = [];
  bool _isLoading = true;
  String? _error;
  final AnalyticsService _analyticsService = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _loadFilteredMinors();
  }

  Future<void> _loadFilteredMinors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final filteredMinors = await _analyticsService.getFilteredMinors(
        widget.filterType,
        widget.filterValue,
      );

      setState(() {
        _minors = filteredMinors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar los menores: $e';
        _isLoading = false;
      });
    }
  }

  String _getFilterTypeInSpanish(String filterType) {
    switch (filterType) {
      case 'gender':
        return 'Sexo';
      case 'education':
        return 'Escolarización';
      case 'geographical':
        return 'Código Postal';
      case 'test_status':
        return 'Estado de Tests';
      case 'father_profession':
        return 'Trabajo del Padre';
      case 'mother_profession':
        return 'Trabajo de la Madre';
      case 'father_education':
        return 'Estudios del Padre';
      case 'mother_education':
        return 'Estudios de la Madre';
      case 'adoption_status':
        return 'Estado de Adopción';
      case 'birth_type':
        return 'Tipo de Parto';
      case 'evaluation':
        return 'Motivo de Evaluación';
      case 'diagnosis':
        return 'Diagnóstico';
      case 'gestation_weeks':
        return 'Semanas de Gestación';
      case 'birth_weight':
        return 'Peso al Nacer';
      case 'apgar_test':
        return 'Puntuación APGAR';
      case 'parents_civil_status':
        return 'Estado Civil de los Padres';
      case 'siblings':
        return 'Número de Hermanos';
      case 'family_members':
        return 'Miembros de la Familia';
      case 'socioeconomic_situation':
        return 'Situación Socioeconómica';
      case 'parent_age':
        return 'Edad de los Padres';
      default:
        return filterType; // Fallback to original if not mapped
    }
  }

  String _getFilterValueInSpanish(String filterType, String filterValue) {
    switch (filterType) {
      case 'gender':
        switch (filterValue) {
          case 'Masculino':
            return 'Masculino';
          case 'Femenino':
            return 'Femenino';
          default:
            return filterValue;
        }
      case 'test_status':
        switch (filterValue) {
          case 'Completados':
            return 'Completados';
          case 'Pendientes':
            return 'Pendientes';
          default:
            return filterValue;
        }
      case 'adoption_status':
        switch (filterValue) {
          case 'Adoptado':
            return 'Adoptado';
          case 'No Adoptado':
            return 'No Adoptado';
          default:
            return filterValue;
        }
      case 'parent_age':
        // Handle parent age format "Padre:<25" or "Madre:35-44"
        if (filterValue.contains(':')) {
          final parts = filterValue.split(':');
          if (parts.length == 2) {
            final parentType = parts[0];
            final ageRange = parts[1];
            return '$parentType: $ageRange años';
          }
        }
        return filterValue;
      case 'birth_weight':
        switch (filterValue) {
          case '<1500':
            return 'Menos de 1500g';
          case '1500-2500':
            return '1500-2500g';
          case '>2500':
            return 'Más de 2500g';
          default:
            return filterValue;
        }
      case 'apgar_test':
        switch (filterValue) {
          case '0-3':
            return '0-3 (Crítico)';
          case '4-6':
            return '4-6 (Moderado)';
          case '7-10':
            return '7-10 (Normal)';
          default:
            return filterValue;
        }
      case 'family_members':
        switch (filterValue) {
          case '1-2':
            return '1-2 miembros';
          case '3-4':
            return '3-4 miembros';
          case '5+':
            return '5 o más miembros';
          default:
            return filterValue;
        }
      // For most other filter types, the values are already in Spanish
      default:
        return filterValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom header since we want different behavior than SearchBarWidget
            _buildHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 240, 245, 250),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 43, 45, 66),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chartTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 45, 66),
                  ),
                ),
                Text(
                  '${_getFilterTypeInSpanish(widget.filterType)}: ${_getFilterValueInSpanish(widget.filterType, widget.filterValue)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 97, 135, 174),
                  ),
                ),
              ],
            ),
          ),
          // Add Export Button
          if (_minors.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.download,
                color: Color.fromARGB(255, 43, 45, 66),
              ),
              onPressed: () => _showExportDialog(),
              tooltip: 'Exportar menores y tests',
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 97, 135, 174),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFilteredMinors,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 97, 135, 174),
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_minors.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Color.fromARGB(255, 97, 135, 174),
            ),
            SizedBox(height: 16),
            Text(
              'No se encontraron menores con estos filtros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 43, 45, 66),
              ),
            ),
          ],
        ),
      );
    }

    // Use the existing MinorsListWidget
    return MinorsListWidget(
      minors: _minors,
      screenWidth: MediaQuery.of(context).size.width,
      selectedIndex: null, // No selection needed for this view
      onItemSelected: (int index) async {
        // Navigate to MinorInfoPage when a minor is selected
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MinorInfoPage(
              minor: _minors[index],
              role: 'admin', // Pass the role
            ),
          ),
        );

        // If the minor was updated, reload the filtered list
        if (result == true) {
          _loadFilteredMinors();
        }
      },
      onNextPage: () {
        // No pagination in this filtered view
      },
      onPreviousPage: () {
        // No pagination in this filtered view
      },
      hasNextPage: false, // Disable pagination for filtered view
      hasPreviousPage: false, // Disable pagination for filtered view
      searchFilters:
          SearchFilters(), // Empty filters since we're already filtered
      role: 'admin', // Pass the role parameter
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => ExportBloc(
          exportMinorUseCase: appInjector.get<ExportMinorUseCase>(),
          getAllMinorsForExportUseCase: appInjector.get<GetAllMinorsForExportUseCase>(),
        ),
        child: ExportDialog(
          minors: _minors,
          filterType: widget.filterType,
          filterValue: widget.filterValue,
          title: 'Exportar ${widget.chartTitle}',
        ),
      ),
    );
  }
}
