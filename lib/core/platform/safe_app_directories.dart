import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath;

/// Resolves a writable app-private directory for the SQLite database.
Future<Directory> safeAppDocumentsDirectory() async {
  // 1) Standard Flutter documents dir (iOS + Android)
  try {
    final dir = await getApplicationDocumentsDirectory();
    await _ensureDir(dir);
    return dir;
  } catch (e, st) {
    debugPrint('getApplicationDocumentsDirectory failed: $e\n$st');
  }

  // 2) Application support dir
  try {
    final dir = await getApplicationSupportDirectory();
    await _ensureDir(dir);
    return dir;
  } catch (e, st) {
    debugPrint('getApplicationSupportDirectory failed: $e\n$st');
  }

  // 3) Android: sqflite's databases path is always app-writable
  if (Platform.isAndroid) {
    try {
      final dbPath = await getDatabasesPath();
      final dir = Directory(dbPath);
      await _ensureDir(dir);
      return dir;
    } catch (e, st) {
      debugPrint('getDatabasesPath failed: $e\n$st');
    }
  }

  // 4) iOS simulator fallback when path_provider FFI fails
  if (Platform.isIOS) {
    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) {
      final dir = Directory('$home/Documents');
      await _ensureDir(dir);
      return dir;
    }
  }

  throw StateError(
    'Could not resolve a writable app directory for the database.',
  );
}

Future<void> _ensureDir(Directory dir) async {
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
}
