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
    when(() => repo.readMore(true)).thenAnswer((_) async => controller.sink
        .add({{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.read, {{feature}}s: [test{{feature.pascalCase()}}])));

    //{{feature}}Bloc = {{feature.pascalCase()}}ReadBloc(repo);
  });
  group('{{feature}}s bloc', () {
    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, success] for successful data load',
      build: () => {{feature.pascalCase()}}ReadBloc(repo),
      act: (bloc) {},
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: [test{{feature.pascalCase()}}]),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.read()).called(1);
      },
    );

    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, failure] for unsuccessful data load',
      build: () {
        when(() => repo.readMore(true))
            .thenAnswer((_) async => controller.sink.addError('failed'));
        return {{feature.pascalCase()}}ReadBloc(repo);
      },
      act: (bloc) {},
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        const {{feature.pascalCase()}}ReadStateFailure(message: 'failed'),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.read()).called(1);
      },
    );

    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, create, success] after create',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.create(any())).thenAnswer((_) async {
          controller.add(
              {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.create, {{feature}}s: [test{{feature.pascalCase()}}]));
        });
        return {{feature.pascalCase()}}ReadBloc(repo);
      },
      act: (bloc) => bloc.add(const {{feature.pascalCase()}}ReadEventCreate()),
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        isA<{{feature.pascalCase()}}ReadStateSuccess>(),
        {{feature.pascalCase()}}ReadStateCreate(selected{{feature.pascalCase()}}: test{{feature.pascalCase()}}),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.create(any())).called(1);
      },
    );

    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, delete, success] after delete',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.delete(any())).thenAnswer((args) async {
          {{feature.pascalCase()}} {{feature}} = args.positionalArguments[0];
          controller.add(
              {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.delete, {{feature}}s: [{{feature}}]));
        });
        return {{feature.pascalCase()}}ReadBloc(repo);
      },
      act: (bloc) => bloc.add({{feature.pascalCase()}}ReadEventDelete(test{{feature.pascalCase()}})),
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        isA<{{feature.pascalCase()}}ReadStateSuccess>(),
        {{feature.pascalCase()}}ReadStateDelete(selected{{feature.pascalCase()}}: test{{feature.pascalCase()}}),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.delete(any())).called(1);
      },
    );

    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, update, success] after delete',
      build: () {
        registerFallbackValue(Mock{{feature.pascalCase()}}());
        when(() => repo.update(any())).thenAnswer((args) async {
          {{feature.pascalCase()}} {{feature}} = args.positionalArguments[0];
          controller.add(
              {{feature.pascalCase()}}ChangeInfo(type: {{feature.pascalCase()}}ChangeType.update, {{feature}}s: [{{feature}}]));
        });
        return {{feature.pascalCase()}}ReadBloc(repo);
      },
      act: (bloc) => bloc.add({{feature.pascalCase()}}ReadEventUpdate(test{{feature.pascalCase()}})),
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        isA<{{feature.pascalCase()}}ReadStateSuccess>(),
        {{feature.pascalCase()}}ReadStateUpdate(selected{{feature.pascalCase()}}: test{{feature.pascalCase()}}),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.update(any())).called(1);
      },
    );

    blocTest<{{feature.pascalCase()}}ReadBloc, {{feature.pascalCase()}}ReadState>(
      'should emit [loading, success] after readMore',
      build: () {
        when(() => repo.readMore()).thenAnswer((args) async {
          controller.add(
            {{feature.pascalCase()}}ChangeInfo(
                type: {{feature.pascalCase()}}ChangeType.read, {{feature}}s: [test{{feature.pascalCase()}}], totalCount: 1),
          );
        });
        return {{feature.pascalCase()}}ReadBloc(repo);
      },
      act: (bloc) => bloc.add(const {{feature.pascalCase()}}ReadEventReadMore()),
      expect: () => [
        {{feature.pascalCase()}}ReadStateLoading(),
        {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: [test{{feature.pascalCase()}}]),
        {{feature.pascalCase()}}ReadStateSuccess({{feature}}s: [test{{feature.pascalCase()}}], totalCount: 1),
      ],
      wait: const Duration(milliseconds: 600),
      verify: (bloc) {
        verify(() => repo.readMore(true)).called(1);
        verify(() => repo.readMore()).called(1);
      },
    );
  });
}
