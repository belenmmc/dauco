import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/services/analytics_service.dart';
import '../../domain/entities/minor.entity.dart';
import '../widgets/app_background.dart';
import '../widgets/export_dialog.dart';
import '../blocs/export_bloc.dart';
import '../../domain/usecases/export_minor_use_case.dart';
import '../../domain/usecases/get_all_minors_for_export_use_case.dart';
import '../../dependencyInjection/dependency_injection.dart';

class FilteredMinorsPage extends StatefulWidget {
  final String filterType;
  final String filterValue;

  const FilteredMinorsPage({
    Key? key,
    required this.filterType,
    required this.filterValue,
  }) : super(key: key);

  @override
  State<FilteredMinorsPage> createState() => _FilteredMinorsPageState();
}

class _FilteredMinorsPageState extends State<FilteredMinorsPage> {
  final AnalyticsService _analyticsService = AnalyticsService();
  List<Minor> _filteredMinors = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFilteredMinors();
  }

  Future<void> _loadFilteredMinors() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final minors = await _analyticsService.getFilteredMinors(
        widget.filterType,
        widget.filterValue,
      );

      setState(() {
        _filteredMinors = minors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getFilterTitle() {
    switch (widget.filterType) {
      case 'gender':
        return 'Sexo: ${widget.filterValue}';
      case 'education':
        return 'Nivel de Escolarización: ${widget.filterValue}';
      case 'diagnosis':
        return 'Estado de Diagnóstico: ${widget.filterValue}';
      case 'evaluation':
        return 'Motivo de Evaluación: ${widget.filterValue}';
      case 'geographical':
        return 'Localización: ${widget.filterValue}';
      case 'test_status':
        return 'Estado de Tests: ${widget.filterValue}';
      case 'father_profession':
        return 'Profesión del Padre: ${widget.filterValue}';
      case 'mother_profession':
        return 'Profesión de la Madre: ${widget.filterValue}';
      case 'father_education':
        return 'Estudios del Padre: ${widget.filterValue}';
      case 'mother_education':
        return 'Estudios de la Madre: ${widget.filterValue}';
      case 'adoption_status':
        return 'Estado de Adopción: ${widget.filterValue}';
      case 'birth_type':
        return 'Tipo de Parto: ${widget.filterValue}';
      default:
        return 'Filtro: ${widget.filterValue}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(
            'Menores Filtrados',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 55, 57, 82),
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          if (_filteredMinors.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download, color: Colors.black),
              onPressed: _showExportDialog,
              tooltip: 'Exportar menores y tests',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFilterTitle(),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 43, 45, 66),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_filteredMinors.length} menores encontrados',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 107, 114, 128),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Minors list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error al cargar los datos',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color:
                                      const Color.fromARGB(255, 107, 114, 128),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : _filteredMinors.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color:
                                        const Color.fromARGB(255, 107, 114, 128)
                                            .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No se encontraron menores',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                          255, 107, 114, 128),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No hay menores que coincidan con este filtro',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color.fromARGB(
                                          255, 107, 114, 128),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _filteredMinors.length,
                              itemBuilder: (context, index) {
                                final minor = _filteredMinors[index];
                                return _buildMinorCard(minor);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinorCard(Minor minor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: minor.sex == 'Masculino'
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  minor.sex == 'Masculino' ? Icons.male : Icons.female,
                  color: minor.sex == 'Masculino' ? Colors.blue : Colors.pink,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menor ${minor.reference}', // Using reference since we don't have name
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 43, 45, 66),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${minor.minorId}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 107, 114, 128),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 99, 102, 241).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _calculateAge(minor.birthdate),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 99, 102, 241),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.school, minor.schoolingLevel),
              const SizedBox(width: 8),
              _buildInfoChip(Icons.location_on, minor.zipCode.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 244, 246),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color.fromARGB(255, 107, 114, 128),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color.fromARGB(255, 107, 114, 128),
            ),
          ),
        ],
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return '${age - 1} años';
    }
    return '$age años';
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
          minors: _filteredMinors,
          filterType: widget.filterType,
          filterValue: widget.filterValue,
          title: 'Exportar menores filtrados',
        ),
      ),
    );
  }
}
