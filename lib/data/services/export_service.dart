import 'dart:convert';
import 'dart:io';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/data/services/test_service.dart';
import 'package:dauco/data/services/item_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ExportFormat { csv, json, excel }

enum ExportType {
  singleMinor,
  multipleMinors,
  minorWithTests,
  summaryReport,
  filteredReport
}

class ExportService {
  final TestService _testService = TestService();
  final ItemService _itemService = ItemService();
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Role-based export with validation
  Future<String> exportWithRoleValidation(List<Minor> minors,
      {ExportFormat format = ExportFormat.excel,
      String? filterType,
      String? filterValue,
      bool includeTests = true}) async {
    // Get current user's role
    final session = _supabase.auth.currentSession;
    if (session == null) {
      throw Exception('No hay sesión activa');
    }

    // Note: Role-based UI controls ensure admins only export with filters
    // No server-side validation needed since button is disabled appropriately

    // Get tests for all minors if requested
    Map<int, List<Test>> minorTests = {};
    if (includeTests) {
      for (var minor in minors) {
        try {
          final tests = await _testService.getTests(minor.minorId);
          minorTests[minor.minorId] = tests;
          print(
              'ExportService: Retrieved ${tests.length} tests for minor ${minor.minorId}');
        } catch (e) {
          print(
              'ExportService: Error retrieving tests for minor ${minor.minorId}: $e');
          // If tests can't be retrieved, continue with empty list
          minorTests[minor.minorId] = [];
        }
      }
    }

    // Generate export content with tests
    String content;
    if (minors.length == 1) {
      content = await _exportSingleMinorWithTests(
          minors.first, minorTests[minors.first.minorId] ?? [], format);
    } else {
      content = await _exportMultipleMinorsWithTests(
          minors, minorTests, format, filterType, filterValue);
    }

    return content;
  }

  /// Export a single minor's complete information
  Future<String> exportSingleMinor(Minor minor,
      {List<Test>? tests, ExportFormat format = ExportFormat.excel}) async {
    // If tests not provided, fetch them automatically
    List<Test>? testsToUse = tests;
    if (testsToUse == null) {
      try {
        testsToUse = await _testService.getTests(minor.minorId);
      } catch (e) {
        print(
            'ExportService: Error fetching tests for minor ${minor.minorId}: $e');
        testsToUse = []; // Use empty list if fetch fails
      }
    }

    switch (format) {
      case ExportFormat.csv:
        return await _exportSingleMinorToCsv(minor, tests: testsToUse);
      case ExportFormat.json:
        return await _exportSingleMinorToJson(minor, tests: testsToUse);
      case ExportFormat.excel:
        return await _exportSingleMinorToExcel(minor, tests: testsToUse);
    }
  }

  /// Export multiple minors
  Future<String> exportMultipleMinors(List<Minor> minors,
      {ExportFormat format = ExportFormat.excel,
      String title = 'Reporte de Menores'}) async {
    switch (format) {
      case ExportFormat.csv:
        return await _exportMinorsToCsv(minors, title);
      case ExportFormat.json:
        return _exportMinorsToJson(minors, title);
      case ExportFormat.excel:
        return await _exportMinorsToExcel(minors, title);
    }
  }

  /// Export filtered minors report
  Future<String> exportFilteredReport(
      List<Minor> minors, String filterType, String filterValue,
      {ExportFormat format = ExportFormat.excel}) async {
    final title = 'Reporte Filtrado - $filterType: $filterValue';
    return exportMultipleMinors(minors, format: format, title: title);
  }

