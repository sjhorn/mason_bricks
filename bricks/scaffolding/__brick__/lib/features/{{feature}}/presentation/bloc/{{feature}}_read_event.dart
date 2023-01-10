part of '{{feature}}_read_bloc.dart';

abstract class {{feature.pascalCase()}}ReadEvent {
  const {{feature.pascalCase()}}ReadEvent();
}

class {{feature.pascalCase()}}ReadEventCreate extends {{feature.pascalCase()}}ReadEvent {
  const {{feature.pascalCase()}}ReadEventCreate();
}

class {{feature.pascalCase()}}ReadEventSubscribe extends {{feature.pascalCase()}}ReadEvent {
  const {{feature.pascalCase()}}ReadEventSubscribe();
}

class {{feature.pascalCase()}}ReadEventReload extends {{feature.pascalCase()}}ReadEvent {
  const {{feature.pascalCase()}}ReadEventReload();
}

class {{feature.pascalCase()}}ReadEventReadMore extends {{feature.pascalCase()}}ReadEvent {
  const {{feature.pascalCase()}}ReadEventReadMore();
}

class {{feature.pascalCase()}}ReadEventUpdate extends {{feature.pascalCase()}}ReadEvent {
  final {{feature.pascalCase()}} {{feature}};
  const {{feature.pascalCase()}}ReadEventUpdate(this.{{feature}});
}

class {{feature.pascalCase()}}ReadEventDelete extends {{feature.pascalCase()}}ReadEvent {
  final {{feature.pascalCase()}} {{feature}};
  const {{feature.pascalCase()}}ReadEventDelete(this.{{feature}});
}