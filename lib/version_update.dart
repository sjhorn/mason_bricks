import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_extension/yaml_extension.dart';
import 'yaml_writer.dart';

import 'package:path/path.dart' as p;

class SemVer {
  final int major;
  final int minor;
  final int patch;
  final String extra;

  SemVer({
    required this.major,
    required this.minor,
    required this.patch,
    required this.extra,
  });

  SemVer copyWith({
    int? major,
    int? minor,
    int? patch,
    String? extra,
  }) {
    return SemVer(
      major: major ?? this.major,
      minor: minor ?? this.minor,
      patch: patch ?? this.patch,
      extra: extra ?? this.extra,
    );
  }

  @override
  String toString() {
    return '$major.$minor.$patch${extra.isNotEmpty ? "-$extra" : ""}';
  }
}

class VersionUpdate {
  late final SemVer version;
  late final File pubspecYamlFile;
  late final Map<String, dynamic> pubspecYaml;
  final Map<File, Map> _brickMap = {};

  // Read current version from pubspec.yaml eg. 0.0.5
  // Ask to 1) move to dev 2) update patch, 3) update minor 4) update major
  // [1234]?
  // If 2-4 then ask for changelog comment
  // If 1 then add -dev
  // Write to pubspec.yaml, each brick.yaml and CHANGELOG.md

  VersionUpdate(Directory rootDir) {
    _getBrickMap(rootDir);
  }

  _getBrickMap(Directory rootDir) {
    pubspecYamlFile = File('${rootDir.path}/pubspec.yaml');
    final masonYamlFile = File('${rootDir.path}/mason.yaml');
    final YamlMap pubspec = loadYaml(pubspecYamlFile.readAsStringSync());
    version = _readVersion(pubspec);
    pubspecYaml = pubspec.toMap();

    YamlMap masonYaml = loadYaml(masonYamlFile.readAsStringSync());
    for (final entry in masonYaml['bricks'].entries) {
      final brickYamlFile =
          File('${Directory.current.path}/${entry.value["path"]}/brick.yaml');
      final brickYaml = brickYamlFile.readAsStringSync();
      _brickMap[brickYamlFile] = (loadYaml(brickYaml) as YamlMap).toMap();
    }
  }

  SemVer _readVersion(YamlMap masonYaml) {
    String versionString = masonYaml['version'];
    List<String> semVerParts = versionString.split('.');
    List<String> patchExtra = semVerParts[2].split('-');

    return SemVer(
      major: int.parse(semVerParts[0]),
      minor: int.parse(semVerParts[1]),
      patch: int.parse(patchExtra[0]),
      extra: semVerParts.length == 2 ? semVerParts[1] : '',
    );
  }

  void update(String newVersion, String changeLog) {
    pubspecYaml['version'] = newVersion;
    pubspecYamlFile.writeAsStringSync(
      YAMLWriter(allowUnquotedStrings: true).write(pubspecYaml),
    );

    for (final entry in _brickMap.entries) {
      Map map = entry.value;
      map['version'] = newVersion;

      File brickYamlFile = entry.key;
      File changeLogFile =
          File('${p.dirname(brickYamlFile.path)}/CHANGELOG.md');

      brickYamlFile
          .writeAsStringSync(YAMLWriter(allowUnquotedStrings: true).write(map));
      StringBuffer existingLog = StringBuffer();
      existingLog.write(changeLogFile.readAsStringSync());
      changeLogFile.writeAsStringSync('''
$newVersion
$changeLog
${existingLog.toString()}
''');
    }
  }
}
