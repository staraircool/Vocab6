import 'package:flutter/material.dart';
import '../models/vocabulary_data.dart';

class WordStudyScreen extends StatefulWidget {
  final List<VocabularyWord> words;
  final String title;

  const WordStudyScreen({
    super.key,
    required this.words,
    required this.title,
  });

  @override
  State<WordStudyScreen> createState() => _WordStudyScreenState();
}

class _WordStudyScreenState extends State<WordStudyScreen> {
  int currentIndex = 0;
  bool showDefinition = false;

  @override
  Widget build(BuildContext context) {
    if (widget.words.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            "No words available",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final currentWord = widget.words[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Pronunciation"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shuffle,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Word Study Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pronunciation
                  Text(
                    currentWord.pronunciation ?? "/ʌnˈfɔːrtʃənət/",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Word
                  Text(
                    currentWord.word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Definition
                  Text(
                    currentWord.definition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Synonyms
                  if (currentWord.synonyms.isNotEmpty) ...[
                    const Text(
                      "Synonyms:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: currentWord.synonyms.map((synonym) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            synonym,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Audio Button
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.volume_up,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                
                // Microphone Button
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                
                // Heart Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentWord.isMemorized = !currentWord.isMemorized;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      currentWord.isMemorized ? Icons.favorite : Icons.favorite_border,
                      color: currentWord.isMemorized ? Colors.red : Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: currentIndex > 0 ? () {
                    setState(() {
                      currentIndex--;
                    });
                  } : null,
                  child: const Text(
                    "Previous",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  "${currentIndex + 1} / ${widget.words.length}",
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: currentIndex < widget.words.length - 1 ? () {
                    setState(() {
                      currentIndex++;
                    });
                  } : null,
                  child: const Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

