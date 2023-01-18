import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class Mock{{feature.pascalCase()}}Repository extends Mock implements {{feature.pascalCase()}}Repository {}

class Mock{{feature.pascalCase()}}ReadBloc extends Mock implements {{feature.pascalCase()}}ReadBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class Fake{{feature.pascalCase()}}ReadEvent extends Fake implements {{feature.pascalCase()}}ReadEvent {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late Mock{{feature.pascalCase()}}Repository repo;

  late Mock{{feature.pascalCase()}}ReadBloc mock{{feature.pascalCase()}}ReadBloc;
  late MockNavigatorObserver mockNavigatorObserver;

  late StreamController<{{feature.pascalCase()}}ChangeInfo> streamController;
  late StreamController<{{feature.pascalCase()}}ReadState> blocStreamController;
  final test{{feature.pascalCase()}} =
      {{feature.pascalCase()}}(id: '9999', {{#properties}}{{name}}:{{{testValue}}}, {{/properties}});
  final test{{feature.pascalCase()}}2 =
      {{feature.pascalCase()}}(id: '8888', {{#properties}}{{name}}:{{{testValue}}}, {{/properties}});
  final test{{feature.pascalCase()}}s = [test{{feature.pascalCase()}}];
  setUpAll(() {
    registerFallbackValue(Fake{{feature.pascalCase()}}ReadEvent());
    registerFallbackValue(FakeRoute());
  });
  setUp(() {
    repo = Mock{{feature.pascalCase()}}Repository();
    mock{{feature.pascalCase()}}ReadBloc = Mock{{feature.pascalCase()}}ReadBloc();
    mockNavigatorObserver = MockNavigatorObserver();
    streamController = StreamController<{{feature.pascalCase()}}ChangeInfo>.broadcast();
    blocStreamController = StreamController<{{feature.pascalCase()}}ReadState>.broadcast();

    when(() => repo.read()).thenAnswer((_) => streamController.stream);
    when(() => repo.readMore()).thenAnswer((_) async {});
    when(() => repo.readMore(true)).thenAnswer((_) async {});
    when(() => mock{{feature.pascalCase()}}ReadBloc.stream)
        .thenAnswer((_) => blocStreamController.stream);
    when(() => mock{{feature.pascalCase()}}ReadBloc.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    streamController.close();
    blocStreamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<{{feature.pascalCase()}}Repository>.value(value: repo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<{{feature.pascalCase()}}ReadBloc>.value(value: mock{{feature.pascalCase()}}ReadBloc),
        ],
        child: MaterialApp(
          home: body,
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
  }

  group('{{feature.pascalCase()}}s View', () {
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
                    Navigator.of(context).push({{feature.pascalCase()}}ReadView.route()),
              ),
            ),
          ),
        ),
      );
      when(() => mock{{feature.pascalCase()}}ReadBloc.state)
          .thenReturn({{feature.pascalCase()}}ReadStateLoading());
      await tester.pumpWidget(widget);

      final testFinder = find.byKey(testKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping add button, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('{{feature.pascalCase()}}'));
    });
    testWidgets('should show progress indicator when state is loading',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateLoading());

      await tester
          .pumpWidget(makeTestableWidget(const {{feature.pascalCase()}}ReadView()));

      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
    });

    testWidgets('should show error message when state is failure',
        (WidgetTester tester) async {
      const testId = 'failed TEST__TEST';
      when(() => mock{{feature.pascalCase()}}ReadBloc.state)
          .thenReturn(const {{feature.pascalCase()}}ReadStateFailure(message: testId));

      await tester.pumpWidget(makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc)));

      expect(find.textContaining(testId), equals(findsOneWidget));
    });

    testWidgets('should show widget when loading complete',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateSuccess({{feature}}s:test{{feature.pascalCase()}}s, totalCount: test{{feature.pascalCase()}}s.length));

      await tester
          .pumpWidget(makeTestableWidget({{feature.pascalCase()}}ReadView(
            bloc: mock{{feature.pascalCase()}}ReadBloc)));

