import 'dart:io';

import 'package:mason_bricks/version_update.dart';

void main(List<String> arguments) {
  final versionUpdate = VersionUpdate(Directory.current);

  print('The current version is ${versionUpdate.version}');
  print('Enter the new version ?');
  final newVersion = stdin.readLineSync()!;
  print('Enter the change log entry ?');
  final changeLog = stdin.readLineSync()!;

  print(
      'About to write new version $newVersion with change log:\n$changeLog\nHit enter to continue?');

  stdin.readLineSync();

  versionUpdate.update(newVersion, changeLog);
}
