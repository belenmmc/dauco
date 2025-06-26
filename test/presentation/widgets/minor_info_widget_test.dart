import 'package:dauco/presentation/widgets/minor_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dauco/domain/entities/minor.entity.dart';

void main() {
  group('MinorInfoWidget', () {
    testWidgets('MinorInfoWidget displays minor information correctly',
        (WidgetTester tester) async {
      final minor = Minor(
        minorId: 1,
        reference: 'ABC123',
        managerId: 2,
        birthdate: DateTime(2010, 5, 15),
        registeredAt: DateTime(2023, 4, 10),
        ageRange: '6-10',
        testsNum: 5,
        completedTests: 3,
        sex: 'Femenino',
        zipCode: 28001,
        schoolingLevel: 'Primaria',
        schoolingObservations: 'Sin observaciones',
        socioeconomicSituation: 'Media',
        relevantDiseases: 'Asma',
        evaluationReason: 'Valoración rutinaria',
        apgarTest: 8,
        adoption: 0,
        clinicalJudgement: 'Sin anomalías',
        motherAge: 35,
        fatherAge: 37,
        motherJob: 'Profesora',
        fatherJob: 'Ingeniero',
        motherStudies: 'Universitarios',
        fatherStudies: 'Secundarios',
        siblings: 1,
        siblingsPosition: 1,
        parentsCivilStatus: 'Casados',
        familyBackground: 'Sin antecedentes',
        familyMembers: 3,
        familyDisabilities: 'Ninguna',
        birthType: 'Natural',
        gestationWeeks: 40,
        birthIncidents: 'Ninguno',
        birthWeight: 3000,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinorInfoWidget(minor: minor),
          ),
        ),
      );

      // Check key labels and values
      expect(find.text('Id del menor'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // Multiple are OK
      expect(find.text('Referencia'), findsOneWidget);
      expect(find.text('ABC123'), findsOneWidget);
      expect(find.text('Id del responsable'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // Check some other labeled data
      expect(find.text('Rango de edad'), findsOneWidget);
      expect(find.text('6-10'), findsOneWidget);
      expect(find.text('Sexo'), findsOneWidget);
      expect(find.text('Femenino'), findsOneWidget);
      expect(find.text('Test de Apgar'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);

      // Family info
      expect(find.text('Edad madre'), findsOneWidget);
      expect(find.text('35'), findsOneWidget);
      expect(find.text('Trabajo padre'), findsOneWidget);
      expect(find.text('Ingeniero'), findsOneWidget);
      expect(find.text('Número de hermanos'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // Appears multiple times

      // Birth info
      expect(find.text('Tipo de parto'), findsOneWidget);
      expect(find.text('Natural'), findsOneWidget);
      expect(find.text('Peso al nacer'), findsOneWidget);
      expect(find.text('3000'), findsOneWidget);
    });

    testWidgets('MinorInfoWidget handles empty or null data gracefully',
        (WidgetTester tester) async {
      final minor = Minor(
        minorId: 0,
        reference: '',
        managerId: 0,
        birthdate: DateTime(2000, 1, 1),
        registeredAt: DateTime(2000, 1, 1),
        ageRange: '',
        testsNum: 0,
        completedTests: 0,
        sex: '',
        zipCode: 0,
        schoolingLevel: '',
        schoolingObservations: '',
        socioeconomicSituation: '',
        relevantDiseases: '',
        evaluationReason: '',
        apgarTest: 0,
        adoption: 0,
        clinicalJudgement: '',
        motherAge: 0,
        fatherAge: 0,
        motherJob: '',
        fatherJob: '',
        motherStudies: '',
        fatherStudies: '',
        siblings: 0,
        siblingsPosition: 0,
        parentsCivilStatus: '',
        familyBackground: '',
        familyMembers: 0,
        familyDisabilities: '',
        birthType: '',
        gestationWeeks: 0,
        birthIncidents: '',
        birthWeight: 0.0.toInt(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinorInfoWidget(minor: minor),
          ),
        ),
      );

      // Check labels still appear
      expect(find.text('Id del menor'), findsOneWidget);
      expect(find.text('Referencia'), findsOneWidget);

      // Accept multiple 0s
      expect(find.text('0'), findsWidgets);

      // Optionally: Check null/empty string is replaced by "-"
      expect(find.text('-'), findsWidgets);
    });

    testWidgets(
        'MinorInfoWidget layout adjusts correctly on different screen sizes',
        (WidgetTester tester) async {
      final minor = Minor(
        minorId: 1,
        reference: 'Ref123',
        managerId: 5,
        birthdate: DateTime(2010, 5, 10),
        registeredAt: DateTime(2015, 6, 15),
        ageRange: '6-12',
        testsNum: 10,
        completedTests: 8,
        sex: 'Male',
        zipCode: 12345,
        schoolingLevel: 'Primary',
        schoolingObservations: 'Good',
        socioeconomicSituation: 'Middle',
        relevantDiseases: 'None',
        evaluationReason: 'Routine Check',
        apgarTest: 8,
        adoption: 0,
        clinicalJudgement: 'Healthy',
        motherAge: 35,
        fatherAge: 40,
        motherJob: 'Teacher',
        fatherJob: 'Engineer',
        motherStudies: 'University',
        fatherStudies: 'High School',
        siblings: 2,
        siblingsPosition: 1,
        parentsCivilStatus: 'Married',
        familyBackground: 'No history of diseases',
        familyMembers: 4,
        familyDisabilities: 'None',
        birthType: 'Normal',
        gestationWeeks: 40,
        birthIncidents: 'None',
        birthWeight: 3.2.toInt(),
      );

      // Build the widget tree for small screen (portrait mode)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MinorInfoWidget(minor: minor),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check that key sections are present and properly arranged
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Card),
          findsWidgets); // Ensure that multiple cards are rendered

      // Test the layout when the screen is in landscape mode (wider screen)
      tester.binding.window.physicalSizeTestValue =
          Size(800, 600); // Landscape size
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Reset back to default screen size
      tester.binding.window.physicalSizeTestValue =
          Size(400, 800); // Portrait size
    });
  });
}
