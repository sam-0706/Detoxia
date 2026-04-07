import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Returns the app documents directory, falling back to the iOS sandbox
/// `HOME/Documents` path when `path_provider`'s native channel fails
/// (e.g. `objective_c` FFI missing on certain iOS simulator runtimes).
Future<Directory> safeAppDocumentsDirectory() async {
  try {
    return await getApplicationDocumentsDirectory();
  } catch (e) {
    debugPrint('path_provider failed, using dart:io fallback: $e');
  }

  // Fallback: derive from the process HOME env (works in iOS simulator
  // sandbox and macOS). On Android this path is never reached because
  // path_provider_android doesn't go through objective_c.
  final home = Platform.environment['HOME'];
  if (home != null && home.isNotEmpty) {
    final dir = Directory('$home/Documents');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  // Last resort: current directory (should never happen on mobile).
  return Directory.current;
}
