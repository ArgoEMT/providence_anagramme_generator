import 'dart:io';

/// Function that append to the dictionary the country names and capital from capitales.csv
void cleanCsv([bool force = false]) async {
  // capitales.csv header = NOM;NOM_ALPHA;CODE;ARTICLE;NOM_LONG;CAPITALE
  if (!File('lib/resources/words_clean.json').existsSync() || force) {
    final capitalesFile = File('lib/resources/capitales.csv');
    final capitalesLines = capitalesFile.readAsLinesSync();
    capitalesLines.removeAt(0);

    final capitalesLinesSplit = capitalesLines.map((line) => line.split(';'));
    List<String> cleanCapitalesNames = [];
    for (var line in capitalesLinesSplit) {
      final country = line.first;
      final capital = line.last;
      if (country.isNotEmpty) {
        cleanCapitalesNames.add('"$country",\r');
      }
      if (capital.isNotEmpty) {
        cleanCapitalesNames.add('"$capital",\r');
      }
    }

    if (File('lib/resources/words_clean.json').existsSync()) {
      File('lib/resources/words_clean.json').deleteSync();
    }
    final wordsFile = File('lib/resources/words.json');
    final wordsFileClean = File('lib/resources/words_clean.json');
    wordsFileClean.writeAsStringSync(await wordsFile.readAsString(),
        mode: FileMode.append);

    var newFileString = await wordsFile.readAsString();
    newFileString = newFileString.substring(0, newFileString.length - 1);

    newFileString = '$newFileString,';
    newFileString = '$newFileString${cleanCapitalesNames.join()}';
    newFileString = newFileString.substring(0, newFileString.length - 2);
    newFileString = '$newFileString]';
    wordsFileClean.writeAsStringSync(newFileString, mode: FileMode.write);
  }
}
