import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:scaffolding_sample/features/feature1/domain/feature1_repository.dart';
import 'package:scaffolding_sample/scaffold_app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route<dynamic> {}

class MockFeature1Repository extends Mock implements Feature1Repository {}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('features listed and clickable', () {

     testWidgets('Tap  feature navigates to feature read view', (tester) async {
      final mockFeature1Repository = MockFeature1Repository();
      final streamController = StreamController<Feature1ChangeInfo>.broadcast();

      when(() => mockFeature1Repository.read())
          .thenAnswer((_) => streamController.stream);
      when(() => mockFeature1Repository.readMore(true)).thenAnswer((_) async {});

      final widget = RepositoryProvider<Feature1Repository>.value(
        value: mockFeature1Repository,
        child: App(navigatorObserver: mockNavigatorObserver),
      );
      const testKey = Key('feature1-feature-tile');

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
      expect(captured[1].settings.name, contains('Feature1'));
    });
    

    testWidgets('Confirm app starter shows scaffolded features', (tester) async {
      await tester.pumpWidget(appWidget());
      
      expect(find.byKey(const Key('feature1-feature-tile')), findsOneWidget);
    });
  });
}