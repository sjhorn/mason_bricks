import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

void main() {
  final test{{feature.pascalCase()}} = {{feature.pascalCase()}}(id: 'test-{{feature}}-1', {{#properties}}{{name}}:{{{testValue}}}, {{/properties}});

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

  group('{{feature}} widget', () {
    testWidgets('loads normally', (tester) async {
      final testableWidget = makeTestableWidget({{feature.pascalCase()}}Widget(
        entity: test{{feature.pascalCase()}},
        focusScopeNode: FocusScopeNode(),
        onEdit: () {},
        onDelete: () {},
      ));
      await tester.pumpWidget(testableWidget);
      expect(find.byType(Text), equals(findsOneWidget));
    });

    testWidgets('is editted', (tester) async {
      bool onEditCalled = false;
      final {{feature}}Widget = {{feature.pascalCase()}}Widget(
        entity: test{{feature.pascalCase()}},
        focusScopeNode: FocusScopeNode(),
        onEdit: () => onEditCalled = true,
        onDelete: () {},
      );
      final testableWidget = makeTestableWidget({{feature}}Widget);
      await tester.pumpWidget(testableWidget);
      await tester.tap(find.byType(Text));
      await tester.pumpAndSettle();
      expect(onEditCalled, equals(true), reason: 'on edit should be called');
    });

    testWidgets('is deleted', (tester) async {
      bool onDeleteCalled = false;
      final {{feature}}Widget = {{feature.pascalCase()}}Widget(
        entity: test{{feature.pascalCase()}},
        focusScopeNode: FocusScopeNode(),
        onEdit: () {},
        onDelete: () => onDeleteCalled = true,
      );
      final testableWidget = makeTestableWidget({{feature}}Widget);
      await tester.pumpWidget(testableWidget);
      await tester.tap(find.byKey(Key('{{feature}}-${test{{feature.pascalCase()}}.id}-delete-button')));
      await tester.pumpAndSettle();
      expect(onDeleteCalled, equals(true),
          reason: 'on delete should be called');
    });

  });
}
