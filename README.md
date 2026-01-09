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
- **Database**: Hive (NoSQL, high-performance)
- **AI Engine**: Custom modular package using TensorFlow Lite & MediaPipe.
- **Media Handling**: Photo Manager & FFmpeg.

## ✨ Features
- **Timeline View**: Grouped by day, month, and year.
- **Album View**: Auto-created albums (Screenshots, Downloads, etc.).
- **Photo Details**: EXIF data, map view, and labels.
- **Video Playback**: With basic controls.
- **Search**: By text (using AI), labels, and location.
- **AI Editor**: One-tap enhance, subject select, and background erase.
- **Sharing**: Share photos and videos with other apps.
- **Dark Mode**: Based on system settings.

## 🚀 Getting Started
1. **Clone the repo**: `git clone [URL]`
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run`

## 🧠 AI Engine
The `ai_engine` package is designed to be model-agnostic:
- **CLIP**: Used for generating 512-dimensional embeddings for semantic search.
- **MediaPipe**: Used for real-time subject extraction and face detection.
- **TFLite**: Handles custom model inference for photo enhancement.

## 🔐 Privacy & Security
- **Offline-First**: No internet connection required for core features.
- **Encrypted Storage**: Private albums are stored using AES encryption (via Hive).
- **No Analytics**: Zero user tracking or data collection.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
