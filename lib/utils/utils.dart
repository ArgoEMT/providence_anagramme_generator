import 'dart:io';

import '../methods.dart';

/// Function that append to the dictionary the country names and capital from capitales.csv
Future cleanCsv(
    {bool force = false, MethodLocal local = MethodLocal.fr}) async {
  final fileExists = await File(local.cleanWordsPath).exists();
  if (!fileExists || force) {
    List<String> cleanCapitalesNames = getCountries(local);
    if (File(local.cleanWordsPath).existsSync()) {
      File(local.cleanWordsPath).deleteSync();
    }

    final wordsFile = File(local.wordsPath);
    final wordsFileClean = await File(local.cleanWordsPath).create();
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

/// Check illegal characters in a word
/// Return true if the word contains illegal characters
/// Return false if the word doesn't contain illegal characters
bool checkForIllegalCharacters(String word) {
  final illegalList = [
    '!',
    '"',
    '#',
    '\$',
    '%',
    '&',
    '\'',
    '(',
    ')',
    '*',
    '+',
    ',',
    '-',
    '.',
    '/',
    ':',
    ';',
    '<',
    '=',
    '>',
    '?',
    '@',
    '[',
    '\\',
    ']',
    '^',
    ' ',
    '_',
    '`',
    '{',
    '|',
    '}',
    '~',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];
  for (var i = 0; i < word.length; i++) {
    if (illegalList.contains(word[i])) return true;
  }
  return false;
}

/// Get a word from the console
String? getWordFromConsole({bool forceCheck = false}) {
  String? word = stdin.readLineSync();
  if (forceCheck) {
    if (word == null) throw Exception('No word entered');

    if (word.contains(' ')) {
      throw Exception('Please enter only one word');
    }

    if (checkForIllegalCharacters(word)) {
      throw Exception('Please enter a word with letters only');
    }
  }

  return word;
}

/// Get a word from the console and convert it to bool
bool wordToBool(String? consoleWord) {
  if (consoleWord != null) consoleWord = consoleWord.toLowerCase();
  if (consoleWord == 'y') return true;
  return false;
}
