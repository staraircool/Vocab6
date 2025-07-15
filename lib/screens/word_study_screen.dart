import 'package:flutter/material.dart';
import '../models/vocabulary_data.dart';

class WordStudyScreen extends StatefulWidget {
  final List<VocabularyWord> words;
  final String title;
  final VoidCallback? onProgressUpdate;

  const WordStudyScreen({
    super.key,
    required this.words,
    required this.title,
    this.onProgressUpdate,
  });

  @override
  State<WordStudyScreen> createState() => _WordStudyScreenState();
}

class _WordStudyScreenState extends State<WordStudyScreen> {
  late List<VocabularyWord> shuffledWords;
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Shuffle words every time the screen is opened
    shuffledWords = List.from(widget.words);
    shuffledWords.shuffle();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _toggleMemorized() {
    setState(() {
      shuffledWords[currentIndex].isMemorized = !shuffledWords[currentIndex].isMemorized;
    });
    // Call the callback to update progress on home screen
    if (widget.onProgressUpdate != null) {
      widget.onProgressUpdate!();
    }
  }

  void _shuffleWords() {
    setState(() {
      shuffledWords.shuffle();
      currentIndex = 0;
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shuffledWords.isEmpty) {
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Pronunciation"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: _shuffleWords,
            child: Container(
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
          ),
        ],
      ),
      body: Column(
        children: [
          // Word Study Cards with PageView for swipe functionality
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: shuffledWords.length,
              itemBuilder: (context, index) {
                final currentWord = shuffledWords[index];
                return Container(
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
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            currentWord.definition,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      
                      // Synonyms
                      if (currentWord.synonyms.isNotEmpty) ...[
                        const SizedBox(height: 24),
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
                );
              },
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
                  onTap: _toggleMemorized,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      shuffledWords[currentIndex].isMemorized ? Icons.favorite : Icons.favorite_border,
                      color: shuffledWords[currentIndex].isMemorized ? Colors.red : Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation and Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Swipe instruction
                const Text(
                  "Swipe left or right to navigate",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${currentIndex + 1} / ${shuffledWords.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress bar
                LinearProgressIndicator(
                  value: (currentIndex + 1) / shuffledWords.length,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

