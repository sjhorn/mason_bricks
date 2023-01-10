import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
{{#features}}import 'package:{{package}}/features/{{.}}/domain/{{.}}_repository.dart';
{{/features}}import 'package:{{package}}/scaffold_app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route<dynamic> {}

{{#features}}class Mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository extends Mock implements {{#pascalCase}}{{.}}{{/pascalCase}}Repository {}
{{/features}}
void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('features listed and clickable', () {

     {{#features}}testWidgets('Tap {{,}} feature navigates to feature read view', (tester) async {
      final mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository = Mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository();
      final streamController = StreamController<{{#pascalCase}}{{.}}{{/pascalCase}}ChangeInfo>.broadcast();

      when(() => mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository.read())
          .thenAnswer((_) => streamController.stream);
      when(() => mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository.readMore(true)).thenAnswer((_) async {});

      final widget = RepositoryProvider<{{#pascalCase}}{{.}}{{/pascalCase}}Repository>.value(
        value: mock{{#pascalCase}}{{.}}{{/pascalCase}}Repository,
        child: App(navigatorObserver: mockNavigatorObserver),
      );
      const testKey = Key('{{.}}-feature-tile');

      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(testKey));
      await tester.pump();

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial route not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping feature, there should be a new route');
      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('{{#pascalCase}}{{.}}{{/pascalCase}}'));
    });
    {{/features}}

    testWidgets('Confirm app starter shows scaffolded features', (tester) async {
      await tester.pumpWidget(appWidget());
      {{#features}}
      expect(find.byKey(const Key('{{.}}-feature-tile')), findsOneWidget);{{/features}}
    });
  });
}