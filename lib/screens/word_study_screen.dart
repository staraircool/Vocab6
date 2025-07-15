import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../models/vocabulary_data.dart';
import '../services/ad_service.dart';

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

class _WordStudyScreenState extends State<WordStudyScreen> with WidgetsBindingObserver {
  late List<VocabularyWord> shuffledWords;
  int currentIndex = 0;
  PageController pageController = PageController();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Shuffle words every time the screen is opened
    shuffledWords = List.from(widget.words);
    shuffledWords.shuffle();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Show interstitial ad when app is paused or closed
      AdService.showInterstitialAd(_interstitialAd);
    }
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd();
    _bannerAd!.load().then((_) {
      setState(() {
        _isBannerAdReady = true;
      });
    });
  }

  Future<void> _loadInterstitialAd() async {
    _interstitialAd = await AdService.createInterstitialAd();
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

  Future<bool> _onWillPop() async {
    // Show interstitial ad when user presses back button
    AdService.showInterstitialAd(_interstitialAd, onAdClosed: () {
      Navigator.of(context).pop();
    });
    return false; // Prevent default back navigation
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

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Pronunciation"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _onWillPop();
            },
          ),
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
            // Word Study Cards with PageView for swipe functionality - Reduced height
            Expanded(
              flex: 3, // Reduced from default to make room for banner ad
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
                    padding: const EdgeInsets.all(20), // Reduced padding
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
                            fontSize: 14, // Reduced font size
                          ),
                        ),
                        const SizedBox(height: 12), // Reduced spacing
                        
                        // Word
                        Text(
                          currentWord.word,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28, // Reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12), // Reduced spacing
                        
                        // Definition
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              currentWord.definition,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14, // Reduced font size
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        
                        // Synonyms
                        if (currentWord.synonyms.isNotEmpty) ...[
                          const SizedBox(height: 16), // Reduced spacing
                          const Text(
                            "Synonyms:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14, // Reduced font size
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6), // Reduced spacing
                          Wrap(
                            spacing: 6, // Reduced spacing
                            children: currentWord.synonyms.map((synonym) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10, // Reduced padding
                                  vertical: 4, // Reduced padding
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12), // Reduced radius
                                ),
                                child: Text(
                                  synonym,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12, // Reduced font size
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reduced padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Audio Button
                  Container(
                    width: 50, // Reduced size
                    height: 50, // Reduced size
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.volume_up,
                      color: Colors.black,
                      size: 20, // Reduced size
                    ),
                  ),
                  
                  // Microphone Button
                  Container(
                    width: 50, // Reduced size
                    height: 50, // Reduced size
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.black,
                      size: 20, // Reduced size
                    ),
                  ),
                  
                  // Heart Button
                  GestureDetector(
                    onTap: _toggleMemorized,
                    child: Container(
                      width: 50, // Reduced size
                      height: 50, // Reduced size
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        shuffledWords[currentIndex].isMemorized ? Icons.favorite : Icons.favorite_border,
                        color: shuffledWords[currentIndex].isMemorized ? Colors.red : Colors.black,
                        size: 20, // Reduced size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Navigation and Progress
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Reduced padding
              child: Column(
                children: [
                  // Swipe instruction
                  const Text(
                    "Swipe left or right to navigate",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12, // Reduced font size
                    ),
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  // Progress indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${currentIndex + 1} / ${shuffledWords.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Reduced font size
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6), // Reduced spacing
                  // Progress bar
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / shuffledWords.length,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                ],
              ),
            ),
            
            // Banner Ad
            if (_isBannerAdReady && _bannerAd != null)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}

