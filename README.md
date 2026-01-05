# AI Gallery App (Samsung Gallery-Style)

A modern, privacy-focused Gallery app built with Flutter, featuring offline-first AI capabilities using open-source libraries.

## 🎯 Project Goals
- **Photo & Video Browsing**: Smooth, Material 3 based UI with adaptive components.
- **Smart AI Search**: Offline vector-based image search using CLIP embeddings.
- **AI Photo Tools**: Auto-enhance, remaster, and object removal (inpainting).
- **Subject Extraction**: On-device segmentation for sticker creation using SAM Lite/MediaPipe.
- **Privacy First**: No cloud dependencies, no tracking, all processing is local.

## 🧱 Tech Stack
- **UI**: Flutter (Material 3)
- **State Management**: Riverpod (with code generation)
- **Navigation**: GoRouter
- **Database**: Isar (NoSQL, high-performance)
- **AI Engine**: Custom modular package using TensorFlow Lite & MediaPipe.
- **Media Handling**: Photo Manager & FFmpeg.

## 📂 Project Structure
- `lib/core`: Database services, themes, and global constants.
- `lib/features/gallery`: Media discovery, grid view, and video AI services.
- `lib/features/search`: Vector-based search implementation and UI.
- `lib/features/editor`: AI photo tools and subject extraction.
- `lib/features/settings`: App configuration and privacy settings.
- `ai_engine/`: Modular package for on-device AI inference.

## 🚀 Getting Started
1. **Prerequisites**:
   - Flutter SDK (Stable channel)
   - Android Studio / VS Code
2. **Setup**:
   - Run `flutter pub get` in the root directory.
   - Run `flutter pub get` in the `ai_engine` directory.
   - Run `dart run build_runner build` to generate necessary code.
3. **Models**:
   - Place your `.tflite` models in `assets/models/`.
   - Update `ai_engine.dart` with your model filenames.
4. **Run**:
   - `flutter run`

## 🧠 AI Engine
The `ai_engine` package is designed to be model-agnostic:
- **CLIP**: Used for generating 512-dimensional embeddings for semantic search.
- **MediaPipe**: Used for real-time subject extraction and face detection.
- **TFLite**: Handles custom model inference for photo enhancement.

## 🔐 Privacy & Security
- **Offline-First**: No internet connection required for core features.
- **Encrypted Storage**: Private albums are stored using AES encryption (via Isar).
- **No Analytics**: Zero user tracking or data collection.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
