import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

void main() {
  final testFeature1 = Feature1(id: 'test-feature1-1', firstName:'testString', lastName:'testString', registered:true, age:1, );

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 200,
          height: 40,
          child: body,
        ),
      ),
    );
  }

  group('feature1 widget', () {
    testWidgets('loads normally', (tester) async {
      final testableWidget = makeTestableWidget(Feature1Widget(
        entity: testFeature1,
        focusScopeNode: FocusScopeNode(),
        onEdit: () {},
        onDelete: () {},
      ));
      await tester.pumpWidget(testableWidget);
      expect(find.byType(Text), equals(findsOneWidget));
    });

    testWidgets('is editted', (tester) async {
      bool onEditCalled = false;
      final feature1Widget = Feature1Widget(
        entity: testFeature1,
        focusScopeNode: FocusScopeNode(),
        onEdit: () => onEditCalled = true,
        onDelete: () {},
      );
      final testableWidget = makeTestableWidget(feature1Widget);
      await tester.pumpWidget(testableWidget);
      await tester.tap(find.byType(Text));
      await tester.pumpAndSettle();
      expect(onEditCalled, equals(true), reason: 'on edit should be called');
    });

    testWidgets('is deleted', (tester) async {
      bool onDeleteCalled = false;
      final feature1Widget = Feature1Widget(
        entity: testFeature1,
        focusScopeNode: FocusScopeNode(),
        onEdit: () {},
        onDelete: () => onDeleteCalled = true,
      );
      final testableWidget = makeTestableWidget(feature1Widget);
      await tester.pumpWidget(testableWidget);
      await tester.tap(find.byKey(Key('feature1-${testFeature1.id}-delete-button')));
      await tester.pumpAndSettle();
      expect(onDeleteCalled, equals(true),
          reason: 'on delete should be called');
    });

  });
}
