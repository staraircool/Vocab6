import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/vocabulary_data.dart';

class CsvLoader {
  static Future<List<VocabularyWord>> loadWordsFromCsv(String assetPath) async {
    try {
      final String csvString = await rootBundle.loadString(assetPath);
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);
      
      // Skip header row
      final List<VocabularyWord> words = [];
      for (int i = 1; i < csvData.length; i++) {
        if (csvData[i].length >= 2) {
          final word = csvData[i][0].toString().trim();
          final definition = csvData[i][1].toString().trim().replaceAll('"', '');
          
          if (word.isNotEmpty && definition.isNotEmpty) {
            words.add(VocabularyWord(
              word: word,
              definition: definition,
              synonyms: _generateSynonyms(word),
            ));
          }
        }
      }
      
      return words;
    } catch (e) {
      // Handle error silently and return empty list
      return [];
    }
  }
  
  static List<String> _generateSynonyms(String word) {
    // Simple synonym mapping for demo purposes
    final Map<String, List<String>> synonymMap = {
      'abate': ['diminish', 'decrease', 'subside'],
      'abhor': ['detest', 'loathe', 'despise'],
      'adept': ['skilled', 'proficient', 'expert'],
      'adorn': ['decorate', 'embellish', 'beautify'],
      'aesthetic': ['artistic', 'beautiful', 'pleasing'],
      'agile': ['nimble', 'quick', 'flexible'],
      'alleviate': ['relieve', 'ease', 'reduce'],
      'ameliorate': ['improve', 'enhance', 'better'],
      'amiable': ['friendly', 'pleasant', 'agreeable'],
      'unfortunate': ['unlucky', 'failed', 'attempted'],
    };
    
    return synonymMap[word.toLowerCase()] ?? [];
  }
}

