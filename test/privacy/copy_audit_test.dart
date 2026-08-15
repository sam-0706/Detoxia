import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Lightweight copy audit that scans presentation-layer source files
/// for visible copy terms that conflict with Detoxia V1 product direction.
///
/// This test guards against regression, not exhaustive audit.
void main() {
  final libRoot = Directory('lib/presentation');

  final bannedPhrases = <String>[
    'clean days',
    'clean streak',
    'clean night',
    'streak broken',
    'broken streak',
    'high-risk',
    'High-risk',
    'relapse',
    'Relapse',
    'setbacks',
    'Setbacks',
    'gave in',
    'lost control',
    'addiction',
    'addict',
    'self-control',
    'Self-control',
    'Self-Control',
    'incognito',
    'hard block',
    'surveillance',
    'Surveillance',
  ];

  group('Copy audit — presentation layer', () {
    for (final phrase in bannedPhrases) {
      test('presentation files must not contain "$phrase"', () {
        final files = libRoot
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'))
            .where((f) => !f.path.endsWith('.g.dart'));

        final violations = <String>[];
        for (final file in files) {
          final lines = file.readAsLinesSync();
          var inDisclaimerBlock = false;
          for (var i = 0; i < lines.length; i++) {
            // Track "What Detoxia will not do" disclaimer blocks
            // (these intentionally mention terms like "hard block", "incognito",
            // "surveillance" as things Detoxia does NOT do)
            if (lines[i].contains('What Detoxia will not do') ||
                lines[i].contains('will not do')) {
              inDisclaimerBlock = true;
              continue;
            }
            if (inDisclaimerBlock && lines[i].trimRight().endsWith('],')) {
              inDisclaimerBlock = false;
              continue;
            }
            if (inDisclaimerBlock) continue;

            // Skip comment-only lines
            final trimmed = lines[i].trimLeft();
            if (trimmed.startsWith('//') || trimmed.startsWith('/*') || trimmed.startsWith('*')) {
              continue;
            }
            if (lines[i].contains(phrase)) {
              // Only flag string literals (avoid internal enum/variable names)
              if (lines[i].contains("'$phrase") ||
                  lines[i].contains('"$phrase') ||
                  lines[i].contains("' ${phrase}") ||
                  lines[i].contains('" $phrase')) {
                // extra safety: skip test files
                if (file.path.contains('test/')) continue;
                violations.add('${file.path}:${i + 1}: ${lines[i].trim()}');
              }
            }
          }
        }

        expect(
          violations,
          isEmpty,
          reason: 'Found "$phrase" in presentation files:\n${violations.join('\n')}',
        );
      });
    }
  });
}
