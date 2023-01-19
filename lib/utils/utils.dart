import 'dart:io';

import '../methods.dart';

/// Function that append to the dictionary the country names and capital from capitales.csv
void cleanCsv({bool force = false, MethodLocal local = MethodLocal.fr}) async {
  if (!File(local.cleanWordsPath).existsSync() || force) {
    List<String> cleanCapitalesNames = getCountries(local);

    if (File(local.cleanWordsPath).existsSync()) {
      File(local.cleanWordsPath).deleteSync();
    }
    final wordsFile = File(local.wordsPath);
    final wordsFileClean = File(local.cleanWordsPath);
    wordsFileClean.writeAsStringSync(
      await wordsFile.readAsString(),
      mode: FileMode.append,
    );

    var newFileString = await wordsFile.readAsString();
    newFileString = newFileString.substring(0, newFileString.length - 1);

    newFileString = '$newFileString,';
    newFileString = '$newFileString${cleanCapitalesNames.join()}';
    newFileString = newFileString.substring(0, newFileString.length - 2);
    newFileString = '$newFileString]';
    wordsFileClean.writeAsStringSync(newFileString, mode: FileMode.write);
  }
}

/// Return list of countries and capitals, depending of the local used.
List<String> getCountries(MethodLocal local) {
  final capitalesFile = File(local.countriesPath);
  final capitalesLines = capitalesFile.readAsLinesSync();
  capitalesLines.removeAt(0);
  final capitalesLinesSplit =
      capitalesLines.map((line) => line.split(local.countryColumnSplit));
  List<String> cleanCapitalesNames = [];
  if (local == MethodLocal.fr) {
    // french_countries.csv header = NOM;NOM_ALPHA;CODE;ARTICLE;NOM_LONG;CAPITALE
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
  } else if (local == MethodLocal.en) {
    //english_countries.csv header = "country","capital","type"
    List<String> cleanCapitalesNames = [];
    for (var line in capitalesLinesSplit) {
      final country = line.first;
      final capital = line[1];
      if (country.isNotEmpty) {
        cleanCapitalesNames.add('"$country",\r');
      }
      if (capital.isNotEmpty) {
        cleanCapitalesNames.add('"$capital",\r');
      }
    }
  }
  return cleanCapitalesNames;
}
