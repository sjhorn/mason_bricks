import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final generateTest =
      context.vars['generate-tests'].toString().toLowerCase().endsWith('true');
  final generateHome =
      context.vars['generate-home'].toString().toLowerCase().endsWith('true');
  if (generateHome) {
    final generateProgress =
        context.logger.progress('Running brick scaffolding_home');
    final testHomeBrick = Brick.git(GitPath(
        'https://github.com/sjhorn/mason_bricks',
        path: 'bricks/scaffolding_home'));

    final generatorHome = await MasonGenerator.fromBrick(testHomeBrick);
    final files = await generatorHome.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: {
        ...context.vars,
        'features': [context.vars['feature']]
      },
      //fileConflictResolution: FileConflictResolution.overwrite,
      logger: context.logger,
    );
    generateProgress.complete();
    context.logger.logFilesGenerated(files.length);
  }
  if (generateTest) {
    final generateProgress =
        context.logger.progress('Running brick scaffolding_test');
    final testBrick = Brick.git(GitPath(
        'https://github.com/sjhorn/mason_bricks',
        path: 'bricks/scaffolding_test'));
    final generatorTest = await MasonGenerator.fromBrick(testBrick);

    final files = await generatorTest.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: context.vars,
      //fileConflictResolution: FileConflictResolution.overwrite,
      logger: context.logger,
    );
    generateProgress.complete();
    context.logger.logFilesGenerated(files.length);
  }
  if (generateHome && generateTest) {
    final generateProgress =
        context.logger.progress('Running brick scaffolding_home_test');
    final homeTestBrick = Brick.git(GitPath(
        'https://github.com/sjhorn/mason_bricks',
        path: 'bricks/scaffolding_home_test'));
    final generatorHomeTest = await MasonGenerator.fromBrick(homeTestBrick);
    final files = await generatorHomeTest.generate(
      DirectoryGeneratorTarget(Directory.current),
      vars: {
        ...context.vars,
        'features': [context.vars['feature']]
      },
      //fileConflictResolution: FileConflictResolution.overwrite,
      logger: context.logger,
    );
    generateProgress.complete();
    context.logger.logFilesGenerated(files.length);
  }
}

// Taken from mason make command
extension on Logger {
  void logFilesGenerated(int fileCount) {
    if (fileCount == 1) {
      this
        ..info(
          '${lightGreen.wrap('✓')} '
          'Generated $fileCount file:',
        )
        ..flush((message) => info(darkGray.wrap(message)));
    } else {
      this
        ..info(
          '${lightGreen.wrap('✓')} '
          'Generated $fileCount file(s):',
        )
        ..flush((message) => info(darkGray.wrap(message)));
    }
  }
}
