import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;
  final String features = context.vars['features'];
  if (features.length == 0) {
    logger.alert('You have not specified any features');
    throw Exception();
  }
  List<String> featureList = features.split(',');
  logger.info(lightCyan.wrap('You have the following features: $featureList'));

  context.vars = {
    ...context.vars,
    'features': featureList,
  };
}
