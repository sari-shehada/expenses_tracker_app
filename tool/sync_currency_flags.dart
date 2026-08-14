import 'dart:convert';
import 'dart:io';

import 'package:expenses_tracker/features/currencies/presentation/currency_flag_assets.dart';

const _circleFlagsRevision = '379588b5da95482d6bbf10bd45644a35b0609ea6';
const _sourceBaseUrl =
    'https://raw.githubusercontent.com/HatScripts/circle-flags/'
    '$_circleFlagsRevision';

Future<void> main() async {
  final currencyFile = File('assets/data/currencies.json');
  final currencies = jsonDecode(await currencyFile.readAsString());
  if (currencies is! Map<String, dynamic>) {
    throw const FormatException('Currency catalog root must be an object.');
  }

  final currencyCodes = currencies.keys.toSet();
  final mappedCurrencyCodes = CurrencyFlagAssets
      .sourceFlagCodeByCurrencyCode
      .keys
      .toSet();
  if (!currencyCodes.containsAll(mappedCurrencyCodes) ||
      !mappedCurrencyCodes.containsAll(currencyCodes)) {
    final missingMappings = currencyCodes.difference(mappedCurrencyCodes);
    final obsoleteMappings = mappedCurrencyCodes.difference(currencyCodes);
    throw StateError(
      'Flag mapping is out of sync. '
      'Missing: $missingMappings; obsolete: $obsoleteMappings',
    );
  }

  final outputDirectory = Directory(CurrencyFlagAssets.directory);
  await outputDirectory.create(recursive: true);

  final entries =
      CurrencyFlagAssets.sourceFlagCodeByCurrencyCode.entries.toList()
        ..sort((first, second) => first.key.compareTo(second.key));
  for (var start = 0; start < entries.length; start += 4) {
    final end = start + 4 < entries.length ? start + 4 : entries.length;
    await Future.wait(
      entries
          .sublist(start, end)
          .map(
            (entry) => _downloadFlag(
              currencyCode: entry.key,
              sourceFlagCode: entry.value,
              outputDirectory: outputDirectory,
            ),
          ),
    );
  }

  await _download(
    Uri.parse('$_sourceBaseUrl/flags/xx.svg'),
    File(CurrencyFlagAssets.fallbackAssetPath),
  );
  await _download(
    Uri.parse('$_sourceBaseUrl/LICENSE.md'),
    File('${CurrencyFlagAssets.directory}/LICENSE.md'),
  );

  stdout.writeln(
    'Downloaded ${entries.length} currency flags and the fallback asset '
    'from Circle Flags revision $_circleFlagsRevision.',
  );
}

Future<void> _downloadFlag({
  required String currencyCode,
  required String sourceFlagCode,
  required Directory outputDirectory,
}) async {
  var uri = Uri.parse('$_sourceBaseUrl/flags/$sourceFlagCode.svg');

  for (var redirects = 0; redirects < 5; redirects++) {
    final bytes = await _fetch(uri);
    final contents = utf8.decode(bytes);
    if (contents.contains('<svg')) {
      await File(
        '${outputDirectory.path}/${currencyCode.toLowerCase()}.svg',
      ).writeAsBytes(bytes, flush: true);
      return;
    }

    final symlinkTarget = contents.trim();
    if (!RegExp(r'^[a-z0-9_-]+\.svg$').hasMatch(symlinkTarget)) {
      throw FormatException('Downloaded flag is not an SVG: $uri');
    }
    uri = uri.resolve(symlinkTarget);
  }

  throw StateError('Too many symlink redirects while downloading $uri');
}

Future<void> _download(Uri uri, File destination) async {
  final bytes = await _fetch(uri);
  await destination.writeAsBytes(bytes, flush: true);
}

Future<List<int>> _fetch(Uri uri) async {
  for (var attempt = 1; attempt <= 4; attempt++) {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Failed to download $uri: HTTP ${response.statusCode}',
          uri: uri,
        );
      }

      return await response.fold<List<int>>(
        <int>[],
        (buffer, chunk) => buffer..addAll(chunk),
      );
    } catch (_) {
      if (attempt == 4) {
        rethrow;
      }
    } finally {
      client.close(force: true);
    }

    await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
  }

  throw StateError('Failed to download $uri');
}
