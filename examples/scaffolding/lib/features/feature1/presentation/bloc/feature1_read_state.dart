part of 'feature1_read_bloc.dart';

abstract class Feature1ReadState extends Equatable {
  final Feature1? selectedFeature1;
  final List<Feature1> feature1s;
  final String message;
  final int totalCount;
  const Feature1ReadState(
      {this.feature1s = const [],
      this.message = '',
      this.selectedFeature1,
      this.totalCount = 0});

  @override
  List<Object?> get props => [selectedFeature1, feature1s, message, totalCount];
}

class Feature1ReadStateInitial extends Feature1ReadState {}

class Feature1ReadStateLoading extends Feature1ReadState {}

class Feature1ReadStateSuccess extends Feature1ReadState {
  const Feature1ReadStateSuccess({super.feature1s, super.totalCount});
}

class Feature1ReadStateCreate extends Feature1ReadState {
  const Feature1ReadStateCreate({super.selectedFeature1});
}

class Feature1ReadStateUpdate extends Feature1ReadState {
  const Feature1ReadStateUpdate({super.selectedFeature1});
}

class Feature1ReadStateDelete extends Feature1ReadState {
  const Feature1ReadStateDelete({super.selectedFeature1});
}

class Feature1ReadStateFailure extends Feature1ReadState {
  const Feature1ReadStateFailure({super.message});
}
