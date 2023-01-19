import 'dart:io';

import 'package:providence_anagramme_generator/utils/utils.dart';

import 'utils/files_names.dart';

enum MethodLocal {
  fr,
  en;

  String get wordsPath {
    switch (this) {
      case MethodLocal.fr:
        return frenchWords;
      case MethodLocal.en:
        return englishWords;
    }
  }

  String get countriesPath {
    switch (this) {
      case MethodLocal.fr:
        return frenchCountries;
      case MethodLocal.en:
        return englishCountries;
    }
  }

  String get cleanWordsPath {
    switch (this) {
      case MethodLocal.fr:
        return frenchCleanWords;
      case MethodLocal.en:
        return englishCleanWords;
    }
  }

  String get countryColumnSplit {
    switch (this) {
      case MethodLocal.fr:
        return ';';
      case MethodLocal.en:
        return ',';
    }
  }
}



/// Generate all anagrams of a word
List<String> generateAnagrams(String word) {
  List<String> anagrams = [];
  if (word.length == 1) {
    anagrams.add(word);
    return anagrams;
  }
  if (word.isEmpty) return anagrams;

  word = word.toLowerCase();
  for (var i = 0; i < word.length; i++) {
    final char = word[i];
    final remainingChars = word.substring(0, i) + word.substring(i + 1);
    final remainingAnagrams = generateAnagrams(remainingChars);
    for (var anagram in remainingAnagrams) {
      if (anagrams.contains(char + anagram)) continue;
      anagrams.add(char + anagram);
    }
  }
  return anagrams;
}

/// Check if anagrams exist in the dictionary and return a list of anagrams that exist
List<String> anagramsThatExistInDictionary(
  List<String> anagrams, [
  MethodLocal local = MethodLocal.fr,
]) {
  final dictionaryFile = File(local.cleanWordsPath);
  final dictionary = clearDictionary(dictionaryFile.readAsLinesSync());
  List<String> anagramsThatExist = [];
  for (var anagram in anagrams) {
    if (anagramsThatExist.contains(anagram)) continue;
    if (dictionary.contains(anagram)) anagramsThatExist.add(anagram);
  }
  return anagramsThatExist;
}

/// Clear a file import from a json to remove " , \r and spaces and make it lowercase
List<String> clearDictionary(List<String> dictionary) {
  for (var i = 0; i < dictionary.length; i++) {
    dictionary[i] = dictionary[i].replaceAll('"', '');
    dictionary[i] = dictionary[i].replaceAll(',', '');
    dictionary[i] = dictionary[i].replaceAll(' ', '');
    dictionary[i] = dictionary[i].replaceAll('\r', '');
    dictionary[i] = dictionary[i].toLowerCase();
  }
  return dictionary;
}

