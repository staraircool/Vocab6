# Vocably - Vocabulary Learning App

A modern Flutter mobile application for vocabulary learning with an elegant UI design.

## Features

- **Learn New Words**: Study vocabulary from curated word lists
- **Free-hand Mode**: Practice with a focused set of words
- **Repeat All Words**: Review your entire vocabulary collection
- **Progress Tracking**: Monitor your daily learning progress
- **Interactive Word Study**: View definitions, synonyms, and pronunciation
- **Memorization System**: Mark words as memorized to track progress

## Screenshots

The app features a modern dark theme with:
- Clean progress tracking card
- Stacked learning mode cards with different colors
- Interactive word study interface with pronunciation guides
- Synonym display with pill-style tags

## Data Structure

The app loads vocabulary data from CSV files:
- `Vocabfile1.csv` and `Vocab2.csv` - Used for "Learn new words" mode
- `200words.csv` - Used for "Free-hand mode"
- All files combined - Used for "Repeat all words" mode

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### CSV File Format

The vocabulary CSV files should follow this format:
```csv
Word,Definition
Abate,"To reduce in degree or intensity. Often used for things like storms, fears, or emotions."
Abhor,To regard with extreme dislike or hatred. A stronger form of 'dislike'.
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── vocabulary_data.dart  # Data models and management
├── screens/
│   ├── home_screen.dart      # Main dashboard
│   └── word_study_screen.dart # Word learning interface
├── widgets/
│   ├── progress_card.dart    # Progress tracking widget
│   └── learning_card.dart    # Learning mode cards
└── services/
    └── csv_loader.dart       # CSV file loading service
```

## Dependencies

- `flutter`: Flutter SDK
- `csv`: CSV file parsing
- `cupertino_icons`: iOS-style icons

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

