import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:{{package}}/features/{{feature}}/{{feature}}.dart';

class Mock{{feature.pascalCase()}}Repository extends Mock implements {{feature.pascalCase()}}Repository {}

class Mock{{feature.pascalCase()}} extends Mock implements {{feature.pascalCase()}} {}

void main() {
  late Mock{{feature.pascalCase()}}Repository repo;
  final controller = StreamController<{{feature.pascalCase()}}ChangeInfo>.broadcast();
  const id = 'test-{{feature}}-1';
  final test{{feature.pascalCase()}} = {{feature.pascalCase()}}(id: id, {{#properties}}{{name}}: {{{testValue}}}, {{/properties}});
  setUp(() {
    repo = Mock{{feature.pascalCase()}}Repository();
    when(() => repo.read()).thenAnswer((_) => controller.stream);
    
  });
  group('edit issue bloc', () {
    {{#properties}}
    blocTest<{{feature.pascalCase()}}EditBloc, {{feature.pascalCase()}}EditState>(
      'should emit [initial, with the new {{name}}] for {{name}} change',
      build: () => {{feature.pascalCase()}}EditBloc(repo, test{{feature.pascalCase()}}),
      act: (bloc) => bloc.add(const {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed({{{testValue}}})),
      expect: () => [
        {{feature.pascalCase()}}EditState({{feature}}: test{{feature.pascalCase()}}, {{#properties}}{{name}}: {{{testValue}}}, {{/properties}}),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );{{/properties}}

    blocTest<{{feature.pascalCase()}}EditBloc, {{feature.pascalCase()}}EditState>(
      'should emit [initial, success] when submitting the entity we are editing',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.update(any())).thenAnswer((_) async {});
        return {{feature.pascalCase()}}EditBloc(repo, test{{feature.pascalCase()}});
      },
      act: (bloc) => bloc.add({{feature.pascalCase()}}EditEventSubmitted()),
      expect: () => [
        isA<{{feature.pascalCase()}}EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );

    blocTest<{{feature.pascalCase()}}EditBloc, {{feature.pascalCase()}}EditState>(
      'should emit [initial, success] when submitting',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.create(any())).thenAnswer((_) async {});
        return {{feature.pascalCase()}}EditBloc(repo);
      },
      act: (bloc) => bloc.add({{feature.pascalCase()}}EditEventSubmitted()),
      expect: () => [
        isA<{{feature.pascalCase()}}EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );

    blocTest<{{feature.pascalCase()}}EditBloc, {{feature.pascalCase()}}EditState>(
      'should emit [initial, success] when deleting the entity we are editing',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.delete(any())).thenAnswer((_) async {});
        return {{feature.pascalCase()}}EditBloc(repo, test{{feature.pascalCase()}});
      },
      act: (bloc) => bloc.add({{feature.pascalCase()}}EditEventDelete()),
      expect: () => [
        isA<{{feature.pascalCase()}}EditState>(),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {},
    );
  });

  group( 'equatable events', () {
    test('property event submitted', () async {
      {{feature.pascalCase()}}EditEventSubmitted testEvent = {{feature.pascalCase()}}EditEventSubmitted();
      expect(testEvent.props.length, equals(0));
      expect(testEvent, equals(testEvent));
    });
    test('property event deleted', () async {
      {{feature.pascalCase()}}EditEventDelete testEvent = {{feature.pascalCase()}}EditEventDelete();
      expect(testEvent.props.length, equals(0));
      expect(testEvent, equals(testEvent));
    });

    {{#properties}}
    test('property event {{name}}', () async {
      {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed test{{name.pascalCase()}}Event = const {{feature.pascalCase()}}EditEvent{{name.pascalCase()}}Changed({{{testValue}}});
      expect(test{{name.pascalCase()}}Event.props.length, equals(1));
      expect(test{{name.pascalCase()}}Event, equals(test{{name.pascalCase()}}Event));
    });
    {{/properties}}
  });
}