      expect(find.byKey(ObjectKey(test{{feature.pascalCase()}})), equals(findsOneWidget));
    });

    testWidgets('should show widget and loading placeholder when total count is greater than list size',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateSuccess
      ({{feature}}s:test{{feature.pascalCase()}}s, totalCount: 2));

      when(() => mock{{feature.pascalCase()}}ReadBloc.add(any())).thenAnswer((_) async {});


      await tester
          .pumpWidget(makeTestableWidget({{feature.pascalCase()}}ReadView(
            bloc: mock{{feature.pascalCase()}}ReadBloc)));

      expect(find.byKey(ObjectKey(test{{feature.pascalCase()}})), equals(findsOneWidget));
      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));

      await tester.pump(Duration.zero);
    });

    testWidgets(
        'should trigger state to change to loading when reload is tapped',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateLoading());

      await tester.pumpWidget(makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc)));

      final testFinder = find.byIcon(Icons.refresh);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      await tester.pump();

      verify(() => mock{{feature.pascalCase()}}ReadBloc.add(const {{feature.pascalCase()}}ReadEventReload())).called(1);
      expect(find.byIcon(Icons.refresh), equals(findsOneWidget));
    });

    testWidgets(
        'should create a new entity',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn(
          {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: test{{feature.pascalCase()}}s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc)));
      blocStreamController
          .add({{feature.pascalCase()}}ReadStateCreate(selected{{feature.pascalCase()}}: test{{feature.pascalCase()}}2));

      await tester.pump();

      expect(find.byKey(ObjectKey(test{{feature.pascalCase()}})), findsOneWidget);
      expect(find.byKey(ObjectKey(test{{feature.pascalCase()}}2)), findsOneWidget);
    });

    testWidgets(
        'should update an entity',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn(
          {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: test{{feature.pascalCase()}}s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc)));
      final updatedTest = test{{feature.pascalCase()}}.copyWith();
      blocStreamController
          .add({{feature.pascalCase()}}ReadStateUpdate(selected{{feature.pascalCase()}}: updatedTest));

      await tester.pump();

      expect(find.byKey(ObjectKey(updatedTest)), findsOneWidget);
      expect(find.byKey(ObjectKey(test{{feature.pascalCase()}})), findsNothing);
      
    });

    testWidgets(
        'should delete an entity',
        (WidgetTester tester) async {
      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn(
          {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: test{{feature.pascalCase()}}s, totalCount: 1));

      await tester.pumpWidget(
          makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc)));
      blocStreamController
          .add({{feature.pascalCase()}}ReadStateDelete(selected{{feature.pascalCase()}}: test{{feature.pascalCase()}}.copyWith()));

      await tester.pump();

      expect(find.byType({{feature.pascalCase()}}Widget), findsNothing);
      
    });

    testWidgets('home button pops navigator', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc));

      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateLoading());
      await tester.pumpWidget(widget);

      final testFinder = find.byKey({{feature.pascalCase()}}ReadView.topLeftButtonKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      
      await tester.pumpWidget(widget);

      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

    testWidgets('tap add button pushes navigator', (tester) async {
      var widget = makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc));

      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn({{feature.pascalCase()}}ReadStateLoading());
      await tester.pumpWidget(widget);

      final testFinder = find.byKey({{feature.pascalCase()}}ReadView.bottomRightButtonKey);
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping add button, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('{{feature.pascalCase()}}'));
    });
      
    testWidgets('tap listitem pushes navigator', (tester) async {
      var widget =
          makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc));

      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn(
          {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: test{{feature.pascalCase()}}s, totalCount: 1));
      await tester.pumpWidget(widget);

      final testFinder = find.byKey(ObjectKey(test{{feature.pascalCase()}}));
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);

      await tester.pumpWidget(widget);

      final captured =
          verify(() => mockNavigatorObserver.didPush(captureAny(), any()))
              .captured;

      expect(captured[0], isA<MaterialPageRoute>(),
          reason: 'Initial push should be this view, but not found');
      expect(captured[1], isA<MaterialPageRoute>(),
          reason: 'After tapping listitem, there should be a new route');

      expect(captured[0].settings.name, equals('/'));
      expect(captured[1].settings.name, contains('{{feature.pascalCase()}}'));
    });

    testWidgets('tap listitem delete adds delete event', (tester) async {
      var widget =
          makeTestableWidget({{feature.pascalCase()}}ReadView(bloc: mock{{feature.pascalCase()}}ReadBloc));

      when(() => mock{{feature.pascalCase()}}ReadBloc.state).thenReturn(
          {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: test{{feature.pascalCase()}}s, totalCount: 1));
      await tester.pumpWidget(widget);

      final testFinder = find.byKey({{feature.pascalCase()}}ReadView.deleteButtonKey(test{{feature.pascalCase()}}.id));
      await tester.ensureVisible(testFinder);
      await tester.tap(testFinder);
      
      await tester.pumpWidget(widget);

      final captured =
          verify(() => mock{{feature.pascalCase()}}ReadBloc.add(captureAny())).captured;

      expect(captured[0], isA<{{feature.pascalCase()}}ReadEventDelete>(),
          reason: 'Should add delete event');
      expect(captured[0].{{feature}}, equals(test{{feature.pascalCase()}}));
    });
  });
}
