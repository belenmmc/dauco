import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dauco/presentation/widgets/tests_list_widget.dart';
import 'package:dauco/domain/entities/test.entity.dart';
import 'package:excel/excel.dart';

void main() {
  group('TestsListWidget', () {
    late List<Test> mockTests;
    late Excel dummyExcel;

    setUp(() {
      mockTests = [
        Test(
          testId: 1,
          minorId: 1,
          registeredAt: DateTime(2023, 1, 1),
          cronologicalAge: '5 años',
          evolutionaryAge: '4 años',
          mChatTest: 'Test 1',
          activeAreas: 'Area 1',
          progress: '0.2',
          professionalType: 'Tipo 1',
        ),
        Test(
          testId: 2,
          minorId: 2,
          registeredAt: DateTime(2023, 2, 1),
          cronologicalAge: '6 años',
          evolutionaryAge: '5 años',
          mChatTest: 'Test 2',
          activeAreas: 'Area 2',
          progress: '0.4',
          professionalType: 'Tipo 2',
        ),
      ];

      dummyExcel = Excel.createExcel();
    });

    testWidgets('renders test cards with correct info', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestsListWidget(file: dummyExcel, tests: mockTests),
        ),
      );

      for (var test in mockTests) {
        final testCardFinder = find.text('Test ${test.testId}');

        expect(testCardFinder, findsOneWidget);

        final card =
            find.ancestor(of: testCardFinder, matching: find.byType(Card));

        expect(
            find.descendant(
                of: card, matching: find.text(test.cronologicalAge)),
            findsOneWidget);
        expect(
            find.descendant(
                of: card, matching: find.text(test.evolutionaryAge)),
            findsOneWidget);
      }
    });

    /* testWidgets('navigates to TestInfoPage on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestsListWidget(file: dummyExcel, tests: mockTests),
        ),
      );

      // Tap the first test card
      await tester.tap(find.text('Test 1'));
      await tester.pumpAndSettle();

      // Check navigation result
      expect(find.byType(Scaffold), findsWidgets); // At least still on a page
      expect(find.textContaining('Test'),
          findsWidgets); // A rough check — or better if TestInfoPage is imported
    }); */
  });
}
