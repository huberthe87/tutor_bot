# Tutor Bot

A Flutter application for teachers to grade worksheets by selecting regions of interest on images.

## Features

- **Image Capture & Selection**: Take photos or select images from the gallery
- **Image Cropping**: Crop images to focus on the worksheet
- **Region Selection**: Select specific regions on worksheets for grading
- **Interactive Viewing**: Zoom and pan to examine worksheets in detail
- **Grading Tools**: Tools for processing and grading selected regions
- **AI-Powered Grading**: Uses OpenAI's Vision API to analyze and grade student work
- **Image Hosting**: Optional ImgBB integration for efficient image handling

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
  - `utils/` - Utility functions and helpers
  - `models/` - Data models
  - `widgets/` - Reusable UI components
  - `config/` - Configuration files (API keys, etc.)

## Usage

1. **Start the app** and you'll see the home screen
2. **Select an image** by taking a photo or choosing from gallery
3. **Crop the image** to focus on the worksheet
4. **Enter edit mode** to select regions of interest
5. **Draw rectangles** around areas you want to grade
6. **Exit edit mode** when done selecting regions
7. **Send for grading** or view the selected regions
8. **View AI-generated feedback** for each selected region

## AI Integration

This app uses OpenAI's APIs via the `dart_openai` package for:
- **Text Analysis**: Analyzing student responses
- **Image Recognition**: Identifying content in worksheet images
- **Grading**: Providing automated feedback on student work

To use these features, you need a valid OpenAI API key with access to:
- GPT-4o

## Image Handling

The app supports two methods for handling images when sending them to OpenAI:

1. **Base64 Encoding** (default): Images are encoded directly in the API request
2. **ImgBB Integration** (optional): Images are uploaded to ImgBB first, and the resulting URL is used in the API request

The ImgBB integration provides several benefits:
- Reduced API request size
- Faster processing for large images
- Better handling of image formats

To enable ImgBB integration, simply add your ImgBB API key to the configuration file.

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
