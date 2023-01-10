part of 'feature1_read_bloc.dart';

abstract class Feature1ReadEvent {
  const Feature1ReadEvent();
}

class Feature1ReadEventCreate extends Feature1ReadEvent {
  const Feature1ReadEventCreate();
}

class Feature1ReadEventSubscribe extends Feature1ReadEvent {
  const Feature1ReadEventSubscribe();
}

class Feature1ReadEventReload extends Feature1ReadEvent {
  const Feature1ReadEventReload();
}

class Feature1ReadEventReadMore extends Feature1ReadEvent {
  const Feature1ReadEventReadMore();
}

class Feature1ReadEventUpdate extends Feature1ReadEvent {
  final Feature1 feature1;
  const Feature1ReadEventUpdate(this.feature1);
}

class Feature1ReadEventDelete extends Feature1ReadEvent {
  final Feature1 feature1;
  const Feature1ReadEventDelete(this.feature1);
}