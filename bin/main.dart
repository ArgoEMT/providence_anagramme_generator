import 'package:providence_anagramme_generator/methods.dart';
import 'package:providence_anagramme_generator/utils/utils.dart';

Future main(List<String> arguments) async {
  print('------------------------------------');
  print('Welcome to the Providence Anagramme Generator');
  print('------------------------------------');
  print('Do you want to force the files generation ? (y/n)');
  final forceGeneration = wordToBool(getWordFromConsole());
  print('Generating files...');
  if (forceGeneration) print('Forcing generation');
  await cleanCsv();
  await cleanCsv(local: MethodLocal.en);
  print('Files generated');
  print('------------------------------------');
  print('Please enter a word to generate anagrams:');
  final userWord = getWordFromConsole();
  try {
    checkForIllegalCharacters(userWord!);
  } on Exception catch (e) {
    print(e);
    return;
  }
  print('------------------------------------');
  print('Generating anagrams...');
  final allAnagrams = generateAnagrams(userWord);
  final realFrenchWords = anagramsThatExistInDictionary(allAnagrams);
  final realEnglishWords =
      anagramsThatExistInDictionary(allAnagrams, MethodLocal.en);
  print('Anagrams generated');
  print('------------------------------------');
  print('Anagrams that exist in the French dictionary:');
  if (realFrenchWords.isEmpty) {
    print('No anagrams found in the French dictionary');
  } else {
    print(realFrenchWords);
  }
  print('------------------------------------');
  print('Anagrams that exist in the English dictionary:');
  if (realEnglishWords.isEmpty) {
    print('No anagrams found in the English dictionary');
  } else {
    print(realEnglishWords);
  }
  print('------------------------------------');
}