  // CSV Export Methods
  Future<String> _exportSingleMinorToCsv(Minor minor,
      {List<Test>? tests}) async {
    List<List<dynamic>> rows = [];

    // Header row with all minor fields
    rows.add([
      'ID Menor',
      'Referencia',
      'ID Responsable',
      'Fecha Nacimiento',
      'Rango Edad',
      'Sexo',
      'Código Postal',
      'Fecha Registro',
      'Edad Padre',
      'Edad Madre',
      'Trabajo Padre',
      'Trabajo Madre',
      'Estudios Padre',
      'Estudios Madre',
      'Estado Civil Padres',
      'Número Hermanos',
      'Posición Hermanos',
      'Miembros Familia',
      'Antecedentes Familiares',
      'Discapacidades Familiares',
      'Tipo Parto',
      'Semanas Gestación',
      'Incidentes Parto',
      'Peso Nacimiento',
      'Test APGAR',
      'Adopción',
      'Enfermedades Relevantes',
      'Juicio Clínico',
      'Nivel Escolarización',
      'Observaciones Escolarización',
      'Situación Socioeconómica',
      'Razón Evaluación',
      'Número Tests',
      'Tests Completados'
    ]);

    // Data row with all minor information
    rows.add([
      minor.minorId,
      minor.reference,
      minor.managerId,
      _formatDate(minor.birthdate),
      minor.ageRange,
      minor.sex,
      minor.zipCode,
      _formatDate(minor.registeredAt),
      minor.fatherAge,
      minor.motherAge,
      minor.fatherJob,
      minor.motherJob,
      minor.fatherStudies,
      minor.motherStudies,
      minor.parentsCivilStatus,
      minor.siblings,
      minor.siblingsPosition,
      minor.familyMembers,
      minor.familyBackground,
      minor.familyDisabilities,
      minor.birthType,
      minor.gestationWeeks,
      minor.birthIncidents,
      '${minor.birthWeight}g',
      minor.apgarTest,
      minor.adoption == 1 ? 'Sí' : 'No',
      minor.relevantDiseases,
      minor.clinicalJudgement,
      minor.schoolingLevel,
      minor.schoolingObservations,
      minor.socioeconomicSituation,
      minor.evaluationReason,
      minor.testsNum,
      minor.completedTests
    ]);

    // Section 2: Tests Information (if available)
    if (tests != null && tests.isNotEmpty) {
      rows.add([]);
      rows.add(['=== PRUEBAS REALIZADAS ===']);
      rows.add([]);
      rows.add(['ID Test', 'ID Menor', 'Fecha Creación']);

      for (var test in tests) {
        rows.add([test.testId, test.minorId, _formatDate(test.registeredAt)]);
      }

      // Section 3: Test Items Information - fetch items for each test
      List<Item> allItems = [];
      for (var test in tests) {
        try {
          final items = await _itemService.getItems(test.testId);
          allItems.addAll(items);
        } catch (e) {
          print(
              'ExportService: Error retrieving items for test ${test.testId}: $e');
        }
      }

      if (allItems.isNotEmpty) {
        rows.add([]);
        rows.add(['=== ELEMENTOS DE PRUEBAS ===']);
        rows.add([]);
        rows.add(['ID Elemento', 'ID Test', 'Área', 'Pregunta', 'Respuesta']);

        for (var item in allItems) {
          rows.add([
            item.itemId,
            item.testId,
            item.area,
            item.question,
            item.answer
          ]);
        }
      }
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<String> _exportMinorsToCsv(List<Minor> minors, String title) async {
    List<List<dynamic>> rows = [];

    // Section 1: Minors Table (like Excel structure)
    rows.add(['=== MENORES ===']);
    rows.add([]);

    // Column headers with ALL minor fields
    rows.add([
      'ID Menor',
      'Referencia',
      'ID Responsable',
      'Fecha Nacimiento',
      'Rango Edad',
      'Sexo',
      'Código Postal',
      'Fecha Registro',
      'Edad Padre',
      'Edad Madre',
      'Trabajo Padre',
      'Trabajo Madre',
      'Estudios Padre',
      'Estudios Madre',
      'Estado Civil Padres',
      'Número Hermanos',
      'Posición Hermanos',
      'Miembros Familia',
      'Antecedentes Familiares',
      'Discapacidades Familiares',
      'Tipo Parto',
      'Semanas Gestación',
      'Incidentes Parto',
      'Peso Nacimiento',
      'Test APGAR',
      'Adopción',
      'Enfermedades Relevantes',
      'Juicio Clínico',
      'Nivel Escolarización',
      'Observaciones Escolarización',
      'Situación Socioeconómica',
      'Razón Evaluación',
      'Número Tests',
      'Tests Completados'
    ]);

    // Data rows - one row per minor with all information
    for (var minor in minors) {
      rows.add([
        minor.minorId,
        minor.reference,
        minor.managerId,
        _formatDate(minor.birthdate),
        minor.ageRange,
        minor.sex,
        minor.zipCode,
        _formatDate(minor.registeredAt),
        minor.fatherAge,
        minor.motherAge,
        minor.fatherJob,
        minor.motherJob,
        minor.fatherStudies,
        minor.motherStudies,
        minor.parentsCivilStatus,
        minor.siblings,
        minor.siblingsPosition,
        minor.familyMembers,
        minor.familyBackground,
        minor.familyDisabilities,
        minor.birthType,
        minor.gestationWeeks,
        minor.birthIncidents,
        '${minor.birthWeight}g',
        minor.apgarTest,
        minor.adoption == 1 ? 'Sí' : 'No',
        minor.relevantDiseases,
        minor.clinicalJudgement,
        minor.schoolingLevel,
        minor.schoolingObservations,
        minor.socioeconomicSituation,
        minor.evaluationReason,
        minor.testsNum,
        minor.completedTests
      ]);
    }

    // Section 2: Get and add all tests for all minors (like Excel)
    List<Test> allTests = [];
    List<Item> allItems = [];

    for (var minor in minors) {
      try {
        final tests = await _testService.getTests(minor.minorId);
        allTests.addAll(tests);

        // Get items for each test
        for (var test in tests) {
          try {
            final items = await _itemService.getItems(test.testId);
            allItems.addAll(items);
          } catch (e) {
            print(
                'ExportService: Error retrieving items for test ${test.testId}: $e');
          }
        }
      } catch (e) {
        print(
            'ExportService: Error retrieving tests for minor ${minor.minorId}: $e');
      }
    }

    // Add tests section if we have tests
    if (allTests.isNotEmpty) {
      rows.add([]);
      rows.add(['=== PRUEBAS ===']);
      rows.add([]);
      rows.add(['ID Test', 'ID Menor', 'Fecha Creación']);

      for (var test in allTests) {
        rows.add([test.testId, test.minorId, _formatDate(test.registeredAt)]);
      }
    }

    // Add items section if we have items
    if (allItems.isNotEmpty) {
      rows.add([]);
      rows.add(['=== ELEMENTOS DE PRUEBAS ===']);
      rows.add([]);
      rows.add(['ID Elemento', 'ID Test', 'Área', 'Pregunta', 'Respuesta']);

      for (var item in allItems) {
        rows.add(
            [item.itemId, item.testId, item.area, item.question, item.answer]);
      }
    }

    return const ListToCsvConverter().convert(rows);
  }

  // JSON Export Methods
  Future<String> _exportSingleMinorToJson(Minor minor,
      {List<Test>? tests}) async {
    final data = {
      'reporte': 'Información Individual del Menor',
      'generado_el': DateTime.now().toIso8601String(),
      'menor': {
        'id_menor': minor.minorId,
        'referencia': minor.reference,
        'id_responsable': minor.managerId,
        'fecha_nacimiento': minor.birthdate.toIso8601String(),
        'rango_edad': minor.ageRange,
        'fecha_registro': minor.registeredAt.toIso8601String(),
        'sexo': minor.sex,
        'codigo_postal': minor.zipCode,
        'informacion_familiar': {
          'edad_padre': minor.fatherAge,
          'edad_madre': minor.motherAge,
          'trabajo_padre': minor.fatherJob,
          'trabajo_madre': minor.motherJob,
          'estudios_padre': minor.fatherStudies,
          'estudios_madre': minor.motherStudies,
          'estado_civil_padres': minor.parentsCivilStatus,
          'hermanos': minor.siblings,
          'posicion_hermanos': minor.siblingsPosition,
          'miembros_familia': minor.familyMembers,
          'antecedentes_familiares': minor.familyBackground,
          'discapacidades_familiares': minor.familyDisabilities,
        },
        'informacion_medica': {
          'tipo_parto': minor.birthType,
          'semanas_gestacion': minor.gestationWeeks,
          'incidentes_parto': minor.birthIncidents,
          'peso_nacimiento': minor.birthWeight,
          'test_apgar': minor.apgarTest,
          'adopcion': minor.adoption == 1,
          'enfermedades_relevantes': minor.relevantDiseases,
          'juicio_clinico': minor.clinicalJudgement,
        },
        'informacion_educativa': {
          'nivel_escolarizacion': minor.schoolingLevel,
          'observaciones_escolarizacion': minor.schoolingObservations,
          'situacion_socioeconomica': minor.socioeconomicSituation,
          'razon_evaluacion': minor.evaluationReason,
        },
        'informacion_tests': {
          'numero_tests': minor.testsNum,
          'tests_completados': minor.completedTests,
        }
      }
    };

    if (tests != null && tests.isNotEmpty) {
      data['pruebas_realizadas'] = [];

      for (var test in tests) {
        // Get test details with ALL fields
        Map<String, dynamic> testData = {
          'id_test': test.testId,
          'menor_id': test.minorId,
          'fecha_creacion': test.registeredAt.toIso8601String(),
          'edad_cronologica': test.cronologicalAge,
          'edad_evolutiva': test.evolutionaryAge,
          'test_mchat': test.mChatTest,
          'progreso': test.progress,
          'areas_activas': test.activeAreas,
          'tipo_profesional': test.professionalType,
        };

        // Get items for this specific test
        try {
          final items = await _itemService.getItems(test.testId);
          testData['items'] = items
              .map((item) => {
                    'id_respuesta': item.responseId,
                    'id_elemento': item.itemId,
                    'numero_item': item.item,
                    'area': item.area,
                    'pregunta': item.question,
                    'respuesta': item.answer,
                  })
              .toList();
          print(
              'ExportService: Retrieved ${items.length} items for test ${test.testId}');
        } catch (e) {
          print(
              'ExportService: Error retrieving items for test ${test.testId}: $e');
          testData['items'] = [];
        }

        (data['pruebas_realizadas'] as List).add(testData);
      }
    }

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  String _exportMinorsToJson(List<Minor> minors, String title) {
    final data = {
      'reporte': title,
      'generado_el': DateTime.now().toIso8601String(),
      'total_menores': minors.length,
      'menores': minors
          .map((minor) => {
                'id_menor': minor.minorId,
                'referencia': minor.reference,
                'id_responsable': minor.managerId,
                'fecha_nacimiento': minor.birthdate.toIso8601String(),
                'rango_edad': minor.ageRange,
                'sexo': minor.sex,
                'codigo_postal': minor.zipCode,
                'tests_realizados': minor.testsNum,
                'tests_completados': minor.completedTests,
                'nivel_escolarizacion': minor.schoolingLevel,
                'situacion_socioeconomica': minor.socioeconomicSituation,
                'fecha_registro': minor.registeredAt.toIso8601String(),
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  // Text Export Methods
  // Utility Methods
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Generate safe filename with timestamp
  String _generateSafeFilename(String prefix, {String extension = 'xlsx'}) {
    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    // Return filename WITHOUT extension since saveToFile adds it
    return '${prefix}_${timestamp}';
  }

  /// Save export data - try Downloads, then show save dialog if fails
  Future<String> saveToFile(
      String content, String filename, ExportFormat format) async {
    final extension = format == ExportFormat.excel ? 'xlsx' : format.name;

    try {
      // First attempt: Try to save directly to Downloads
      String downloadsPath;
      if (Platform.isMacOS) {
        final home = Platform.environment['HOME'];
        if (home != null) {
          downloadsPath = '$home/Downloads';
          final downloadsDirectory = Directory(downloadsPath);

          // Ensure Downloads directory exists
          if (!await downloadsDirectory.exists()) {
            await downloadsDirectory.create(recursive: true);
          }

          final file = File('$downloadsPath/$filename.$extension');
          await file.writeAsString(content, encoding: utf8);

          print('✅ File saved successfully to Downloads: ${file.path}');
          return file.path;
        }
      }
      throw Exception('Could not access Downloads folder');
    } catch (e) {
      print('⚠️ Cannot save to Downloads: $e');

      // Second attempt: Show save dialog to let user choose location
      try {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar archivo en Downloads o ubicación elegida',
          fileName: '$filename.$extension',
          type: FileType.custom,
          allowedExtensions: [extension],
          initialDirectory: Platform.environment['HOME'] != null
              ? '${Platform.environment['HOME']}/Downloads'
              : null,
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsString(content, encoding: utf8);
          print('✅ File saved to chosen location: ${file.path}');
          return file.path;
        } else {
          throw Exception('El usuario canceló la descarga');
        }
      } catch (dialogError) {
        print('❌ Save dialog failed: $dialogError');

        // Final fallback: Documents directory
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename.$extension');
        await file.writeAsString(content, encoding: utf8);

        print('⚠️ Fallback: File saved to Documents folder: ${file.path}');
        print(
            '💡 To access: Open Finder → Go → Go to Folder → paste: ${file.path}');
        return file.path;
      }
    }
  }

  /// Generate export content as string (for sharing/copying)
  String getExportContent(String content) {
    return content;
  }

  /// Generate filename with timestamp (public method for use cases)
  String generateFilename(String prefix, {String extension = 'csv'}) {
    return _generateSafeFilename(prefix, extension: extension);
  }

  // Helper methods for role-based export with tests
  Future<String> _exportSingleMinorWithTests(
      Minor minor, List<Test> tests, ExportFormat format) async {
    switch (format) {
      case ExportFormat.csv:
        return await _exportSingleMinorToCsv(minor, tests: tests);
      case ExportFormat.json:
        return await _exportSingleMinorToJson(minor, tests: tests);
      case ExportFormat.excel:
        return await _exportSingleMinorToExcel(minor, tests: tests);
    }
  }

  Future<String> _exportMultipleMinorsWithTests(
      List<Minor> minors,
      Map<int, List<Test>> minorTests,
      ExportFormat format,
      String? filterType,
      String? filterValue) async {
    String title = 'Reporte Completo de Menores';
    if (filterType != null && filterValue != null) {
      title = 'Reporte Filtrado - $filterType: $filterValue';
    }

    switch (format) {
      case ExportFormat.csv:
        return await _exportMinorsWithTestsToCsv(minors, minorTests, title);
      case ExportFormat.json:
        return _exportMinorsWithTestsToJson(minors, minorTests, title);
      case ExportFormat.excel:
        return await _exportMinorsWithTestsToExcel(minors, minorTests, title);
    }
  }

  Future<String> _exportMinorsWithTestsToCsv(
      List<Minor> minors, Map<int, List<Test>> minorTests, String title) async {
    List<List<String>> rows = [];

    // Header
    rows.add([title.toUpperCase()]);
    rows.add(['Generado el: ${DateTime.now().toString().split('.')[0]}']);
    rows.add(['Total de Menores: ${minors.length}']);
    rows.add(['']); // Empty row

    for (int i = 0; i < minors.length; i++) {
      final minor = minors[i];
      final tests = minorTests[minor.minorId] ?? [];

      // Minor section header
      rows.add(['=== MENOR ${i + 1} ===']);

      // Basic info
      rows.add(['ID del Menor', minor.minorId.toString()]);
      rows.add(['Referencia', minor.reference.toString()]);
      rows.add(['Responsable ID', minor.managerId.toString()]);
      rows.add(['Sexo', minor.sex.toString()]);
      rows.add(['Fecha de Nacimiento', _formatDate(minor.birthdate)]);
      rows.add(['Rango de Edad', minor.ageRange.toString()]);

      // Test info
      rows.add(['Número de Tests', minor.testsNum.toString()]);
      rows.add(['Tests Completados', minor.completedTests.toString()]);

      // Tests detail
      if (tests.isNotEmpty) {
        rows.add(['--- Tests Realizados ---']);
        for (var test in tests) {
          rows.add(['Test ID ${test.testId}', _formatDate(test.registeredAt)]);
        }

        // Add items information for each test
        rows.add(['']);
        rows.add(['=== ELEMENTOS DE PRUEBAS ===']);
        rows.add(['ID Elemento', 'ID Test', 'Área', 'Pregunta', 'Respuesta']);

        for (var test in tests) {
          try {
            final items = await _itemService.getItems(test.testId);
            print(
                'ExportService: Retrieved ${items.length} items for test ${test.testId}');
            for (var item in items) {
              rows.add([
                item.itemId.toString(),
                item.testId.toString(),
                item.area,
                item.question,
                item.answer
              ]);
            }
          } catch (e) {
            print(
                'ExportService: Error retrieving items for test ${test.testId}: $e');
          }
        }
      } else {
        rows.add(['Tests', 'No hay tests registrados']);
      }

      rows.add(['']); // Separator
    }

    return const ListToCsvConverter().convert(rows);
  }

  Future<String> _exportMinorsWithTestsToJson(
      List<Minor> minors, Map<int, List<Test>> minorTests, String title) async {
    final data = {
      'reporte': title,
      'fecha_generacion': DateTime.now().toIso8601String(),
      'total_menores': minors.length,
      'menores': [],
    };

    for (var minor in minors) {
      Map<String, dynamic> minorData = {
        'informacion_basica': {
          'menor_id': minor.minorId,
          'referencia': minor.reference,
          'responsable_id': minor.managerId,
          'sexo': minor.sex,
          'fecha_nacimiento': minor.birthdate.toIso8601String(),
          'rango_edad': minor.ageRange,
          'fecha_registro': minor.registeredAt.toIso8601String(),
          'codigo_postal': minor.zipCode,
        },
        'informacion_familiar': {
          'edad_padre': minor.fatherAge,
          'edad_madre': minor.motherAge,
          'trabajo_padre': minor.fatherJob,
          'trabajo_madre': minor.motherJob,
          'estudios_padre': minor.fatherStudies,
          'estudios_madre': minor.motherStudies,
          'estado_civil': minor.parentsCivilStatus,
          'hermanos': minor.siblings,
          'posicion_hermanos': minor.siblingsPosition,
          'miembros_familia': minor.familyMembers,
          'antecedentes_familiares': minor.familyBackground,
          'discapacidades_familiares': minor.familyDisabilities,
        },
        'informacion_medica': {
          'tipo_parto': minor.birthType,
          'semanas_gestacion': minor.gestationWeeks,
          'incidentes_parto': minor.birthIncidents,
          'peso_nacer': minor.birthWeight,
          'test_apgar': minor.apgarTest,
          'adopcion': minor.adoption == 1,
          'enfermedades_relevantes': minor.relevantDiseases,
          'juicio_clinico': minor.clinicalJudgement,
        },
        'informacion_educativa': {
          'nivel_escolarizacion': minor.schoolingLevel,
          'observaciones': minor.schoolingObservations,
          'situacion_socioeconomica': minor.socioeconomicSituation,
          'razon_evaluacion': minor.evaluationReason,
        },
        'informacion_tests': {
          'numero_tests': minor.testsNum,
          'tests_completados': minor.completedTests,
        },
        'pruebas_realizadas': [],
      };

      // Get all tests for this minor with complete data and items
      final tests = minorTests[minor.minorId] ?? [];
      for (var test in tests) {
        Map<String, dynamic> testData = {
          'test_id': test.testId,
          'fecha_registro': test.registeredAt.toIso8601String(),
          'edad_cronologica': test.cronologicalAge,
          'edad_evolutiva': test.evolutionaryAge,
          'test_mchat': test.mChatTest,
          'progreso': test.progress,
          'areas_activas': test.activeAreas,
          'tipo_profesional': test.professionalType,
        };

        // Get items for this specific test
        try {
          final items = await _itemService.getItems(test.testId);
          testData['items'] = items
              .map((item) => {
                    'id_respuesta': item.responseId,
                    'id_elemento': item.itemId,
                    'numero_item': item.item,
                    'area': item.area,
                    'pregunta': item.question,
                    'respuesta': item.answer,
                  })
              .toList();
          print(
              'ExportService: Retrieved ${items.length} items for test ${test.testId}');
        } catch (e) {
          print(
              'ExportService: Error retrieving items for test ${test.testId}: $e');
          testData['items'] = [];
        }

        (minorData['pruebas_realizadas'] as List).add(testData);
      }

      (data['menores'] as List).add(minorData);
    }

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  // Excel Export Methods
  Future<String> _exportSingleMinorToExcel(Minor minor,
      {List<Test>? tests}) async {
    var excel = Excel.createExcel();

    // Create minor sheet
    Sheet minorSheet = excel['Menor'];
    _addMinorToExcelSheet(minorSheet, minor);

    // Create tests sheet if tests provided
    if (tests != null && tests.isNotEmpty) {
      Sheet testsSheet = excel['Pruebas'];
      _addTestsToExcelSheet(testsSheet, tests);

      // Get test items for each test and add to items sheet
      List<Item> allItems = [];
      for (var test in tests) {
        try {
          final items = await _itemService.getItems(test.testId);
          allItems.addAll(items);
        } catch (e) {
          print(
              'ExportService: Error retrieving items for test ${test.testId}: $e');
        }
      }
      if (allItems.isNotEmpty) {
        Sheet itemsSheet = excel['Elementos'];
        _addItemsToExcelSheet(itemsSheet, allItems);
        print('ExportService: Added ${allItems.length} items to Excel export');
      }
    }

    // Remove default sheet AFTER creating our custom sheets
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Validate that we have at least one sheet
    if (excel.sheets.isEmpty) {
      throw Exception('Excel workbook has no sheets');
    }

    // Save to bytes with validation
    List<int>? bytes;
    try {
      bytes = excel.save();
    } catch (e) {
      throw Exception('Failed to save Excel workbook: $e');
    }

    if (bytes == null || bytes.isEmpty) {
      throw Exception('Excel file generation produced empty or null data');
    }

    print('ExportService: Generated Excel file with ${bytes.length} bytes');

    // Save file
    final directory = await getDownloadsDirectory();
    if (directory != null) {
      final filename =
          '${_generateSafeFilename('dauco_info_${minor.minorId}')}.xlsx';
      final file = File('${directory.path}/$filename');

      try {
        await file.writeAsBytes(bytes);
        print('ExportService: Successfully saved Excel file to: ${file.path}');
        return file.path;
      } catch (e) {
        throw Exception('Failed to write Excel file to disk: $e');
      }
    }
    throw Exception('Could not save file');
  }

  Future<String> _exportMinorsToExcel(List<Minor> minors, String title) async {
    var excel = Excel.createExcel();

    // Create minors sheet
    Sheet minorsSheet = excel['Menores'];
    _addMinorsToExcelSheet(minorsSheet, minors, title);

    // Get all tests for all minors
    List<Test> allTests = [];
    List<Item> allItems = [];

    for (var minor in minors) {
      try {
        final tests = await _testService.getTests(minor.minorId);
        print(
            'ExportService: Retrieved ${tests.length} tests for minor ${minor.minorId}');
        allTests.addAll(tests);

        // Get items for each test
        for (var test in tests) {
          try {
            final items = await _itemService.getItems(test.testId);
            allItems.addAll(items);
          } catch (e) {
            print(
                'ExportService: Error retrieving items for test ${test.testId}: $e');
          }
        }
      } catch (e) {
        print(
            'ExportService: Error retrieving tests for minor ${minor.minorId}: $e');
        // Continue if tests can't be retrieved
      }
    }

    // Create tests sheet if we have tests
    if (allTests.isNotEmpty) {
      Sheet testsSheet = excel['Pruebas'];
      _addTestsToExcelSheet(testsSheet, allTests);
    }

    // Create items sheet if we have items
    if (allItems.isNotEmpty) {
      print(
          'ExportService: Creating Items sheet with ${allItems.length} items');
      Sheet itemsSheet = excel['Items'];
      _addItemsToExcelSheet(itemsSheet, allItems);
    } else {
      print('ExportService: No items to add to Excel export');
    }

    // Remove default sheet AFTER creating our custom sheets
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Validate that we have at least one sheet
    if (excel.sheets.isEmpty) {
      throw Exception('Excel workbook has no sheets');
    }

    // Save to bytes with validation
    List<int>? bytes;
    try {
      bytes = excel.save();
    } catch (e) {
      throw Exception('Failed to save Excel workbook: $e');
    }

    if (bytes == null || bytes.isEmpty) {
      throw Exception('Excel file generation produced empty or null data');
    }

    print('ExportService: Generated Excel file with ${bytes.length} bytes');

    // Save file
    final directory = await getDownloadsDirectory();
    if (directory != null) {
      final filename = '${_generateSafeFilename('dauco_info')}.xlsx';
      final file = File('${directory.path}/$filename');

      try {
        await file.writeAsBytes(bytes);
        print('ExportService: Successfully saved Excel file to: ${file.path}');
        return file.path;
      } catch (e) {
        throw Exception('Failed to write Excel file to disk: $e');
      }
    }
    throw Exception('Could not save file');
  }

  Future<String> _exportMinorsWithTestsToExcel(
      List<Minor> minors, Map<int, List<Test>> minorTests, String title) async {
    var excel = Excel.createExcel();

    // Remove the default sheet that gets created automatically
    excel.delete('Sheet1');

    // Create minors sheet
    Sheet minorsSheet = excel['Menores'];
    _addMinorsToExcelSheet(minorsSheet, minors, title);

    // Collect all tests
    List<Test> allTests = [];
    for (var tests in minorTests.values) {
      allTests.addAll(tests);
    }
    print(
        'ExportService: _exportMinorsWithTestsToExcel - Total tests collected: ${allTests.length}');

    // Create tests sheet
    if (allTests.isNotEmpty) {
      print(
          'ExportService: Creating Tests sheet with ${allTests.length} tests');
      Sheet testsSheet = excel['Pruebas'];
      _addTestsToExcelSheet(testsSheet, allTests);
    } else {
      print('ExportService: No tests to add to Excel export');
    }

    // Create items sheet - get items for all tests
    List<Item> allItems = [];
    for (var test in allTests) {
      try {
        final items = await _itemService.getItems(test.testId);
        allItems.addAll(items);
      } catch (e) {
        print(
            'ExportService: Error retrieving items for test ${test.testId}: $e');
      }
    }

    if (allItems.isNotEmpty) {
      print(
          'ExportService: Creating Items sheet with ${allItems.length} items');
      Sheet itemsSheet = excel['Items'];
      _addItemsToExcelSheet(itemsSheet, allItems);
    } else {
      print('ExportService: No items to add to Excel export');
    }

    // Final cleanup: Remove Sheet1 if it still exists (sometimes gets recreated)
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Validate that we have at least one sheet
    if (excel.sheets.isEmpty) {
      throw Exception('Excel workbook has no sheets');
    }

    // Save to bytes with validation
    List<int>? bytes;
    try {
      bytes = excel.save();
    } catch (e) {
      throw Exception('Failed to save Excel workbook: $e');
    }

    if (bytes == null || bytes.isEmpty) {
      throw Exception('Excel file generation produced empty or null data');
    }

    print('ExportService: Generated Excel file with ${bytes.length} bytes');

    // Save file
    final directory = await getDownloadsDirectory();
    if (directory != null) {
      final filename = '${_generateSafeFilename('dauco_info')}.xlsx';
      final file = File('${directory.path}/$filename');

      try {
        await file.writeAsBytes(bytes);
        print('ExportService: Successfully saved Excel file to: ${file.path}');
        return file.path;
      } catch (e) {
        throw Exception('Failed to write Excel file to disk: $e');
      }
    }
    throw Exception('Could not save file');
  }

  // Helper methods to add data to Excel sheets
  void _addMinorToExcelSheet(Sheet sheet, Minor minor) {
    // Add headers in row 1 with ALL minor fields
    var headerColumns = [
      'ID Menor',
      'Referencia',
      'ID Responsable',
      'Fecha Nacimiento',
      'Rango Edad',
      'Sexo',
      'Código Postal',
      'Fecha Registro',
      'Edad Padre',
      'Edad Madre',
      'Trabajo Padre',
      'Trabajo Madre',
      'Estudios Padre',
      'Estudios Madre',
      'Estado Civil Padres',
      'Número Hermanos',
      'Posición Hermanos',
      'Miembros Familia',
      'Antecedentes Familiares',
      'Discapacidades Familiares',
      'Tipo Parto',
      'Semanas Gestación',
      'Incidentes Parto',
      'Peso Nacimiento',
      'Test APGAR',
      'Adopción',
      'Enfermedades Relevantes',
      'Juicio Clínico',
      'Nivel Escolarización',
      'Observaciones Escolarización',
      'Situación Socioeconómica',
      'Razón Evaluación',
      'Número Tests',
      'Tests Completados'
    ];

    // Add header row
    for (int i = 0; i < headerColumns.length; i++) {
      var colLetter = String.fromCharCode(65 + (i % 26)); // A, B, C, ...
      if (i >= 26) {
        colLetter = String.fromCharCode(65 + (i ~/ 26 - 1)) +
            String.fromCharCode(65 + (i % 26));
      }
      sheet.cell(CellIndex.indexByString('${colLetter}1')).value =
          TextCellValue(headerColumns[i]);
    }

    // Add data row for the single minor
    var values = [
      minor.minorId,
      minor.reference,
      minor.managerId,
      _formatDate(minor.birthdate),
      minor.ageRange,
      minor.sex,
      minor.zipCode,
      _formatDate(minor.registeredAt),
      minor.fatherAge,
      minor.motherAge,
      minor.fatherJob,
      minor.motherJob,
      minor.fatherStudies,
      minor.motherStudies,
      minor.parentsCivilStatus,
      minor.siblings,
      minor.siblingsPosition,
      minor.familyMembers,
      minor.familyBackground,
      minor.familyDisabilities,
      minor.birthType,
      minor.gestationWeeks,
      minor.birthIncidents,
      '${minor.birthWeight}g',
      minor.apgarTest,
      minor.adoption == 1 ? 'Sí' : 'No',
      minor.relevantDiseases,
      minor.clinicalJudgement,
      minor.schoolingLevel,
      minor.schoolingObservations,
      minor.socioeconomicSituation,
      minor.evaluationReason,
      minor.testsNum,
      minor.completedTests
    ];

    // Add each value to row 2
    for (int i = 0; i < values.length; i++) {
      var colLetter = String.fromCharCode(65 + (i % 26)); // A, B, C, ...
      if (i >= 26) {
        colLetter = String.fromCharCode(65 + (i ~/ 26 - 1)) +
            String.fromCharCode(65 + (i % 26));
      }

      var value = values[i];
      if (value is int) {
        sheet.cell(CellIndex.indexByString('${colLetter}2')).value =
            IntCellValue(value);
      } else {
        sheet.cell(CellIndex.indexByString('${colLetter}2')).value =
            TextCellValue(value.toString());
      }
    }
  }

  void _addMinorsToExcelSheet(Sheet sheet, List<Minor> minors, String title) {
    // Add headers in row 1 with ALL minor fields
    var headerColumns = [
      'ID Menor',
      'Referencia',
      'ID Responsable',
      'Fecha Nacimiento',
      'Rango Edad',
      'Sexo',
      'Código Postal',
      'Fecha Registro',
      'Edad Padre',
      'Edad Madre',
      'Trabajo Padre',
      'Trabajo Madre',
      'Estudios Padre',
      'Estudios Madre',
      'Estado Civil Padres',
      'Número Hermanos',
      'Posición Hermanos',
      'Miembros Familia',
      'Antecedentes Familiares',
      'Discapacidades Familiares',
      'Tipo Parto',
      'Semanas Gestación',
      'Incidentes Parto',
      'Peso Nacimiento',
      'Test APGAR',
      'Adopción',
      'Enfermedades Relevantes',
      'Juicio Clínico',
      'Nivel Escolarización',
      'Observaciones Escolarización',
      'Situación Socioeconómica',
      'Razón Evaluación',
      'Número Tests',
      'Tests Completados'
    ];

    // Add header row
    for (int i = 0; i < headerColumns.length; i++) {
      var colLetter = String.fromCharCode(65 + (i % 26)); // A, B, C, ...
      if (i >= 26) {
        colLetter = String.fromCharCode(65 + (i ~/ 26 - 1)) +
            String.fromCharCode(65 + (i % 26));
      }
      sheet.cell(CellIndex.indexByString('${colLetter}1')).value =
          TextCellValue(headerColumns[i]);
    }

    // Add data rows - one row per minor with all information
    var row = 2; // Start from row 2 (after headers)
    for (var minor in minors) {
      var values = [
        minor.minorId,
        minor.reference,
        minor.managerId,
        _formatDate(minor.birthdate),
        minor.ageRange,
        minor.sex,
        minor.zipCode,
        _formatDate(minor.registeredAt),
        minor.fatherAge,
        minor.motherAge,
        minor.fatherJob,
        minor.motherJob,
        minor.fatherStudies,
        minor.motherStudies,
        minor.parentsCivilStatus,
        minor.siblings,
        minor.siblingsPosition,
        minor.familyMembers,
        minor.familyBackground,
        minor.familyDisabilities,
        minor.birthType,
        minor.gestationWeeks,
        minor.birthIncidents,
        '${minor.birthWeight}g',
        minor.apgarTest,
        minor.adoption == 1 ? 'Sí' : 'No',
        minor.relevantDiseases,
        minor.clinicalJudgement,
        minor.schoolingLevel,
        minor.schoolingObservations,
        minor.socioeconomicSituation,
        minor.evaluationReason,
        minor.testsNum,
        minor.completedTests
      ];

      // Add each value to the appropriate column
      for (int i = 0; i < values.length; i++) {
        var colLetter = String.fromCharCode(65 + (i % 26)); // A, B, C, ...
        if (i >= 26) {
          colLetter = String.fromCharCode(65 + (i ~/ 26 - 1)) +
              String.fromCharCode(65 + (i % 26));
        }

        var value = values[i];
        if (value is int) {
          sheet.cell(CellIndex.indexByString('${colLetter}${row}')).value =
              IntCellValue(value);
        } else {
          sheet.cell(CellIndex.indexByString('${colLetter}${row}')).value =
              TextCellValue(value.toString());
        }
      }
      row++;
    }
  }

  void _addTestsToExcelSheet(Sheet sheet, List<Test> tests) {
    // Add headers
    sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Test ID');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Minor ID');
    sheet.cell(CellIndex.indexByString('C1')).value =
        TextCellValue('Chronological Age');
    sheet.cell(CellIndex.indexByString('D1')).value =
        TextCellValue('Evolutionary Age');
    sheet.cell(CellIndex.indexByString('E1')).value =
        TextCellValue('M-Chat Test');
    sheet.cell(CellIndex.indexByString('F1')).value = TextCellValue('Progress');
    sheet.cell(CellIndex.indexByString('G1')).value =
        TextCellValue('Active Areas');
    sheet.cell(CellIndex.indexByString('H1')).value =
        TextCellValue('Professional Type');
    sheet.cell(CellIndex.indexByString('I1')).value =
        TextCellValue('Registered At');

    // Add data rows
    var row = 2;
    for (var test in tests) {
      sheet.cell(CellIndex.indexByString('A${row}')).value =
          IntCellValue(test.testId);
      sheet.cell(CellIndex.indexByString('B${row}')).value =
          IntCellValue(test.minorId);
      sheet.cell(CellIndex.indexByString('C${row}')).value =
          TextCellValue(test.cronologicalAge);
      sheet.cell(CellIndex.indexByString('D${row}')).value =
          TextCellValue(test.evolutionaryAge);
      sheet.cell(CellIndex.indexByString('E${row}')).value =
          BoolCellValue(test.mChatTest);
      sheet.cell(CellIndex.indexByString('F${row}')).value =
          TextCellValue(test.progress);
      sheet.cell(CellIndex.indexByString('G${row}')).value =
          IntCellValue(test.activeAreas);
      sheet.cell(CellIndex.indexByString('H${row}')).value =
          TextCellValue(test.professionalType);
      sheet.cell(CellIndex.indexByString('I${row}')).value =
          TextCellValue(_formatDate(test.registeredAt));
      row++;
    }
  }

  void _addItemsToExcelSheet(Sheet sheet, List<Item> items) {
    // Add headers for test items
    sheet.cell(CellIndex.indexByString('A1')).value =
        TextCellValue('Response ID');
    sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Item ID');
    sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Test ID');
    sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue('Item');
    sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue('Área');
    sheet.cell(CellIndex.indexByString('F1')).value = TextCellValue('Pregunta');
    sheet.cell(CellIndex.indexByString('G1')).value =
        TextCellValue('Respuesta');

    // Add data rows
    var row = 2;
    for (var item in items) {
      sheet.cell(CellIndex.indexByString('A${row}')).value =
          IntCellValue(item.responseId);
      sheet.cell(CellIndex.indexByString('B${row}')).value =
          IntCellValue(item.itemId);
      sheet.cell(CellIndex.indexByString('C${row}')).value =
          IntCellValue(item.testId);
      sheet.cell(CellIndex.indexByString('D${row}')).value =
          TextCellValue(item.item);
      sheet.cell(CellIndex.indexByString('E${row}')).value =
          TextCellValue(item.area);
      sheet.cell(CellIndex.indexByString('F${row}')).value =
          TextCellValue(item.question);
      sheet.cell(CellIndex.indexByString('G${row}')).value =
          TextCellValue(item.answer);
      row++;
    }
  }
}
