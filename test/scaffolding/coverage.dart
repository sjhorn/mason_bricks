// NOTE: The preferred way is to install lcov and use command `lcov --summary path/to/lcov.info`
// Use this script only if you can't install lcov on your platform.

// Usage: dart coverage.dart path/to/lcov.info

import 'dart:io';

void main(List<String> args) async {
  final lcovFile = args[0];
  final lines = await File(lcovFile).readAsLines();
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
  print(
      'Total test coverage: ${(testedLines / totalLines * 100).toStringAsFixed(2)}%');
}
