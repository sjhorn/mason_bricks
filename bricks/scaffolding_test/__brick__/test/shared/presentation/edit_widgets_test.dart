import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

import 'package:scaffolding_sample/shared/presentation/edit_widgets.dart';

void main() {
  setUpAll(() {});

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(home: Scaffold(body: body));
  }

  testEditWidget<T>(tester, T value) async {
    const testKey = Key('testKey');
    final testFinder = find.byKey(testKey);
    const labelText = 'Test Label';
    bool changeCalled = false;
    bool submittedCalled = false;
    final widget = makeTestableWidget(EditWidget<T>(
      labelText: labelText,
      initialValue: (_) => value,
      changedEvent: (_, __) {
        changeCalled = true;
      },
      submittedEvent: (_) {
        submittedCalled = true;
      },
      key: testKey,
    ));

    await tester.pumpWidget(widget);
    await tester.ensureVisible(testFinder);

    expect(testFinder, findsOneWidget);
    expect(
      find.descendant(
        of: testFinder,
        matching: find.text(labelText),
      ),
      findsOneWidget,
    );
    if (T != bool) {
      expect(
        find.descendant(
          of: testFinder,
          matching: find.text('$value'),
        ),
        findsOneWidget,
      );
    }

    await tester.tap(testFinder);
    if (T != bool) {
      await tester.enterText(testFinder, 'test');
    } else {
      await tester.tap(
          find.descendant(of: testFinder, matching: find.byType(Checkbox)));
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
    }
    await tester.pump();

    expect(changeCalled, equals(true));

    if (T != bool) {
      await tester.testTextInput.receiveAction(TextInputAction.done);
    } else {
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    }
    await tester.pump();

    expect(submittedCalled, equals(true));
  }

  group('shared editwidgets..', () {
    testWidgets('test edit widget for double', (tester) async {
      await testEditWidget<double>(tester, 1.2);
    });

    testWidgets('test edit widget for int', (tester) async {
      await testEditWidget<int>(tester, 2);
    });

    testWidgets('test edit widget for String', (tester) async {
      await testEditWidget<String>(tester, 'test string');
    });

    testWidgets('test edit widget for bool', (tester) async {
      await testEditWidget<bool>(tester, true);
    });
  });
}
