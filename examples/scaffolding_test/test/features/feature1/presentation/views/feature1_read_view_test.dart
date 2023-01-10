import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:scaffolding_sample/features/feature1/feature1.dart';

class MockFeature1Repository extends Mock implements Feature1Repository {}

class MockFeature1ReadBloc extends Mock implements Feature1ReadBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeFeature1ReadEvent extends Fake implements Feature1ReadEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockFeature1Repository repo;

  late MockFeature1ReadBloc mockFeature1ReadBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  late StreamController<Feature1ChangeInfo> streamController;
  late StreamController<Feature1ReadState> blocStreamController;
  final testFeature1 =
      Feature1(id: '9999', firstName:'testString', lastName:'testString', registered:true, age:1, );
  final testFeature12 =
      Feature1(id: '8888', firstName:'testString', lastName:'testString', registered:true, age:1, );
  final testFeature1s = [testFeature1];
  setUpAll(() {
    registerFallbackValue(FakeFeature1ReadEvent());
    registerFallbackValue(FakeRoute());
  });
  setUp(() {
    repo = MockFeature1Repository();
    mockFeature1ReadBloc = MockFeature1ReadBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    streamController = StreamController<Feature1ChangeInfo>.broadcast();
    blocStreamController = StreamController<Feature1ReadState>.broadcast();

    when(() => repo.read()).thenAnswer((_) => streamController.stream);
    when(() => repo.readMore()).thenAnswer((_) async {});
    when(() => repo.readMore(true)).thenAnswer((_) async {});
    when(() => mockFeature1ReadBloc.stream)
        .thenAnswer((_) => blocStreamController.stream);
    when(() => mockFeature1ReadBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    streamController.close();
    blocStreamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Feature1Repository>.value(value: repo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Feature1ReadBloc>.value(value: mockFeature1ReadBloc),
        ],
        child: MaterialApp(
          home: body,
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('Feature1s View', () {
    testWidgets('confirm creation of route', (WidgetTester tester) async {
      const testKey = Key('test-route');
      final widget = makeTestableWidget(
        Builder(
          builder: (context) => Scaffold(
            body: SizedBox(
              width: 800,
              height: 600,
              child: InkWell(
                key: testKey,
                onTap: () =>
                    Navigator.of(context).push(Feature1ReadView.route()),
              ),
            ),
          ),
        ),
      );
      when(() => mockFeature1ReadBloc.state)
          .thenReturn(Feature1ReadStateLoading());
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(testKey));
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping add button, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('Feature1'));
    });
    testWidgets('should show progress indicator when state is loading',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateLoading());

      await tester
          .pumpWidget(makeTestableWidget(const Feature1ReadView()));

      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
    });

    testWidgets('should show error message when state is failure',
        (WidgetTester tester) async {
      const testId = 'failed TEST__TEST';
      when(() => mockFeature1ReadBloc.state)
          .thenReturn(const Feature1ReadStateFailure(message: testId));

      await tester.pumpWidget(makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc)));

      expect(find.textContaining(testId), equals(findsOneWidget));
    });

    testWidgets('should show widget when loading complete',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateSuccess(feature1s:testFeature1s, totalCount: testFeature1s.length));

      await tester
          .pumpWidget(makeTestableWidget(Feature1ReadView(
            bloc: mockFeature1ReadBloc)));

      expect(find.byKey(ObjectKey(testFeature1)), equals(findsOneWidget));
    });

    testWidgets('should show widget and loading placeholder when total count is greater than list size',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateSuccess
      (feature1s:testFeature1s, totalCount: 2));

      when(() => mockFeature1ReadBloc.add(any())).thenAnswer((_) async {});


      await tester
          .pumpWidget(makeTestableWidget(Feature1ReadView(
            bloc: mockFeature1ReadBloc)));

      expect(find.byKey(ObjectKey(testFeature1)), equals(findsOneWidget));
      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));

      await tester.pump(Duration.zero);
    });

    testWidgets(
        'should trigger state to change to loading when reload is tapped',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateLoading());

      await tester.pumpWidget(makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc)));
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      verify(() => mockFeature1ReadBloc.add(const Feature1ReadEventReload())).called(1);
      expect(find.byIcon(Icons.refresh), equals(findsOneWidget));
    });

    testWidgets(
        'should create a new entity',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(
          Feature1ReadStateSuccess(feature1s: testFeature1s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc)));
      blocStreamController
          .add(Feature1ReadStateCreate(selectedFeature1: testFeature12));

      await tester.pump();

      expect(find.byKey(ObjectKey(testFeature1)), findsOneWidget);
      expect(find.byKey(ObjectKey(testFeature12)), findsOneWidget);
    });

    testWidgets(
        'should update an entity',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(
          Feature1ReadStateSuccess(feature1s: testFeature1s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc)));
      final updatedTest = testFeature1.copyWith();
      blocStreamController
          .add(Feature1ReadStateUpdate(selectedFeature1: updatedTest));

      await tester.pump();

      expect(find.byKey(ObjectKey(updatedTest)), findsOneWidget);
      expect(find.byKey(ObjectKey(testFeature1)), findsNothing);
      
    });

    testWidgets(
        'should delete an entity',
        (WidgetTester tester) async {
      when(() => mockFeature1ReadBloc.state).thenReturn(
          Feature1ReadStateSuccess(feature1s: testFeature1s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc)));
      blocStreamController
          .add(Feature1ReadStateDelete(selectedFeature1: testFeature1.copyWith()));

      await tester.pump();

      expect(find.byType(Feature1Widget), findsNothing);
      
    });

    testWidgets('home button pops navigator', (tester) async {
      var widget = makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc));

      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateLoading());
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(Feature1ReadView.topLeftButtonKey));
      await tester.pumpWidget(widget);

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

    testWidgets('tap add button pushes navigator', (tester) async {
      var widget = makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc));

      when(() => mockFeature1ReadBloc.state).thenReturn(Feature1ReadStateLoading());
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(Feature1ReadView.bottomRightButtonKey));
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping add button, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('Feature1'));
    });
      
    testWidgets('tap listitem pushes navigator', (tester) async {
      var widget =
          makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc));

      when(() => mockFeature1ReadBloc.state).thenReturn(
          Feature1ReadStateSuccess(feature1s: testFeature1s, totalCount: 1));
      await tester.pumpWidget(widget);

      await tester.tap(find.byKey(ObjectKey(testFeature1)));
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping listitem, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('Feature1'));
    });

    testWidgets('tap listitem delete adds delete event', (tester) async {
      var widget =
          makeTestableWidget(Feature1ReadView(bloc: mockFeature1ReadBloc));

      when(() => mockFeature1ReadBloc.state).thenReturn(
          Feature1ReadStateSuccess(feature1s: testFeature1s, totalCount: 1));
      await tester.pumpWidget(widget);

      await tester
          .tap(find.byKey(Feature1ReadView.deleteButtonKey(testFeature1.id)));
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockFeature1ReadBloc.add(captureAny())).captured;

      expect(captured[0], isA<Feature1ReadEventDelete>(),
          reason: 'Should add delete event');
      expect(captured[0].feature1, equals(testFeature1));
    });
  });
}
