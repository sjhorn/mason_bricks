part of '{{feature}}_read_bloc.dart';

abstract class {{feature.pascalCase()}}ReadState extends Equatable {
  final {{feature.pascalCase()}}? selected{{feature.pascalCase()}};
  final List<{{feature.pascalCase()}}> {{feature}}s;
  final String message;
  final int totalCount;
  const {{feature.pascalCase()}}ReadState(
      {this.{{feature}}s = const [],
      this.message = '',
      this.selected{{feature.pascalCase()}},
      this.totalCount = 0});

  @override
  List<Object?> get props => [selected{{feature.pascalCase()}}, {{feature}}s, message, totalCount];
}

class {{feature.pascalCase()}}ReadStateInitial extends {{feature.pascalCase()}}ReadState {}

class {{feature.pascalCase()}}ReadStateLoading extends {{feature.pascalCase()}}ReadState {}

class {{feature.pascalCase()}}ReadStateSuccess extends {{feature.pascalCase()}}ReadState {
  const {{feature.pascalCase()}}ReadStateSuccess({super.{{feature}}s, super.totalCount});
}

class {{feature.pascalCase()}}ReadStateCreate extends {{feature.pascalCase()}}ReadState {
  const {{feature.pascalCase()}}ReadStateCreate({super.selected{{feature.pascalCase()}}});
}

class {{feature.pascalCase()}}ReadStateUpdate extends {{feature.pascalCase()}}ReadState {
  const {{feature.pascalCase()}}ReadStateUpdate({super.selected{{feature.pascalCase()}}});
}

class {{feature.pascalCase()}}ReadStateDelete extends {{feature.pascalCase()}}ReadState {
  const {{feature.pascalCase()}}ReadStateDelete({super.selected{{feature.pascalCase()}}});
}

class {{feature.pascalCase()}}ReadStateFailure extends {{feature.pascalCase()}}ReadState {
  const {{feature.pascalCase()}}ReadStateFailure({super.message});
}
