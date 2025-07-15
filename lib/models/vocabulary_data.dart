import '../services/csv_loader.dart';

class VocabularyWord {
  final String word;
  final String definition;
  final String? pronunciation;
  final List<String> synonyms;
  bool isMemorized;

  VocabularyWord({
    required this.word,
    required this.definition,
    this.pronunciation,
    this.synonyms = const [],
    this.isMemorized = false,
  });

  factory VocabularyWord.fromCsv(String csvLine) {
    final parts = csvLine.split(',');
    if (parts.length >= 2) {
      return VocabularyWord(
        word: parts[0].trim(),
        definition: parts[1].trim().replaceAll('"', ''),
      );
    }
    throw Exception('Invalid CSV format');
  }
}

class VocabularyData {
  static List<VocabularyWord> _learnNewWords = [];
  static List<VocabularyWord> _freeHandWords = [];
  static List<VocabularyWord> _allWords = [];
  static bool _isLoaded = false;

  static Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      // Load data from CSV files
      final vocab1Words = await CsvLoader.loadWordsFromCsv('assets/data/Vocabfile1.csv');
      final vocab2Words = await CsvLoader.loadWordsFromCsv('assets/data/Vocab2.csv');
      final words200 = await CsvLoader.loadWordsFromCsv('assets/data/200words.csv');

      // Top card - Learn new words (first two files)
      _learnNewWords = [...vocab1Words, ...vocab2Words];
      
      // Middle card - Free-hand mode (200 words file)
      _freeHandWords = words200;
      
      // Bottom card - All words (all files combined)
      _allWords = [...vocab1Words, ...vocab2Words, ...words200];
      
      // Remove duplicates from all words
      final Map<String, VocabularyWord> uniqueWords = {};
      for (final word in _allWords) {
        uniqueWords[word.word.toLowerCase()] = word;
      }
      _allWords = uniqueWords.values.toList();
      
      _isLoaded = true;
    } catch (e) {
      // Handle error silently and fallback to default data
      _loadDefaultData();
    }
  }

  static void _loadDefaultData() {
    _learnNewWords = [
      VocabularyWord(
        word: "Abate",
        definition: "To reduce in degree or intensity. Often used for things like storms, fears, or emotions.",
        synonyms: ["diminish", "decrease", "subside"],
      ),
      VocabularyWord(
        word: "Abhor",
        definition: "To regard with extreme dislike or hatred. A stronger form of 'dislike'.",
        synonyms: ["detest", "loathe", "despise"],
      ),
      VocabularyWord(
        word: "Adept",
        definition: "Highly skilled or proficient at something. Often used to describe a person's abilities.",
        synonyms: ["skilled", "proficient", "expert"],
      ),
      VocabularyWord(
        word: "Adorn",
        definition: "To make more beautiful or attractive. Commonly used for decorating objects or people.",
        synonyms: ["decorate", "embellish", "beautify"],
      ),
      VocabularyWord(
        word: "Aesthetic",
        definition: "Concerned with beauty or the appreciation of beauty. Related to visual appeal.",
        synonyms: ["artistic", "beautiful", "pleasing"],
      ),
    ];

    _freeHandWords = [
      VocabularyWord(
        word: "Unfortunate",
        definition: "The unfortunate turn of events did not stop me",
        synonyms: ["unlucky", "failed", "attempted"],
      ),
      VocabularyWord(
        word: "Agile",
        definition: "Able to move quickly and easily. Can also refer to mental sharpness.",
        synonyms: ["nimble", "quick", "flexible"],
      ),
      VocabularyWord(
        word: "Alleviate",
        definition: "To ease a pain or burden. Often used in medical or emotional contexts.",
        synonyms: ["relieve", "ease", "reduce"],
      ),
    ];

    _allWords = [
      ..._learnNewWords,
      ..._freeHandWords,
      VocabularyWord(
        word: "Ameliorate",
        definition: "To make something that is bad or unsatisfactory better. A formal improvement.",
        synonyms: ["improve", "enhance", "better"],
      ),
      VocabularyWord(
        word: "Amiable",
        definition: "Friendly and pleasant in manner. Often used to describe personalities.",
        synonyms: ["friendly", "pleasant", "agreeable"],
      ),
    ];
    
    _isLoaded = true;
  }

  static List<VocabularyWord> get learnNewWords => _learnNewWords;
  static List<VocabularyWord> get freeHandWords => _freeHandWords;
  static List<VocabularyWord> get allWords => _allWords;

  static int get memorizedToday {
    int count = 0;
    for (final word in _allWords) {
      if (word.isMemorized) count++;
    }
    return count;
  }
  static int get totalWordsToday => 20;
  static double get progressPercentage => memorizedToday / totalWordsToday;
}

