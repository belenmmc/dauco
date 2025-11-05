import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dauco/data/services/analytics_service.dart';
import 'filtered_minors_list_page.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final AnalyticsService _analyticsService = AnalyticsService();
  bool _isLoading = true;

  // For hover tooltips
  int _touchedIndex = -1;
  String _currentTouchedChart = '';

  Map<String, int> _genderData = {};
  Map<String, double> _testCompletionData = {};
  Map<String, int> _geographicalData = {};

  // New data for additional charts
  Map<String, int> _fatherJobData = {};
  Map<String, int> _motherJobData = {};
  Map<String, int> _fatherStudiesData = {};
  Map<String, int> _motherStudiesData = {};
  Map<String, int> _adoptionData = {};

  // New data for additional charts
  Map<String, int> _birthTypeData = {};
  Map<String, int> _gestationWeeksData = {};
  Map<String, int> _parentsCivilStatusData = {};
  Map<String, int> _socioeconomicData = {};
  Map<String, int> _schoolingLevelData = {};
  Map<String, int> _evaluationReasonData = {};
  List<Map<String, dynamic>> _parentsAgeData = [];
  Map<String, int> _siblingsData = {};
  Map<String, int> _birthWeightData = {};
  Map<String, int> _familyMembersData = {};
  Map<String, int> _apgarScoreData = {};

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  void _navigateToFilteredList(String filterValue, String chartType) {
    String filterType;
    String chartTitle;

    // Map chart types to filter types and titles
    switch (chartType) {
      case 'gender':
        filterType = 'gender';
        chartTitle = 'Distribución por Género';
        break;
      case 'testCompletion':
        filterType = 'test_status';
        chartTitle = 'Completado de Tests';
        break;
      case 'fatherJob':
        filterType = 'father_profession';
        chartTitle = 'Trabajo del Padre';
        break;
      case 'motherJob':
        filterType = 'mother_profession';
        chartTitle = 'Trabajo de la Madre';
        break;
      case 'fatherStudies':
        filterType = 'father_education';
        chartTitle = 'Estudios del Padre';
        break;
      case 'motherStudies':
        filterType = 'mother_education';
        chartTitle = 'Estudios de la Madre';
        break;
      case 'adoption':
        filterType = 'adoption_status';
        chartTitle = 'Estado de Adopción';
        break;
      case 'geographical':
        filterType = 'geographical';
        chartTitle = 'Distribución Geográfica';
        break;
      case 'birthType':
        filterType = 'birth_type';
        chartTitle = 'Tipo de Nacimiento';
        break;
      case 'schooling':
        filterType = 'education';
        chartTitle = 'Estado de Escolarización';
        break;
      case 'evaluation':
        filterType = 'evaluation';
        chartTitle = 'Razón de Evaluación';
        break;
      case 'diagnosis':
        filterType = 'diagnosis';
        chartTitle = 'Diagnóstico';
        break;
      case 'birthWeight':
        filterType = 'birth_weight';
        chartTitle = 'Peso al Nacer';
        break;
      case 'apgar':
        filterType = 'apgar_test';
        chartTitle = 'Puntuación APGAR';
        break;
      case 'parentsCivilStatus':
        filterType = 'parents_civil_status';
        chartTitle = 'Estado Civil de los Padres';
        break;
      case 'siblings':
        filterType = 'siblings';
        chartTitle = 'Número de Hermanos';
        break;
      case 'familyMembers':
        filterType = 'family_members';
        chartTitle = 'Miembros de la Familia';
        break;
      case 'socioeconomic':
        filterType = 'socioeconomic_situation';
        chartTitle = 'Situación Socioeconómica';
        break;
      case 'gestationWeeks':
        filterType = 'gestation_weeks';
        chartTitle = 'Semanas de Gestación';
        break;
      case 'parentAge':
        filterType = 'parent_age';
        chartTitle = 'Edad de los Padres';
        break;
      case '':
        // For charts without chartType specified, skip navigation
        print('Chart type not specified for filter value: $filterValue');
        return;
      default:
        // For unsupported chart types, skip navigation
        print('Filter type not supported: $chartType for value: $filterValue');
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilteredMinorsListPage(
          filterType: filterType,
          filterValue: filterValue,
          chartTitle: chartTitle,
        ),
      ),
    );
  }

  Future<void> _loadAnalyticsData() async {
    try {
      final results = await Future.wait([
        _analyticsService.getGenderDistribution(),
        _analyticsService.getTestCompletionStats(),
        _analyticsService.getGeographicalDistribution(),
        // New analytics
        _analyticsService.getBirthTypeDistribution(),
        _analyticsService.getGestationWeeksDistribution(),
        _analyticsService.getParentsCivilStatusDistribution(),
        _analyticsService.getSocioeconomicDistribution(),
        _analyticsService.getSchoolingLevelDistribution(),
        _analyticsService.getEvaluationReasonDistribution(),
        _analyticsService.getParentsAgeDistribution(),
        _analyticsService.getSiblingsDistribution(),
        _analyticsService.getBirthWeightDistribution(),
        _analyticsService.getFamilyMembersDistribution(),
        _analyticsService.getApgarScoreDistribution(),
        // Father and mother data
        _analyticsService.getFatherJobDistribution(),
        _analyticsService.getMotherJobDistribution(),
        _analyticsService.getFatherStudiesDistribution(),
        _analyticsService.getMotherStudiesDistribution(),
        _analyticsService.getAdoptionDistribution(),
      ]);

      setState(() {
        _genderData = results[0] as Map<String, int>;
        _testCompletionData = results[1] as Map<String, double>;
        _geographicalData = results[2] as Map<String, int>;
        // New data
        _birthTypeData = results[3] as Map<String, int>;
        _gestationWeeksData = results[4] as Map<String, int>;
        _parentsCivilStatusData = results[5] as Map<String, int>;
        _socioeconomicData = results[6] as Map<String, int>;
        _schoolingLevelData = results[7] as Map<String, int>;
        _evaluationReasonData = results[8] as Map<String, int>;
        _parentsAgeData = results[9] as List<Map<String, dynamic>>;
        _siblingsData = results[10] as Map<String, int>;
        _birthWeightData = results[11] as Map<String, int>;
        _familyMembersData = results[12] as Map<String, int>;
        _apgarScoreData = results[13] as Map<String, int>;
        // Father and mother data
        _fatherJobData = results[14] as Map<String, int>;
        _motherJobData = results[15] as Map<String, int>;
        _fatherStudiesData = results[16] as Map<String, int>;
        _motherStudiesData = results[17] as Map<String, int>;
        _adoptionData = results[18] as Map<String, int>;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(
            'Análisis de Datos',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 167, 190, 213),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 167, 190, 213),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview Cards
                      _buildOverviewCards(),
                      const SizedBox(height: 32),

                      // Section Headers and Charts
                      _buildSectionHeader('Datos Básicos'),
                      const SizedBox(height: 20),
                      _buildGenderChart(),
                      const SizedBox(height: 20),
                      _buildTestCompletionChart(),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Información del Nacimiento'),
                      const SizedBox(height: 20),
                      _buildBirthTypeChart(),
                      const SizedBox(height: 20),
                      _buildGestationWeeksChart(),
                      const SizedBox(height: 20),
                      _buildBirthWeightChart(),
                      const SizedBox(height: 20),
                      _buildApgarScoreChart(),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Información Familiar'),
                      const SizedBox(height: 20),
                      _buildParentsCivilStatusChart(),
                      const SizedBox(height: 20),
                      _buildSiblingsChart(),
                      const SizedBox(height: 20),
                      _buildFamilyMembersChart(),
                      const SizedBox(height: 20),
                      _buildSocioeconomicChart(),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Información de los Padres'),
                      const SizedBox(height: 20),
                      _buildFatherJobChart(),
                      const SizedBox(height: 20),
                      _buildMotherJobChart(),
                      const SizedBox(height: 20),
                      _buildFatherStudiesChart(),
                      const SizedBox(height: 20),
                      _buildMotherStudiesChart(),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Educación y Otras Características'),
                      const SizedBox(height: 20),
                      _buildSchoolingLevelChart(),
                      const SizedBox(height: 20),
                      _buildEvaluationReasonChart(),
                      const SizedBox(height: 20),
                      _buildAdoptionChart(),

                      const SizedBox(height: 40),
                      _buildSectionHeader('Distribución y Análisis'),
                      const SizedBox(height: 20),

                      // Full-width charts
                      _buildParentsAgeChart(),
                      const SizedBox(height: 20),
                      _buildGeographicalChart(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    final totalMinors = _genderData.values.fold(0, (sum, count) => sum + count);
    final totalTests = _testCompletionData['completed']?.toInt() ?? 0;
    final completionRate = _testCompletionData['completion_rate'] ?? 0.0;

    return Row(
      children: [
        Expanded(
            child: _buildOverviewCard('Total Menores', totalMinors.toString(),
                Icons.people, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildOverviewCard(
                'Tests Completados',
                totalTests.toString(),
                Icons.assignment_turned_in,
                Colors.green)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildOverviewCard(
                'Tasa Completado',
                '${completionRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.orange)),
      ],
    );
  }

  Widget _buildOverviewCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 43, 45, 66),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 55, 57, 82),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart, {Widget? legend}) {
    return Container(
      height: 500, // Reduced from 600px to 500px for smaller card
      padding: const EdgeInsets.all(20), // Reduced padding from 24 to 20
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22, // Increased title size from 20 to 22
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 43, 45, 66),
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing from 24 to 20
          Expanded(
            child: legend != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: chart), // Chart takes space
                      const SizedBox(width: 20), // Spacing
                      Expanded(
                          flex: 2,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                legend
                              ])), // Legend centered vertically
                    ],
                  )
                : chart,
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Map<String, int> data, List<Color> colors,
      {String chartType = ''}) {
    // Filter out zero values
    final filteredEntries =
        data.entries.where((entry) => entry.value > 0).toList();
    final total = filteredEntries.fold(0, (sum, entry) => sum + entry.value);

    // Helper function to build a legend item
    Widget buildLegendItem(int index, MapEntry<String, int> dataEntry) {
      final percentage = total > 0
          ? ((dataEntry.value / total) * 100).toStringAsFixed(1)
          : '0.0';

      final isHovered =
          _touchedIndex == index && _currentTouchedChart == chartType;

      return GestureDetector(
        onTap: () => _navigateToFilteredList(dataEntry.key, chartType),
        child: Padding(
          padding: filteredEntries.length >= 6
              ? const EdgeInsets.symmetric(vertical: 6, horizontal: 12)
              : const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: filteredEntries.length >= 6
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: [
              Container(
                width: isHovered ? 14 : 12,
                height: isHovered ? 14 : 12,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: filteredEntries.length >= 6
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dataEntry.key,
                            style: GoogleFonts.inter(
                              fontSize: isHovered ? 14 : 13,
                              fontWeight:
                                  isHovered ? FontWeight.w600 : FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${dataEntry.value} (${percentage}%)',
                            style: GoogleFonts.inter(
                              fontSize: isHovered ? 13 : 12,
                              color: Colors.black54,
                              fontWeight: isHovered
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dataEntry.key,
                            style: GoogleFonts.inter(
                              fontSize: isHovered ? 14 : 13,
                              fontWeight:
                                  isHovered ? FontWeight.w600 : FontWeight.w500,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${dataEntry.value} (${percentage}%)',
                            style: GoogleFonts.inter(
                              fontSize: isHovered ? 13 : 12,
                              color: Colors.black54,
                              fontWeight: isHovered
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: filteredEntries.length < 6
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: filteredEntries
                  .asMap()
                  .entries
                  .map((entry) => buildLegendItem(entry.key, entry.value))
                  .toList(),
            )
          : filteredEntries.length < 12
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredEntries
                            .take((filteredEntries.length / 2).ceil())
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) =>
                                buildLegendItem(entry.key, entry.value))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Second column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredEntries
                            .skip((filteredEntries.length / 2).ceil())
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) => buildLegendItem(
                                entry.key + (filteredEntries.length / 2).ceil(),
                                entry.value))
                            .toList(),
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredEntries
                            .take((filteredEntries.length / 3).ceil())
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) =>
                                buildLegendItem(entry.key, entry.value))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Second column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredEntries
                            .skip((filteredEntries.length / 3).ceil())
                            .take((filteredEntries.length / 3).ceil())
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) => buildLegendItem(
                                entry.key + (filteredEntries.length / 3).ceil(),
                                entry.value))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Third column
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: filteredEntries
                            .skip((filteredEntries.length / 3).ceil() * 2)
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) => buildLegendItem(
                                entry.key +
                                    (filteredEntries.length / 3).ceil() * 2,
                                entry.value))
                            .toList(),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildGenderChart() {
    if (_genderData.isEmpty)
      return _buildChartCard(
          'Distribución por Género', const Center(child: Text('No hay datos')));

    final colors = [Colors.blue, Colors.pink];
    final sections = _genderData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isM = data.key == 'M';
      final total = _genderData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: isM ? Colors.blue : Colors.pink,
        radius: _touchedIndex == index && _currentTouchedChart == 'gender'
            ? 140 // Increased from 95 to 140
            : 150, // Increased from 85 to 130
        titleStyle: GoogleFonts.inter(
          fontSize: _touchedIndex == index && _currentTouchedChart == 'gender'
              ? 18
              : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(_genderData, colors, chartType: 'gender');

    return _buildChartCard(
      'Distribución por Género',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10, // Reduced from 40 to 20 for bigger charts
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'gender';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildTestCompletionChart() {
    if (_testCompletionData.isEmpty)
      return _buildChartCard(
          'Estado de Tests', const Center(child: Text('No hay datos')));

    final completed = _testCompletionData['completed'] ?? 0;
    final pending = _testCompletionData['pending'] ?? 0;
    final total = completed + pending;

    final data = {
      'Completados': completed.toInt(),
      'Pendientes': pending.toInt(),
    };

    final colors = [Colors.green, Colors.red];
    final sections = data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final dataEntry = entry.value;
      final percentage = total > 0
          ? ((dataEntry.value / total) * 100).toStringAsFixed(1)
          : '0.0';

      return PieChartSectionData(
        value: dataEntry.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'testCompletion'
                ? 140
                : 150, // Increased from 90/80 to 140/130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'testCompletion'
                  ? 18
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(data, colors, chartType: 'testCompletion');

    return _buildChartCard(
      'Estado de Tests',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10, // Reduced from 40 to 20 for bigger charts
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'testCompletion';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  // NEW CHART METHODS FOR FATHER/MOTHER DATA

  Widget _buildFatherJobChart() {
    if (_fatherJobData.isEmpty)
      return _buildChartCard(
          'Profesión del Padre', const Center(child: Text('No hay datos')));

    final colors = [
      Colors.blue,
      Colors.indigo,
      Colors.cyan,
      Colors.lightBlue,
      Colors.teal
    ];
    final sections =
        _fatherJobData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = _fatherJobData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'fatherJob'
            ? 140 // Increased from 95 to 140
            : 150, // Increased from 85 to 130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'fatherJob'
                  ? 18
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(_fatherJobData, colors, chartType: 'fatherJob');

    return _buildChartCard(
      'Profesión del Padre',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'fatherJob';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildMotherJobChart() {
    if (_motherJobData.isEmpty)
      return _buildChartCard(
          'Profesión de la Madre', const Center(child: Text('No hay datos')));

    final colors = [
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.pinkAccent,
      Colors.redAccent
    ];
    final sections =
        _motherJobData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = _motherJobData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'motherJob'
            ? 140 // Increased from 80 to 140
            : 150, // Increased from 70 to 130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'motherJob'
                  ? 18 // Increased from 12 to 16
                  : 16, // Increased from 10 to 14
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed from white to black
        ),
      );
    }).toList();

    final legend = _buildLegend(_motherJobData, colors, chartType: 'motherJob');

    return _buildChartCard(
      'Profesión de la Madre',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'motherJob';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildFatherStudiesChart() {
    if (_fatherStudiesData.isEmpty)
      return _buildChartCard(
          'Estudios del Padre', const Center(child: Text('No hay datos')));

    final colors = [
      Colors.green,
      Colors.lightGreen,
      Colors.teal,
      Colors.greenAccent,
      Colors.lime
    ];
    final sections =
        _fatherStudiesData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _fatherStudiesData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'fatherStudies'
                ? 140 // Increased from 80 to 140
                : 150, // Increased from 70 to 130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'fatherStudies'
                  ? 18 // Increased from 12 to 16
                  : 16, // Increased from 10 to 14
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed from white to black
        ),
      );
    }).toList();

    final legend =
        _buildLegend(_fatherStudiesData, colors, chartType: 'fatherStudies');

    return _buildChartCard(
      'Estudios del Padre',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'fatherStudies';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildMotherStudiesChart() {
    if (_motherStudiesData.isEmpty)
      return _buildChartCard(
          'Estudios de la Madre', const Center(child: Text('No hay datos')));

    final colors = [
      Colors.orange,
      Colors.deepOrange,
      Colors.amber,
      Colors.orangeAccent,
      Colors.yellow
    ];
    final sections =
        _motherStudiesData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _motherStudiesData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'motherStudies'
                ? 140 // Increased from 80 to 140
                : 150, // Increased from 70 to 130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'motherStudies'
                  ? 18 // Increased from 12 to 16
                  : 16, // Increased from 10 to 14
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed from white to black
        ),
      );
    }).toList();

    final legend =
        _buildLegend(_motherStudiesData, colors, chartType: 'motherStudies');

    return _buildChartCard(
      'Estudios de la Madre',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'motherStudies';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildAdoptionChart() {
    if (_adoptionData.isEmpty)
      return _buildChartCard(
          'Estado de Adopción', const Center(child: Text('No hay datos')));

    final colors = [Colors.red, Colors.green];
    final sections =
        _adoptionData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = _adoptionData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'adoption'
            ? 140 // Increased from 80 to 140
            : 150, // Increased from 70 to 130
        titleStyle: GoogleFonts.inter(
          fontSize: _touchedIndex == index && _currentTouchedChart == 'adoption'
              ? 18 // Increased from 12 to 16
              : 16, // Increased from 10 to 14
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black
        ),
      );
    }).toList();

    final legend = _buildLegend(_adoptionData, colors, chartType: 'adoption');

    return _buildChartCard(
      'Estado de Adopción',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'adoption';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  // ORIGINAL CHART METHODS

  Widget _buildGeographicalChart() {
    if (_geographicalData.isEmpty) {
      return Container(
        height: 300,
        child: _buildChartCard('Distribución Geográfica',
            const Center(child: Text('No hay datos'))),
      );
    }

    final barGroups =
        _geographicalData.entries.toList().asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value.toDouble(),
            color: Colors.indigo,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 300,
      child: _buildChartCard(
        'Distribución Geográfica (por CP)',
        BarChart(
          BarChartData(
            barGroups: barGroups,
            barTouchData: BarTouchData(
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                // Only navigate on tap/click events, not on hover/move
                if (event is FlTapUpEvent &&
                    barTouchResponse != null &&
                    barTouchResponse.spot != null) {
                  final touchedGroupIndex =
                      barTouchResponse.spot!.touchedBarGroupIndex;

                  if (touchedGroupIndex >= 0 &&
                      touchedGroupIndex < _geographicalData.length) {
                    final entries = _geographicalData.entries.toList();
                    final postalCode = entries[touchedGroupIndex].key;

                    _navigateToFilteredList(postalCode, 'geographical');
                  }
                }
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50, // Added reserved space for Y-axis numbers
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final entries = _geographicalData.entries.toList();
                    if (value.toInt() < entries.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          entries[value.toInt()].key,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBirthTypeChart() {
    if (_birthTypeData.isEmpty)
      return _buildChartCard(
          'Tipo de Parto', const Center(child: Text('No hay datos')));

    final colors = [Colors.pink, Colors.blue, Colors.green, Colors.orange];
    final sections =
        _birthTypeData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = _birthTypeData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'birthType'
            ? 140
            : 150, // Increased from 80/70 to 140/130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'birthType'
                  ? 18
                  : 16, // Increased font size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black
        ),
      );
    }).toList();

    final legend = _buildLegend(_birthTypeData, colors, chartType: 'birthType');

    return _buildChartCard(
      'Tipo de Parto',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10, // Reduced from 30 to 15 for bigger charts
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'birthType';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildGestationWeeksChart() {
    if (_gestationWeeksData.isEmpty)
      return _buildChartCard(
          'Semanas de Gestación', const Center(child: Text('No hay datos')));

    final colors = [Colors.red, Colors.orange, Colors.green, Colors.blue];
    final sections =
        _gestationWeeksData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _gestationWeeksData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'gestationWeeks'
                ? 140
                : 150, // Increased from 80/70 to 140/130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'gestationWeeks'
                  ? 18
                  : 16, // Increased font size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black
        ),
      );
    }).toList();

    final legend =
        _buildLegend(_gestationWeeksData, colors, chartType: 'gestationWeeks');

    return _buildChartCard(
      'Semanas de Gestación',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10, // Reduced from 30 to 15 for bigger charts
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'gestationWeeks';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildBirthWeightChart() {
    if (_birthWeightData.isEmpty)
      return _buildChartCard(
          'Peso al Nacer', const Center(child: Text('No hay datos')));

    final colors = [Colors.red, Colors.orange, Colors.green, Colors.blue];
    final sections =
        _birthWeightData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _birthWeightData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'birthWeight'
            ? 140 // Increased from 80 to 140
            : 150, // Increased from 70 to 130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'birthWeight'
                  ? 18 // Increased from 11 to 16
                  : 16, // Increased from 9 to 14
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend =
        _buildLegend(_birthWeightData, colors, chartType: 'birthWeight');

    return _buildChartCard(
      'Peso al Nacer',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'birthWeight';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildApgarScoreChart() {
    if (_apgarScoreData.isEmpty)
      return _buildChartCard(
          'Puntuación APGAR', const Center(child: Text('No hay datos')));

    // Filter out zero values
    final filteredData = Map<String, int>.fromEntries(
        _apgarScoreData.entries.where((entry) => entry.value > 0));

    if (filteredData.isEmpty)
      return _buildChartCard(
          'Puntuación APGAR', const Center(child: Text('No hay datos')));

    final colors = [Colors.red, Colors.orange, Colors.green];
    final sections = filteredData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = filteredData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'apgar'
            ? 140
            : 150,
        titleStyle: GoogleFonts.inter(
          fontSize: _touchedIndex == index && _currentTouchedChart == 'apgar'
              ? 12
              : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(filteredData, colors, chartType: 'apgar');

    return _buildChartCard(
      'Puntuación APGAR',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'apgar';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildParentsCivilStatusChart() {
    if (_parentsCivilStatusData.isEmpty)
      return _buildChartCard('Estado Civil de los Padres',
          const Center(child: Text('No hay datos')));

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final sections =
        _parentsCivilStatusData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _parentsCivilStatusData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index &&
                _currentTouchedChart == 'parentsCivilStatus'
            ? 140
            : 150, // Increased from 80/70 to 140/130
        titleStyle: GoogleFonts.inter(
          fontSize: _touchedIndex == index &&
                  _currentTouchedChart == 'parentsCivilStatus'
              ? 18
              : 16, // Increased font size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black
        ),
      );
    }).toList();

    final legend = _buildLegend(_parentsCivilStatusData, colors,
        chartType: 'parentsCivilStatus');

    return _buildChartCard(
      'Estado Civil de los Padres',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  return;
                }
                _currentTouchedChart = 'parentsCivilStatus';
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildSiblingsChart() {
    if (_siblingsData.isEmpty)
      return _buildChartCard(
          'Número de Hermanos', const Center(child: Text('No hay datos')));

    final colors = [Colors.teal, Colors.cyan, Colors.indigo, Colors.purple];
    final sections =
        _siblingsData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = _siblingsData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'siblings'
            ? 140
            : 150,
        titleStyle: GoogleFonts.inter(
          fontSize: _touchedIndex == index && _currentTouchedChart == 'siblings'
              ? 12
              : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(_siblingsData, colors, chartType: 'siblings');

    return _buildChartCard(
      'Número de Hermanos',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'siblings';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildFamilyMembersChart() {
    if (_familyMembersData.isEmpty)
      return _buildChartCard(
          'Miembros de la Familia', const Center(child: Text('No hay datos')));

    // Filter out zero values
    final filteredData = Map<String, int>.fromEntries(
        _familyMembersData.entries.where((entry) => entry.value > 0));

    if (filteredData.isEmpty)
      return _buildChartCard(
          'Miembros de la Familia', const Center(child: Text('No hay datos')));

    final colors = [Colors.deepOrange, Colors.amber, Colors.lime, Colors.teal];
    final sections = filteredData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = filteredData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'familyMembers'
                ? 140
                : 150,
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'familyMembers'
                  ? 12
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend =
        _buildLegend(filteredData, colors, chartType: 'familyMembers');

    return _buildChartCard(
      'Miembros de la Familia',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'familyMembers';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildSocioeconomicChart() {
    if (_socioeconomicData.isEmpty)
      return _buildChartCard('Situación Socioeconómica',
          const Center(child: Text('No hay datos')));

    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue
    ];
    final sections =
        _socioeconomicData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total =
          _socioeconomicData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius:
            _touchedIndex == index && _currentTouchedChart == 'socioeconomic'
                ? 140
                : 150, // Increased from 80/70 to 140/130
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'socioeconomic'
                  ? 18
                  : 16, // Increased font size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black
        ),
      );
    }).toList();

    final legend =
        _buildLegend(_socioeconomicData, colors, chartType: 'socioeconomic');

    return _buildChartCard(
      'Situación Socioeconómica',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  return;
                }
                _currentTouchedChart = 'socioeconomic';
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildSchoolingLevelChart() {
    if (_schoolingLevelData.isEmpty)
      return _buildChartCard(
          'Nivel de Escolarización', const Center(child: Text('No hay datos')));

    // Filter out zero values
    final filteredData = Map<String, int>.fromEntries(
        _schoolingLevelData.entries.where((entry) => entry.value > 0));

    if (filteredData.isEmpty)
      return _buildChartCard(
          'Nivel de Escolarización', const Center(child: Text('No hay datos')));

    final colors = [Colors.indigo, Colors.blue, Colors.cyan, Colors.teal];
    final sections = filteredData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = filteredData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'schooling'
            ? 140
            : 150,
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'schooling'
                  ? 12
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(filteredData, colors, chartType: 'schooling');

    return _buildChartCard(
      'Nivel de Escolarización',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'schooling';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildEvaluationReasonChart() {
    if (_evaluationReasonData.isEmpty)
      return _buildChartCard(
          'Motivo de Evaluación', const Center(child: Text('No hay datos')));

    // Filter out zero values
    final filteredData = Map<String, int>.fromEntries(
        _evaluationReasonData.entries.where((entry) => entry.value > 0));

    if (filteredData.isEmpty)
      return _buildChartCard(
          'Motivo de Evaluación', const Center(child: Text('No hay datos')));

    final colors = [
      Colors.deepPurple,
      Colors.purple,
      Colors.pink,
      Colors.red,
      Colors.orange
    ];
    final sections = filteredData.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final total = filteredData.values.fold(0, (sum, count) => sum + count);
      final percentage = ((data.value / total) * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: data.value.toDouble(),
        title: '$percentage%',
        color: colors[index % colors.length],
        radius: _touchedIndex == index && _currentTouchedChart == 'evaluation'
            ? 140
            : 150,
        titleStyle: GoogleFonts.inter(
          fontSize:
              _touchedIndex == index && _currentTouchedChart == 'evaluation'
                  ? 18
                  : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    }).toList();

    final legend = _buildLegend(filteredData, colors, chartType: 'evaluation');

    return _buildChartCard(
      'Motivo de Evaluación',
      PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 10,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  _currentTouchedChart = '';
                  return;
                }
                _touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                _currentTouchedChart = 'evaluation';
              });
            },
          ),
        ),
      ),
      legend: legend,
    );
  }

  Widget _buildParentsAgeChart() {
    if (_parentsAgeData.isEmpty) {
      return Container(
        height: 300,
        child: _buildChartCard('Distribución de Edades de los Padres',
            const Center(child: Text('No hay datos'))),
      );
    }

    // Group ages by parent type and create age ranges
    final Map<String, Map<String, int>> parentAges = {};

    for (var data in _parentsAgeData) {
      final parent = data['parent'] as String;
      final age = data['age'] as int;

      if (!parentAges.containsKey(parent)) {
        parentAges[parent] = {};
      }

      String ageRange;
      if (age < 25) {
        ageRange = '<25';
      } else if (age < 35) {
        ageRange = '25-34';
      } else if (age < 45) {
        ageRange = '35-44';
      } else {
        ageRange = '45+';
      }

      parentAges[parent]![ageRange] = (parentAges[parent]![ageRange] ?? 0) + 1;
    }

    // Create bar chart data
    final ageRanges = ['<25', '25-34', '35-44', '45+'];
    final barGroups = ageRanges.asMap().entries.map((entry) {
      final ageRange = entry.value;
      final index = entry.key;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (parentAges['Padre']?[ageRange] ?? 0).toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: (parentAges['Madre']?[ageRange] ?? 0).toDouble(),
            color: Colors.pink,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 300,
      child: _buildChartCard(
        'Distribución de Edades de los Padres',
        BarChart(
          BarChartData(
            barGroups: barGroups,
            barTouchData: BarTouchData(
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                // Only navigate on tap/click events, not on hover/move
                if (event is FlTapUpEvent &&
                    barTouchResponse != null &&
                    barTouchResponse.spot != null) {
                  final touchedGroupIndex =
                      barTouchResponse.spot!.touchedBarGroupIndex;
                  final touchedBarIndex =
                      barTouchResponse.spot!.touchedRodDataIndex;

                  if (touchedGroupIndex >= 0 &&
                      touchedGroupIndex < ageRanges.length) {
                    final ageRange = ageRanges[touchedGroupIndex];
                    final parentType = touchedBarIndex == 0 ? 'Padre' : 'Madre';

                    // Create a filter value that includes both age range and parent type
                    final filterValue = '$parentType:$ageRange';

                    _navigateToFilteredList(filterValue, 'parentAge');
                  }
                }
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50, // Added reserved space for Y-axis numbers
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < ageRanges.length) {
                      return Text(
                        ageRanges[value.toInt()],
                        style: GoogleFonts.inter(fontSize: 14),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
          ),
        ),
      ),
    );
  }
}
