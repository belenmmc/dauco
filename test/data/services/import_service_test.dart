import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dauco/data/services/import_service.dart';

void main() {
  late ImportService service;
  late Excel excel;

  setUp(() {
    service = ImportService();
    excel = Excel.createExcel();
    excel.rename('Sheet1', 'Usuarios');

    // Sheet: Usuarios
    excel.appendRow(
        'Usuarios',
        [
          'Responsable Id',
          'Nombre',
          'Apellidos',
          'Sí',
          'Alta',
          'Zona',
          'Nº de menores'
        ].map((h) => TextCellValue(h)).toList());

    excel.appendRow('Usuarios', [
      IntCellValue(1),
      TextCellValue('Ana'),
      TextCellValue('Martínez'),
      TextCellValue('Sí'),
      DateTimeCellValue(year: 2024, month: 1, day: 15, hour: 10, minute: 0),
      TextCellValue('Centro'),
      IntCellValue(2),
    ]);

    excel.appendRow('Usuarios', [
      IntCellValue(2),
      TextCellValue('Luis'),
      TextCellValue('Gómez'),
      TextCellValue('No'),
      DateTimeCellValue(year: 2024, month: 1, day: 15, hour: 10, minute: 0),
      TextCellValue('Sur'),
      IntCellValue(0),
    ]);

    // Sheet: Menores
    excel.appendRow(
        'Menores',
        [
          'Menor Id',
          'Referencia del menor',
          'Responsable Id',
          'Fecha nacimiento',
          'Rango edad',
          'Alta',
          'Nº de tests',
          'Nº de tests completados',
          'Sexo',
          'Código postal',
          'Edad padre',
          'Edad madre',
          'Trabajo padre',
          'Trabajo madre',
          'Nivel estudios padre',
          'Nivel estudios madre',
          'Estado civil padres',
          'Nº hermanos',
          'Posición hermanos',
          'Tipo parto',
          'Semana gestación',
          'Incidencias parto',
          'Peso nacimiento',
          'Situación socioeconómica',
          'Antecedentes familiares',
          'Familiares domicilio',
          'Familiares discapacidad',
          'Nivel escolarizacion',
          'Observaciones escolarización',
          'Enfermedades relevantes',
          'Motivo valoración',
          'Resultado test Apgar',
          'Adopción',
          'Juicio clínico'
        ].map((h) => TextCellValue(h)).toList());

    excel.appendRow('Menores', [
      IntCellValue(101),
      TextCellValue('Ref-001'),
      IntCellValue(1),
      DateTimeCellValue(year: 2020, month: 1, day: 1, hour: 10, minute: 0),
      TextCellValue('3-5'),
      DateTimeCellValue(year: 2024, month: 1, day: 15, hour: 10, minute: 0),
      IntCellValue(1),
      IntCellValue(1),
      TextCellValue('F'),
      IntCellValue(28001),
      IntCellValue(35),
      IntCellValue(33),
      TextCellValue('Ingeniero'),
      TextCellValue('Médica'),
      TextCellValue('Universidad'),
      TextCellValue('Universidad'),
      TextCellValue('Casados'),
      IntCellValue(2),
      IntCellValue(1),
      TextCellValue('Natural'),
      IntCellValue(39),
      TextCellValue('Ninguna'),
      IntCellValue(3200),
      TextCellValue('Media'),
      TextCellValue('Sin antecedentes'),
      IntCellValue(4),
      TextCellValue('Ninguna'),
      TextCellValue('Infantil'),
      TextCellValue('Ninguna'),
      TextCellValue('Asma'),
      TextCellValue('Retraso'),
      IntCellValue(9),
      IntCellValue(0),
      TextCellValue('Normal')
    ]);

    // Sheet: Tests
    excel.appendRow(
        'Tests',
        [
          'Test Id',
          'Menor Id',
          'Alta',
          'Edad Cronológica',
          'Edad evolutiva',
          'Test MChat',
          'Progreso',
          'Áreas activas',
          'Tipo profesional'
        ].map((h) => TextCellValue(h)).toList());

    excel.appendRow('Tests', [
      IntCellValue(1001),
      IntCellValue(101),
      DateTimeCellValue(year: 2024, month: 1, day: 15, hour: 10, minute: 0),
      TextCellValue('4 años'),
      TextCellValue('3.5 años'),
      TextCellValue('Pasado'),
      TextCellValue('En curso'),
      TextCellValue('Lenguaje'),
      TextCellValue('Psicólogo')
    ]);

    // Sheet: Items
    excel.appendRow(
        'Items',
        [
          'Respuesta Id',
          'Item Id',
          'Nº Item Id',
          'Test Id',
          'Área',
          'Pregunta',
          'Respuesta'
        ].map((h) => TextCellValue(h)).toList());

    excel.appendRow('Items', [
      IntCellValue(5001),
      IntCellValue(1),
      IntCellValue(1),
      IntCellValue(1001),
      TextCellValue('Lenguaje'),
      TextCellValue('¿Responde a su nombre?'),
      TextCellValue('Sí')
    ]);
  });

  group('ImportService', () {
    test('should return parsed users', () async {
      final result = await service.getUsers(excel, page: 1, pageSize: 2);
      expect(result.length, 2);
      expect(result[0].name, 'Ana');
      expect(result[1].surname, 'Gómez');
    });

    test('should return parsed minors', () async {
      final result = await service.getMinors(excel);
      expect(result.length, 1);
      expect(result[0].minorId, 101);
      expect(result[0].sex, 'F');
    });

    test('should return parsed tests for minor', () async {
      final result = await service.getTests(excel, 101);
      expect(result.length, 1);
      expect(result[0].testId, 1001);
      expect(result[0].professionalType, 'Psicólogo');
    });

    test('should return parsed items for test', () async {
      final result = await service.getItems(excel, 1001);
      expect(result.length, 1);
      expect(result[0].question, '¿Responde a su nombre?');
      expect(result[0].answer, 'Sí');
    });
  });
}
