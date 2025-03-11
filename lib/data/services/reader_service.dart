import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReaderService {
  Future<void> readExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes == null) {
        File file = File(result.files.first.path!);
        fileBytes = await file.readAsBytes();
      }

      var excel = Excel.decodeBytes(fileBytes);

      //await readTableUsuarios(excel);
      //await readTableMenores(excel);
      //await readTableTests(excel);
      //await readTableItems(excel);

      print("Data inserted successfully.");
    } else {
      print('User canceled file picker');
    }
  }

  Future<void> readTableUsuarios(var excel) async {
    for (var row in excel.tables["Usuarios"]!.rows.skip(1)) {
      if (row.isEmpty || row.every((cell) => cell == null)) continue;

      var id = row[0]?.value.toString() ?? 'NULL';
      var name = row[1]?.value.toString() ?? 'NULL';
      var surname = row[2]?.value.toString() ?? 'NULL';
      var yes = row[3]?.value.toString() ?? 'NULL';
      var registeredAt = row[4]?.value.toString() ?? 'NULL';
      var zone = row[5]?.value.toString() ?? 'NULL';
      var minorsNum = row[6]?.value.toString() ?? 'NULL';

      bool yesBool;
      yes == 'Sí' ? yesBool = true : yesBool = false;

      await Supabase.instance.client.from("Usuarios").insert({
        'responsable_id': id,
        'nombre': name,
        'apellidos': surname,
        'si': yesBool,
        'alta': toTimestampString(registeredAt),
        'zona': zone,
        'num_menores': minorsNum,
      });

      print("Inserted into USUARIOS");
    }
  }

  Future<void> readTableMenores(var excel) async {
    for (var row in excel.tables["Menores"]!.rows.skip(1)) {
      if (row.isEmpty || row.every((cell) => cell == null)) continue;

      var menorId = row[0]?.value.toString() ?? 'NULL';
      var minorRef = row[1]?.value.toString() ?? null;
      var responsibleId = row[2]?.value.toString() ?? 'NULL';
      var birthDate = row[3]?.value.toString() ?? 'NULL';
      var ageRange = row[4]?.value.toString() ?? 'NULL';
      var registeredAt = row[5]?.value.toString() ?? 'NULL';
      var testsNum = row[6]?.value.toString() ?? null;
      var completedTests = row[7]?.value.toString() ?? null;
      var sex = row[8]?.value.toString() ?? 'NULL';
      var zipCode = row[9]?.value.toString() ?? null;
      var fatherAge = row[10]?.value.toString() ?? null;
      var motherAge = row[11]?.value.toString() ?? null;
      var fatherJob = row[12]?.value.toString() ?? 'NULL';
      var motherJob = row[13]?.value.toString() ?? 'NULL';
      var fatherStudies = row[14]?.value.toString() ?? 'NULL';
      var motherStudies = row[15]?.value.toString() ?? 'NULL';
      var parentsCivilStatus = row[16]?.value.toString() ?? 'NULL';
      var siblings = row[17]?.value.toString() ?? null;
      var siblingsPosition = row[18]?.value.toString() ?? null;
      var birthType = row[19]?.value.toString() ?? 'NULL';
      var gestationWeeks = row[20]?.value.toString() ?? null;
      var birthIncidents = row[21]?.value.toString() ?? 'NULL';
      var birthWeight = row[22]?.value.toString() ?? null;
      var socioeconomicSituation = row[23]?.value.toString() ?? 'NULL';
      var familyBackground = row[24]?.value.toString() ?? 'NULL';
      var familyMembers = row[25]?.value.toString() ?? null;
      var familyDisabilities = row[26]?.value.toString() ?? null;
      var schoolingLevel = row[27]?.value.toString() ?? 'NULL';
      var schoolingObservations = row[28]?.value.toString() ?? 'NULL';
      var relevantDiseases = row[29]?.value.toString() ?? 'NULL';
      var evaluationReason = row[30]?.value.toString() ?? 'NULL';
      var apgarTest = row[31]?.value.toString() ?? null;
      var adoption = row[32]?.value.toString() ?? null;
      var clinicalJudgement = row[33]?.value.toString() ?? 'NULL';

      await Supabase.instance.client.from("Menores").insert({
        'menor_id': menorId,
        'referencia': minorRef,
        'responsable_id': responsibleId,
        'fecha_nacimiento': birthDate,
        'rango_edad': ageRange,
        'alta': toTimestampString(registeredAt),
        'num_tests': testsNum,
        'test_completados': completedTests,
        'sexo': sex,
        'cp': zipCode,
        'edad_padre': fatherAge,
        'edad_madre': motherAge,
        'trabajo_padre': fatherJob,
        'trabajo_madre': motherJob,
        'estudios_padre': fatherStudies,
        'estudios_madre': motherStudies,
        'estado_civil_padres': parentsCivilStatus,
        'hermanos': siblings,
        'posicion_hermanos': siblingsPosition,
        'tipo_parto': birthType,
        'semana_gestacion': gestationWeeks,
        'incidencias_parto': birthIncidents,
        'peso_nacimiento': birthWeight,
        'situacion_socioeconomica': socioeconomicSituation,
        'antecedentes_familiares': familyBackground,
        'familiares_domicilio': familyMembers,
        'familiares_discapacidad': familyDisabilities,
        'nivel_escolarizacion': schoolingLevel,
        'observaciones_escolarizacion': schoolingObservations,
        'enfermedades_relevantes': relevantDiseases,
        'motivo_valoracion': evaluationReason,
        'test_apgar': apgarTest,
        'adopcion': adoption,
        'juicio_clinico': clinicalJudgement,
      });

      print("Inserted into MENORES");
    }
  }

  Future<void> readTableTests(var excel) async {
    for (var row in excel.tables["Tests"]!.rows.skip(1)) {
      if (row.isEmpty || row.every((cell) => cell == null)) continue;

      var testId = row[0]?.value.toString() ?? 'NULL';
      var minorId = row[1]?.value.toString() ?? 'NULL';
      var registeredAt = row[2]?.value.toString() ?? 'NULL';
      var cronologicalAge = row[3]?.value.toString() ?? 'NULL';
      var evolutiveAge = row[4]?.value.toString() ?? 'NULL';
      var mChat = row[5]?.value.toString() ?? 'NULL';
      var progress = row[6]?.value.toString() ?? 'NULL';
      var activeAreas = row[7]?.value.toString() ?? null;
      var professional = row[8]?.value.toString() ?? 'NULL';

      bool mChatBool;
      mChat == 'TRUE' ? mChatBool = true : mChatBool = false;

      await Supabase.instance.client.from("Tests").insert({
        'test_id': testId,
        'menor_id': minorId,
        'alta': toTimestampString(registeredAt),
        'edad_cronologica': cronologicalAge,
        'edad_evolutiva': evolutiveAge,
        'test_mchat': mChatBool,
        'progreso': progress,
        'areas_activas': activeAreas,
        'tipo_profesional': professional,
      });

      print("Inserted into TESTS");
    }
  }

  Future<void> readTableItems(var excel) async {
    for (var row in excel.tables["Items"]!.rows.skip(1)) {
      if (row.isEmpty || row.every((cell) => cell == null)) continue;

      var responseId = row[0]?.value.toString() ?? 'NULL';
      var itemId = row[1]?.value.toString() ?? 'NULL';
      var numItemId = row[2]?.value.toString() ?? 'NULL';
      var testId = row[3]?.value.toString() ?? 'NULL';
      var area = row[4]?.value.toString() ?? 'NULL';
      var question = row[5]?.value.toString() ?? 'NULL';
      var answer = row[6]?.value.toString() ?? 'NULL';

      await Supabase.instance.client.from("Items").insert({
        'respuesta_id': responseId,
        'item_id': itemId,
        'num_item_id': numItemId,
        'test_id': testId,
        'area': area,
        'pregunta': question,
        'respuesta': answer,
      });

      print("Inserted into ITEMS");
    }
  }
}
