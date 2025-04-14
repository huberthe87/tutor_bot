# Tutor Bot

A Flutter application for teachers to grade worksheets using AI-powered analysis.

## Features

- **Image Capture & Selection**: Take photos or select images from the gallery
- **Image Cropping**: Crop images to focus on the worksheet
- **Multi-language Support**: Grade worksheets in English and Chinese
- **Subject-specific Grading**: Specialized grading for Math, English, and Chinese Literature
- **Interactive Region Selection**: Select and grade specific areas of worksheets
- **AI-Powered Grading**: Uses OpenAI's Vision API to analyze and grade student work
- **Grade History**: View and manage past grading results
- **Detailed Feedback**: Get comprehensive feedback including:
  - Overall scores
  - Question-specific analysis
  - Step-by-step solutions for math problems
  - Grammar and spelling checks for language subjects
  - Expression and logic analysis for literature

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for emulators)
- Git
- OpenAI API key
- ImgBB API key (optional)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/tutor_bot.git
   ```

2. Navigate to the project directory:
   ```
   cd tutor_bot
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Configure your API keys:
   - Open `lib/config/api_config.dart`
   - Replace `YOUR_OPENAI_API_KEY` with your actual OpenAI API key
   - Replace `YOUR_IMGBB_API_KEY` with your actual ImgBB API key (optional)

5. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/` - Main source code
  - `screens/` - UI screens
    - `grade_process/` - Grading process screens
    - `grade_result/` - Results display screens
    - `recent_grade/` - Recent grades management
    - `worksheet_editor/` - Worksheet editing interface
  - `services/` - Business logic and API integration
  - `models/` - Data models
  - `widgets/` - Reusable UI components
  - `config/` - Configuration files
  - `utils/` - Utility functions

## Usage

1. **Start the app** and you'll see the home screen
2. **Select an image** by taking a photo or choosing from gallery
3. **Choose language and subject** for grading
4. **Select regions** of the worksheet to grade
5. **Send for grading** and wait for AI analysis
6. **View detailed results** including:
   - Overall score
   - Question-by-question feedback
   - Detailed explanations
   - Improvement suggestions

## AI Integration

This app uses OpenAI's APIs for:
- **Image Analysis**: Understanding worksheet content
- **Subject-specific Grading**: Specialized evaluation for different subjects
- **Multi-language Support**: Processing and grading in multiple languages
- **Detailed Feedback**: Providing comprehensive analysis and suggestions

## Recent Updates

- Added support for Chinese language grading
- Implemented subject-specific grading logic
- Enhanced feedback system with detailed analysis
- Added grade history management
- Improved UI with animations and better visual feedback
- Added region selection for targeted grading

## Development

### Adding New Features

1. Create a new branch for your feature
2. Implement the feature
3. Test thoroughly
4. Submit a pull request

### Code Style

This project follows the Flutter style guide. Run the following command to check your code:

```
flutter analyze
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- OpenAI for providing powerful AI APIs
- Contributors to this project
