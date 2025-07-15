import 'package:flutter/material.dart';
import '../models/vocabulary_data.dart';
import '../widgets/progress_card.dart';
import '../widgets/learning_card.dart';
import 'word_study_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await VocabularyData.loadData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Progress Card
              ProgressCard(
                greeting: "Hi, Learner",
                memorizedToday: VocabularyData.memorizedToday,
                totalWords: VocabularyData.totalWordsToday,
                progressPercentage: VocabularyData.progressPercentage,
              ),
              
              const SizedBox(height: 20),
              
              // Statistics Label
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your statistics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Learning Cards Stack
              Expanded(
                child: Stack(
                  children: [
                    // Bottom Card - Repeat all words (White)
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: LearningCard(
                        title: "Repeat all words",
                        subtitle: "${VocabularyData.allWords.length} words",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordStudyScreen(
                                words: VocabularyData.allWords,
                                title: "Repeat all words",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Middle Card - Free-hand mode (Lavender)
                    Positioned(
                      top: 40,
                      left: 0,
                      right: 0,
                      child: LearningCard(
                        title: "Free-hand mode",
                        subtitle: "${VocabularyData.freeHandWords.length} words",
                        backgroundColor: const Color(0xFFB19CD9),
                        textColor: Colors.white,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordStudyScreen(
                                words: VocabularyData.freeHandWords,
                                title: "Free-hand mode",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Top Card - Learn new words (Dark Blue)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LearningCard(
                        title: "Learn new words",
                        subtitle: "${VocabularyData.learnNewWords.length} words",
                        backgroundColor: const Color(0xFF6366F1),
                        textColor: Colors.white,
                        showContinueButton: true,
                        progress: "13/20",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordStudyScreen(
                                words: VocabularyData.learnNewWords,
                                title: "Learn new words",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

