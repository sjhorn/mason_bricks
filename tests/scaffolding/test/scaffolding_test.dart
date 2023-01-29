import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

class Proc {
  final Stream<String> stream;
  final Future<int> exitCode;
  Proc({
    required this.stream,
    required this.exitCode,
  });
}

class TestLogger extends Logger {
  final logBuffer = StringBuffer();
  final delayedBuffer = StringBuffer();

  @override
  void alert(String? message) => logBuffer.write(message);

  @override
  void info(String? message) => logBuffer.write(message);

  @override
  void warn(String? message, {String tag = 'WARN'}) =>
      logBuffer.write('$tag: $message');

  @override
  void detail(String? message) => logBuffer.write(message);

  @override
  void success(String? message) => logBuffer.write(message);

  @override
  void delayed(String? message) => delayedBuffer.write(message);

  @override
  void flush([Function(String? p1)? print]) =>
      logBuffer.write(delayedBuffer.toString());
}

void main() {
  final workingDir = Directory(p.join(Directory.current.path, 'build'));

  Future<Proc> runProcess(String name, List<String> args) async {
    final process = await Process.start(name, args,
        workingDirectory: workingDir.path, runInShell: true);

    return Proc(
        stream:
            process.stdout.transform(Utf8Decoder()).transform(LineSplitter()),
        exitCode: process.exitCode);
  }

  Future<int> debugRun(String name, List<String> args) async {
    final proc = await runProcess(name, args);
    await for (final line in proc.stream) {
      print(line);
    }
    return proc.exitCode;
  }

  Future<double> testCoverage(File lcovFile) async {
    final lines = await lcovFile.readAsLines();
    final coverage = lines.fold([0, 0], (List<int> data, line) {
      var testedLines = data[0];
      var totalLines = data[1];
      if (line.startsWith('DA')) {
        totalLines++;
        if (!line.endsWith(',0')) {
          testedLines++;
        }
      }
      return [testedLines, totalLines];
    });
    final testedLines = coverage[0];
    final totalLines = coverage[1];

    double percentage = totalLines == 0 ? 100 : testedLines / totalLines * 100;
    print(
        '🧪 Test Coverage $percentage% Lines $totalLines Tested $testedLines');
    return percentage;
  }

  setUpAll(() async {
    await workingDir.create();
  });

  tearDownAll(() async {
    await workingDir.delete(recursive: true);
  });

  makeScaffolingBrick(String brickPath, TestLogger logger) async {
    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);

    Map<String, dynamic> preGenVars = {};
    await generator.hooks.preGen(
      vars: jsonDecode(File('config.json').readAsStringSync()),
      logger: logger,
      onVarsChanged: (vars) => preGenVars = vars,
    );
    await generator.generate(
      DirectoryGeneratorTarget(workingDir),
      vars: preGenVars,
      logger: logger,
      fileConflictResolution: FileConflictResolution.overwrite,
    );
    await generator.hooks.postGen(vars: preGenVars, logger: logger);
    logger.flush();
  }

  makeScaffolding(TestLogger logger) async {
    final brickPath = p.absolute(p.normalize(p.join(
      Directory.current.path,
      '..',
      '..',
      'bricks',
      'scaffolding',
    )));
    await makeScaffolingBrick(brickPath, logger);
  }

  makeScaffoldingHome(TestLogger logger) async {
    final brickPath = p.absolute(p.normalize(p.join(
      Directory.current.path,
      '..',
      '..',
      'bricks',
      'scaffolding_home',
    )));
    await makeScaffolingBrick(brickPath, logger);
  }

  makeScaffoldingTest(TestLogger logger) async {
    final brickPath = p.absolute(p.normalize(p.join(
      Directory.current.path,
      '..',
      '..',
      'bricks',
      'scaffolding_test',
    )));
    await makeScaffolingBrick(brickPath, logger);
  }

  makeScaffoldingHomeTest(TestLogger logger) async {
    final brickPath = p.absolute(p.normalize(p.join(
      Directory.current.path,
      '..',
      '..',
      'bricks',
      'scaffolding_home_test',
    )));
    await makeScaffolingBrick(brickPath, logger);
  }

  Future<int> flutterRemoveSkeletonTests() async {
    Directory testDir = Directory(p.join(workingDir.path, 'test'));
    await testDir.delete(recursive: true);
    await testDir.create();
    return ExitCode.success.code;
  }

  Future<int> flutterCreate() async => await debugRun('flutter', [
        'create',
        '.',
        '--template=skeleton',
        '--project-name=scaffolding_sample'
      ]);

  Future<int> flutterPubAdd() async => await debugRun('flutter', [
        'pub',
        'add',
        'equatable',
        'uuid',
        'flutter_bloc',
      ]);

  Future<int> flutterPubAddDev() async => await debugRun('flutter', [
        'pub',
        'add',
        'bloc_test',
        'mocktail',
        '--dev',
      ]);

  Future<int> flutterTestCoverage() async => await debugRun('flutter', [
        'test',
        '--coverage',
      ]);

  test('mason make scaffolding', () async {
    TestLogger logger = TestLogger();

    expect(await makeScaffolding(logger), equals(null),
        reason: '🪲 makeScaffolding failed');

    expect(logger.logBuffer.toString(),
        contains('lib/features/feature1/feature1.dart'));

    expect(
      File(
        p.join(
          workingDir.path,
          'lib',
          'features',
          'feature1',
          'domain',
          'feature1.dart',
        ),
      ).existsSync(),
      equals(true),
      reason: 'Domain dart was not correctly generated',
    );
  });

  test('mason make scaffolding_home', () async {
    TestLogger logger = TestLogger();

    expect(
      await makeScaffoldingHome(logger),
      equals(null),
      reason: '🪲 makeScaffoldingHome failed',
    );

    expect(
      logger.logBuffer.toString(),
      contains('lib/scaffold_app.dart'),
    );

    expect(
      File(
        p.join(
          workingDir.path,
          'lib',
          'scaffold_app.dart',
        ),
      ).existsSync(),
      equals(true),
      reason: '🪲 scaffold_app dart was not correctly generated',
    );
  });
  test('mason make scaffolding_test', () async {
    TestLogger logger = TestLogger();

    expect(
      await makeScaffoldingTest(logger),
      equals(null),
      reason: '🪲 makeScaffoldingTest failed',
    );

    expect(
      logger.logBuffer.toString(),
      contains('test/features/feature1/domain/feature1_test.dart'),
    );

    expect(
      File(
        p.join(
          workingDir.path,
          'test',
          'features',
          'feature1',
          'domain',
          'feature1_test.dart',
        ),
      ).existsSync(),
      equals(true),
      reason: '🪲 feature1_test dart was not correctly generated',
    );
  });
  test('mason make scaffolding_home_test', () async {
    TestLogger logger = TestLogger();

    expect(
      await makeScaffoldingHomeTest(logger),
      equals(null),
      reason: '🪲 makeScaffoldingHomeTest failed',
    );

    expect(
      logger.logBuffer.toString(),
      contains(
        'test/scaffold_app_test.dart',
      ),
    );

    expect(
      File(
        p.join(
          workingDir.path,
          'test',
          'scaffold_app_test.dart',
        ),
      ).existsSync(),
      equals(true),
      reason: '🪲 scaffold_app_test dart was not correctly generated',
    );
  });

  test('flutter create tests', () async {
    expect(await flutterCreate(), equals(ExitCode.success.code),
        reason: '🪲 Flutter create failed');

    expect(await flutterPubAdd(), equals(ExitCode.success.code),
        reason: '🪲 Flutter pub add failed');

    expect(await flutterPubAddDev(), equals(ExitCode.success.code),
        reason: '🪲 Flutter pub add --dev failed');

    expect(await flutterRemoveSkeletonTests(), equals(ExitCode.success.code),
        reason: '🪲 Flutter remove skeleton tests failed');
  });

  test('mason make + flutter and tests', () async {
    await flutterCreate();
    await flutterPubAdd();
    await flutterPubAddDev();
    await flutterRemoveSkeletonTests();

    TestLogger logger = TestLogger();
    await makeScaffolding(logger);
    await makeScaffoldingHome(logger);
    await makeScaffoldingTest(logger);
    await makeScaffoldingHomeTest(logger);

    await flutterTestCoverage();
    expect(
        await testCoverage(File(p.join(
          workingDir.path,
          'coverage',
          'lcov.info',
        ))),
        equals(100),
        reason: '🪲 Failed to make and compile with 100% coverage');
  }, timeout: Timeout(Duration(seconds: 60)));
}
