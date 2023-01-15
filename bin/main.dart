import 'package:providence_anagramme_generator/methods.dart';
import 'package:providence_anagramme_generator/utils/utils.dart';

void main(List<String> arguments) {
  print('------------------------------------');
  print('Welcome to the Providence Anagramme Generator');
  print('------------------------------------');
  print('Generating files...');
  cleanCsv();
  print('Files generated');
  print('------------------------------------');
  print('Please enter a word to generate anagrams:');
  final userWord = getWordFromConsole();
  try {
    checkForIllegalCharacters(userWord);
  } on Exception catch (e) {
    print(e);
    return;
  }
  print('------------------------------------');
  print('Generating anagrams...');
  final allAnagrams = generateAnagrams(userWord);
  final realWords = anagramsThatExistInDictionary(allAnagrams);
  print('Anagrams generated');
  print('------------------------------------');
  print('Anagrams that exist in the french dictionary:');
  if (realWords.isEmpty) {
    print('No anagrams found in the dictionary');
  } else {
    print(realWords);
  }
  print('------------------------------------');
}
