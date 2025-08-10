import 'dart:io';
import 'dart:convert';

String joinPaths(List<String> parts) {
  final sep = Platform.pathSeparator;
  return parts.join(sep);
}

String normalizePath(String path) => path.replaceAll('\\', '/');

Future<void> main() async {
  final dirs = _findAndroidDirectories();
  final patched = <String>[];
  final skippedExisting = <String>[];
  final skippedMissingManifest = <String>[];
  final skippedMissingBuild = <String>[];
  final skippedMissingPackage = <String>[];

  for (final dir in dirs) {
    final dirPath = dir.path;
    stdout.writeln('INFO: Prüfe $dirPath');

    final manifest = _findManifest(dir);
    if (manifest == null) {
      stdout.writeln('WARN: Kein AndroidManifest gefunden, überspringe');
      skippedMissingManifest.add(dirPath);
      continue;
    }

    final pkg = _extractPackage(manifest);
    if (pkg == null) {
      stdout.writeln('WARN: package-Attribut nicht gefunden, überspringe');
      skippedMissingPackage.add(dirPath);
      continue;
    }

    final buildFile = _findBuildFile(dir);
    if (buildFile == null) {
      stdout.writeln('WARN: Keine build.gradle oder build.gradle.kts gefunden, überspringe');
      skippedMissingBuild.add(dirPath);
      continue;
    }

    final content = buildFile.readAsStringSync(encoding: utf8);
    final hasNs = RegExp('^\s*namespace(\s*=|\s+["\'])', multiLine: true).hasMatch(content);
    if (hasNs) {
      stdout.writeln('INFO: namespace bereits vorhanden, überspringe');
      skippedExisting.add(dirPath);
      continue;
    }

    final isKts = buildFile.path.endsWith('.kts');
    final updated = _insertNamespace(content, pkg, isKts);
    final backup = File('${buildFile.path}.bak');
    backup.writeAsStringSync(content, encoding: utf8);
    buildFile.writeAsStringSync(updated, encoding: utf8);
    stdout.writeln('INFO: namespace hinzugefügt ($pkg)');
    patched.add(dirPath);
  }

  // Summary
  stdout.writeln('\nZusammenfassung:');
  final total = dirs.length;
  stdout.writeln('Module gefunden : $total');
  stdout.writeln('Patched         : ${patched.length}');
  stdout.writeln('Übersprungen (namespace vorhanden) : ${skippedExisting.length}');
  stdout.writeln('Übersprungen (Manifest fehlt)      : ${skippedMissingManifest.length}');
  stdout.writeln('Übersprungen (build.gradle fehlt)  : ${skippedMissingBuild.length}');
  stdout.writeln('Übersprungen (package fehlt)       : ${skippedMissingPackage.length}');

  if (patched.isNotEmpty) {
    stdout.writeln('\nPatched Pfade:');
    for (final p in patched) {
      stdout.writeln(' - $p');
    }
  }
}

List<Directory> _findAndroidDirectories() {
  final result = <Directory>[];
  final root = Directory.current;
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is Directory) {
      final norm = normalizePath(entity.path);
      if (norm.endsWith('/android')) {
        if (norm.endsWith('/android/app')) continue;
        result.add(entity);
      }
    }
  }

  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  if (home != null) {
    final cachePath = joinPaths([home, '.pub-cache', 'hosted', 'pub.dev']);
    final cacheDir = Directory(cachePath);
    if (cacheDir.existsSync()) {
      for (final pkg in cacheDir.listSync()) {
        if (pkg is Directory) {
          final androidDir = Directory(joinPaths([pkg.path, 'android']));
          if (androidDir.existsSync()) {
            result.add(androidDir);
          }
        }
      }
    }
  }
  return result;
}

File? _findManifest(Directory dir) {
  final candidates = [
    joinPaths([dir.path, 'src', 'main', 'AndroidManifest.xml']),
    joinPaths([dir.path, 'src', 'AndroidManifest.xml']),
  ];
  for (final path in candidates) {
    final f = File(path);
    if (f.existsSync()) return f;
  }
  return null;
}

String? _extractPackage(File manifest) {
  final content = manifest.readAsStringSync(encoding: utf8);
  final match = RegExp(r'package\s*=\s*"([^"]+)"').firstMatch(content);
  return match?.group(1);
}

File? _findBuildFile(Directory dir) {
  final gradle = File(joinPaths([dir.path, 'build.gradle']));
  if (gradle.existsSync()) return gradle;
  final kts = File(joinPaths([dir.path, 'build.gradle.kts']));
  if (kts.existsSync()) return kts;
  return null;
}

String _insertNamespace(String content, String pkg, bool isKts) {
  final nsLine = isKts ? '    namespace = "$pkg"' : '    namespace "$pkg"';
  final androidMatch = RegExp(r'android\s*\{').firstMatch(content);
  if (androidMatch != null) {
    final index = androidMatch.end;
    final after = content.substring(index);
    final prefix = after.startsWith('\n') ? '' : '\n';
    final insert = '${prefix}$nsLine\n';
    return content.substring(0, index) + insert + after;
  } else {
    final block = '\nandroid {\n$nsLine\n}\n';
    return content + block;
  }
}
