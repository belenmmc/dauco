import 'dart:io';
import 'dart:typed_data';

import 'package:dauco/data/services/mappers/item_mapper.dart';
import 'package:dauco/data/services/mappers/minor_mapper.dart';
import 'package:dauco/data/services/mappers/test_mapper.dart';
import 'package:dauco/data/services/imported_user_service.dart';
import 'package:dauco/domain/entities/imported_user.entity.dart';
import 'package:dauco/domain/entities/item.entity.dart';
import 'package:dauco/domain/entities/minor.entity.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:dauco/presentation/widgets/duplicate_conflict_dialog.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImportService {
  Future<Excel?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    Uint8List? fileBytes = result?.files.first.bytes;

    if (fileBytes == null) {
      File file = File(result!.files.first.path!);
      fileBytes = await file.readAsBytes();
    }

    return Excel.decodeBytes(fileBytes);
  }
/*
  Future<List<ImportedUser>> getUsers(file,
      {int page = 1, int pageSize = 10}) async {
    var sheet = file?.tables.keys.first;

    List<ImportedUser> users = [];

    var rows = file!.tables[sheet]!.rows.skip(1).toList();

    int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    if (endIndex > rows.length) {
      endIndex = rows.length;
    }

    for (var i = startIndex; i < endIndex; i++) {
      var row = rows[i];
      if (row.isNotEmpty) {
        int? managerId = int.parse(row[0]?.value.toString() ?? "");
        String name = row[1]?.value.toString() ?? "";
        String surname = row[2]?.value.toString() ?? "";
        bool yes = row[3]?.value.toString() == "Sí" ? true : false;
        DateTime registeredAt = DateTime.parse(row[4]?.value.toString() ?? "");
        String zone = row[5]?.value.toString() ?? "";
        int minorsNum = int.parse(row[6]?.value.toString() ?? "");

        users.add(ImportedUser(
          managerId: managerId,
          name: name,
          surname: surname,
          yes: yes,
          registeredAt: registeredAt,
          zone: zone,
          minorsNum: minorsNum,
        ));
      }
    }

    return users;
  }

  Future<List<Minor>> getMinors(file, {int page = 1, int pageSize = 10}) async {
    var sheet = file?.tables.keys.elementAt(1);

    List<Minor> minors = [];

    var rows = file!.tables[sheet]!.rows.skip(1).toList();

    int startIndex = (page - 1) * pageSize;
    int endIndex = startIndex + pageSize;

    if (endIndex > rows.length) {
      endIndex = rows.length;
    }

    for (var i = startIndex; i < endIndex; i++) {
      var row = rows[i];
      if (row.isNotEmpty) {
        int minorId = int.parse(row[0]?.value.toString() ?? "0");
        int reference = int.parse(row[1]?.value.toString() ?? "0");
        int managerId = int.parse(row[2]?.value.toString() ?? "0");
        DateTime birthdate = DateTime.parse(
            row[3]?.value.toString() ?? DateTime.now().toString());
        String ageRange = row[4]?.value.toString() ?? "";
        DateTime registeredAt = DateTime.parse(
            row[5]?.value.toString() ?? DateTime.now().toString());
        int testsNum = int.parse(row[6]?.value.toString() ?? "0");
        int completedTests = int.parse(row[7]?.value.toString() ?? "0");
        String sex = row[8]?.value.toString() ?? "";
        int zipCode = int.parse(row[9]?.value.toString() ?? "0");
        int fatherAge = int.parse(row[10]?.value.toString() ?? "0");
        int motherAge = int.parse(row[11]?.value.toString() ?? "0");
        String fatherJob = row[12]?.value.toString() ?? "";
        String motherJob = row[13]?.value.toString() ?? "";
        String fatherStudies = row[14]?.value.toString() ?? "";
        String motherStudies = row[15]?.value.toString() ?? "";
        String parentsCivilStatus = row[16]?.value.toString() ?? "";
        int siblings = int.parse(row[17]?.value.toString() ?? "0");
        int siblingsPosition = int.parse(row[18]?.value.toString() ?? "0");
        String birthType = row[19]?.value.toString() ?? "";
        int gestationWeeks = int.parse(row[20]?.value.toString() ?? "0");
        String birthIncidents = row[21]?.value.toString() ?? "";
        int birthWeight = int.parse(row[22]?.value.toString() ?? "0");
        String socioeconomicSituation = row[23]?.value.toString() ?? "";
        String familyBackground = row[24]?.value.toString() ?? "";
        int familyMembers = int.parse(row[25]?.value.toString() ?? "0");
        String familyDisabilities = row[26]?.value.toString() ?? "";
        String schoolingLevel = row[27]?.value.toString() ?? "";
        String schoolingObservations = row[28]?.value.toString() ?? "";
        String relevantDiseases = row[29]?.value.toString() ?? "";
        String evaluationReason = row[30]?.value.toString() ?? "";
        int apgarTest = int.parse(row[31]?.value.toString() ?? "0");
        int adoption = int.parse(row[32]?.value.toString() ?? "0");
        String clinicalJudgement = row[33]?.value.toString() ?? "";

        minors.add(Minor(
          minorId: minorId,
          reference: reference,
          managerId: managerId,
          birthdate: birthdate,
          ageRange: ageRange,
          registeredAt: registeredAt,
          testsNum: testsNum,
          completedTests: completedTests,
          sex: sex,
          zipCode: zipCode,
          fatherAge: fatherAge,
          motherAge: motherAge,
          fatherJob: fatherJob,
          motherJob: motherJob,
          fatherStudies: fatherStudies,
          motherStudies: motherStudies,
          parentsCivilStatus: parentsCivilStatus,
          siblings: siblings,
          siblingsPosition: siblingsPosition,
          birthType: birthType,
          gestationWeeks: gestationWeeks,
          birthIncidents: birthIncidents,
          birthWeight: birthWeight,
          socioeconomicSituation: socioeconomicSituation,
          familyBackground: familyBackground,
          familyMembers: familyMembers,
          familyDisabilities: familyDisabilities,
          schoolingLevel: schoolingLevel,
          schoolingObservations: schoolingObservations,
          relevantDiseases: relevantDiseases,
          evaluationReason: evaluationReason,
          apgarTest: apgarTest,
          adoption: adoption,
          clinicalJudgement: clinicalJudgement,
        ));
      }
    }

    return minors;
  }

  Future<List<Test>> getTests(file, int minorId) async {
    var sheet = file?.tables.keys.elementAt(2);
    List<Test> tests = [];

    var rows = file!.tables[sheet]!.rows.skip(1).toList();

    for (var row in rows) {
      if (row.isNotEmpty) {
        int testId = int.parse(row[0]?.value.toString() ?? "0");
        int minorId = int.parse(row[1]?.value.toString() ?? "0");
        DateTime registeredAt = DateTime.parse(
            row[2]?.value.toString() ?? DateTime.now().toString());
        String cronologicalAge = row[3]?.value.toString() ?? "";
        String evolutionaryAge = row[4]?.value.toString() ?? "";
        bool mChatTest = row[5]?.value.toString() == "Sí" ? true : false;
        String progress = row[6]?.value.toString() ?? "";
        int activeAreas = int.parse(row[7]?.value.toString() ?? "0");
        String professionalType = row[8]?.value.toString() ?? "";

        tests.add(Test(
          testId: testId,
          minorId: minorId,
          registeredAt: registeredAt,
          cronologicalAge: cronologicalAge,
          evolutionaryAge: evolutionaryAge,
          mChatTest: mChatTest,
          progress: progress,
          activeAreas: activeAreas,
          professionalType: professionalType,
        ));
      }
    }

    return tests.where((test) => test.minorId == minorId).toList();
  }

  Future<List<Item>> getItems(file, int testId) async {
    var sheet = file?.tables.keys.elementAt(3);
    List<Item> items = [];

    var rows = file!.tables[sheet]!.rows.skip(1).toList();

    for (var row in rows) {
      if (row.isNotEmpty) {
        int responseId = int.parse(row[0]?.value.toString() ?? "0");
        int itemId = int.parse(row[1]?.value.toString() ?? "0");
        String item = row[2]?.value.toString() ?? "";
        int testId = int.parse(row[3]?.value.toString() ?? "0");
        String area = row[4]?.value.toString() ?? "";
        String question = row[5]?.value.toString() ?? "";
        String answer = row[6]?.value.toString() ?? "";

        items.add(Item(
          responseId: responseId,
          itemId: itemId,
          item: item,
          testId: testId,
          area: area,
          question: question,
          answer: answer,
        ));
      }
    }

    return items.where((item) => item.testId == testId).toList();
  } */

  Future<Map<String, Map<String, int>>> loadFile(
      Excel file, Function(double) onProgress, BuildContext context) async {
    final totalSteps = 4.0; // Ahora son 4 pasos (validación incluida)
    double currentStep = 0.0;
    Map<String, Map<String, int>> importResults = {};

    // PASO 1: Importar usuarios PRIMERO
    final users = await uploadUsers(file);
    final userStats = await uploadInBatches(
        "Usuarios", users.map((u) => u.toJson()).toList(), context,
        primaryKey: "responsable_id");
    importResults['users'] = userStats;
    currentStep++;
    onProgress(currentStep / totalSteps);

    // PASO 2: Validar que todos los responsable_id de los menores existen
    final minors = await uploadMinors(file);
    final importedUserService = ImportedUserService();
    final invalidManagerIds = <int>[];

    for (var minor in minors) {
      final exists = await importedUserService.existsManagerId(minor.managerId);
      if (!exists && !invalidManagerIds.contains(minor.managerId)) {
        invalidManagerIds.add(minor.managerId);
      }
    }

    if (invalidManagerIds.isNotEmpty) {
      throw Exception(
          'Error: Los siguientes IDs de responsable no existen en la tabla Usuarios: ${invalidManagerIds.join(", ")}. '
          'Por favor, asegúrese de que todos los responsables estén en la primera hoja del Excel.');
    }

    // PASO 3: Importar menores (ya validados)
    final minorStats = await uploadInBatches(
        "Menores", minors.map((m) => MinorMapper.toJson(m)).toList(), context,
        primaryKey: "menor_id");
    importResults['minors'] = minorStats;
    currentStep++;
    onProgress(currentStep / totalSteps);

    // PASO 4: Importar tests e items
    final tests = await uploadTests(file);
    final items = await uploadItems(file);
    final testStats = await uploadInBatches(
        "Tests", tests.map((t) => TestMapper.toJson(t)).toList(), context,
        primaryKey: "test_id");
    final itemStats = await uploadInBatches(
        "Items", items.map((i) => ItemMapper.toJson(i)).toList(), context,
        primaryKey: "respuesta_id");
    importResults['tests'] = testStats;
    importResults['items'] = itemStats;
    currentStep++;
    onProgress(currentStep / totalSteps);

    return importResults;
  }

  Future<Map<String, int>> uploadInBatches(
      String table, List<Map<String, dynamic>> data, BuildContext context,
      {int batchSize = 1000,
      String? primaryKey,
      bool allowDuplicates = false}) async {
    int insertedCount = 0;
    int updatedCount = 0;
    int skippedCount = 0;

    // Variables for "Apply to All" functionality
    ConflictResolution? globalResolution;
    bool useGlobalResolution = false;

    for (int i = 0; i < data.length; i += batchSize) {
      try {
        final end = (i + batchSize > data.length) ? data.length : i + batchSize;
        final batch = data.sublist(i, end);

        if (allowDuplicates || primaryKey == null) {
          // Insert without duplicate checking
          await Supabase.instance.client.from(table).insert(batch);
          insertedCount += batch.length;
        } else {
          // Check for duplicates and handle accordingly
          for (var record in batch) {
            try {
              final primaryKeyValue = record[primaryKey];

              // Check if record exists
              final existingRecord = await Supabase.instance.client
                  .from(table)
                  .select('*')
                  .eq(primaryKey, primaryKeyValue)
                  .maybeSingle();

              if (existingRecord == null) {
                // Record doesn't exist, insert it
                await Supabase.instance.client.from(table).insert(record);
                insertedCount++;
              } else {
                // Record exists, check if they are identical
                if (DuplicateConflictDialog.areRecordsIdentical(
                    existingRecord, record)) {
                  // Records are identical, keep existing (auto-skip)
                  skippedCount++;
                } else {
                  // Records are different, handle conflict
                  ConflictResolution? resolution;

                  if (useGlobalResolution && globalResolution != null) {
                    // Use the previously selected "apply to all" resolution
                    resolution = globalResolution;
                  } else {
                    // Show conflict dialog
                    final dialogResult = await showDialog<Map<String, dynamic>>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return DuplicateConflictDialog(
                          recordType: _getRecordTypeName(table),
                          primaryKey: primaryKey,
                          primaryKeyValue: primaryKeyValue,
                          existingRecord: existingRecord,
                          newRecord: record,
                        );
                      },
                    );

                    if (dialogResult != null) {
                      resolution =
                          dialogResult['resolution'] as ConflictResolution?;
                      final applyToAll =
                          dialogResult['applyToAll'] as bool? ?? false;

                      if (applyToAll && resolution != null) {
                        globalResolution = resolution;
                        useGlobalResolution = true;
                      }
                    }
                  }

                  switch (resolution) {
                    case ConflictResolution.keepExisting:
                      skippedCount++;
                      break;
                    case ConflictResolution.replaceWithNew:
                      await Supabase.instance.client
                          .from(table)
                          .update(record)
                          .eq(primaryKey, primaryKeyValue);
                      updatedCount++;
                      break;
                    case null:
                      skippedCount++;
                      break;
                  }
                }
              }
            } catch (e) {
              print(
                  "Error processing record with ${primaryKey}: ${record[primaryKey]} - ${e.toString()}");
              skippedCount++;
            }
          }
        }
      } catch (e) {
        print("Error uploading batch to $table: ${e.toString()}");
        final currentBatch = data.sublist(
            i, (i + batchSize > data.length) ? data.length : i + batchSize);
        skippedCount += currentBatch.length;
      }
    }

    return {
      'inserted': insertedCount,
      'updated': updatedCount,
      'skipped': skippedCount,
    };
  }

  String _getRecordTypeName(String table) {
    switch (table.toLowerCase()) {
      case 'usuarios':
        return 'Usuario';
      case 'menores':
        return 'Menor';
      case 'tests':
        return 'Test';
      case 'items':
        return 'Item';
      default:
        return table;
    }
  }

  Future<List<ImportedUser>> uploadUsers(Excel file) async {
    var sheet = file.tables.keys.first;
    List<ImportedUser> users = [];
    var rows = file.tables[sheet]!.rows.skip(1);

    for (var row in rows) {
      if (row.isNotEmpty) {
        int? managerId = int.parse(row[0]?.value.toString() ?? "");
        String name = row[1]?.value.toString() ?? "";
        String surname = row[2]?.value.toString() ?? "";
        bool yes = row[3]?.value.toString() == "Sí";
        DateTime registeredAt = DateTime.parse(row[4]?.value.toString() ?? "");
        String zone = row[5]?.value.toString() ?? "";
        int minorsNum = int.parse(row[6]?.value.toString() ?? "");

        users.add(ImportedUser(
          managerId: managerId,
          name: name,
          surname: surname,
          yes: yes,
          registeredAt: registeredAt,
          zone: zone,
          minorsNum: minorsNum,
        ));
      }
    }

    return users;
  }

  Future<List<Minor>> uploadMinors(Excel file) async {
    var sheet = file.tables.keys.elementAt(1);
    List<Minor> minors = [];
    var rows = file.tables[sheet]!.rows.skip(1);

    for (var row in rows) {
      if (row.isNotEmpty) {
        minors.add(Minor(
          minorId: int.parse(row[0]?.value.toString() ?? "0"),
          reference: int.parse(row[1]?.value.toString() ?? "0"),
          managerId: int.parse(row[2]?.value.toString() ?? "0"),
          birthdate: DateTime.parse(
              row[3]?.value.toString() ?? DateTime.now().toString()),
          ageRange: row[4]?.value.toString() ?? "",
          registeredAt: DateTime.parse(
              row[5]?.value.toString() ?? DateTime.now().toString()),
          testsNum: int.parse(row[6]?.value.toString() ?? "0"),
          completedTests: int.parse(row[7]?.value.toString() ?? "0"),
          sex: row[8]?.value.toString() ?? "",
          zipCode: int.parse(row[9]?.value.toString() ?? "0"),
          fatherAge: int.parse(row[10]?.value.toString() ?? "0"),
          motherAge: int.parse(row[11]?.value.toString() ?? "0"),
          fatherJob: row[12]?.value.toString() ?? "",
          motherJob: row[13]?.value.toString() ?? "",
          fatherStudies: row[14]?.value.toString() ?? "",
          motherStudies: row[15]?.value.toString() ?? "",
          parentsCivilStatus: row[16]?.value.toString() ?? "",
          siblings: int.parse(row[17]?.value.toString() ?? "0"),
          siblingsPosition: int.parse(row[18]?.value.toString() ?? "0"),
          birthType: row[19]?.value.toString() ?? "",
          gestationWeeks: int.parse(row[20]?.value.toString() ?? "0"),
          birthIncidents: row[21]?.value.toString() ?? "",
          birthWeight: int.parse(row[22]?.value.toString() ?? "0"),
          socioeconomicSituation: row[23]?.value.toString() ?? "",
          familyBackground: row[24]?.value.toString() ?? "",
          familyMembers: int.parse(row[25]?.value.toString() ?? "0"),
          familyDisabilities: row[26]?.value.toString() ?? "",
          schoolingLevel: row[27]?.value.toString() ?? "",
          schoolingObservations: row[28]?.value.toString() ?? "",
          relevantDiseases: row[29]?.value.toString() ?? "",
          evaluationReason: row[30]?.value.toString() ?? "",
          apgarTest: int.parse(row[31]?.value.toString() ?? "0"),
          adoption: int.parse(row[32]?.value.toString() ?? "0"),
          clinicalJudgement: row[33]?.value.toString() ?? "",
        ));
      }
    }

    return minors;
  }

  Future<List<Test>> uploadTests(Excel file) async {
    var sheet = file.tables.keys.elementAt(2);
    List<Test> tests = [];
    var rows = file.tables[sheet]!.rows.skip(1);

    for (var row in rows) {
      if (row.isNotEmpty) {
        tests.add(Test(
          testId: int.parse(row[0]?.value.toString() ?? "0"),
          minorId: int.parse(row[1]?.value.toString() ?? "0"),
          registeredAt: DateTime.parse(
              row[2]?.value.toString() ?? DateTime.now().toString()),
          cronologicalAge: row[3]?.value.toString() ?? "",
          evolutionaryAge: row[4]?.value.toString() ?? "",
          mChatTest: row[5]?.value.toString() == "TRUE" ? true : false,
          progress: row[6]?.value.toString() ?? "",
          activeAreas: int.parse(row[7]?.value.toString() ?? "0"),
          professionalType: row[8]?.value.toString() ?? "",
        ));
      }
    }

    return tests;
  }

  Future<List<Item>> uploadItems(Excel file) async {
    var sheet = file.tables.keys.elementAt(3);
    List<Item> items = [];
    var rows = file.tables[sheet]!.rows.skip(1);

    for (var row in rows) {
      if (row.isNotEmpty) {
        items.add(Item(
          responseId: int.parse(row[0]?.value.toString() ?? "0"),
          itemId: int.parse(row[1]?.value.toString() ?? "0"),
          item: row[2]?.value.toString() ?? "",
          testId: int.parse(row[3]?.value.toString() ?? "0"),
          area: row[4]?.value.toString() ?? "",
          question: row[5]?.value.toString() ?? "",
          answer: row[6]?.value.toString() ?? "",
        ));
      }
    }

    return items;
  }
}
