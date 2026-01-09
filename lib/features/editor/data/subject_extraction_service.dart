import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ai_engine/ai_engine.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'subject_extraction_service.g.dart';

@riverpod
class SubjectExtractionService extends _$SubjectExtractionService {
  final AiEngine _aiEngine = AiEngine();

  @override
  FutureOr<void> build() async {
    await _aiEngine.initialize();
  }

  Future<File?> extractSubject(File imageFile) async {
    // Placeholder for SAM (Segment Anything Model) Lite or MediaPipe Selfie Segmentation
    final directory = await getTemporaryDirectory();
    final outputPath =
        p.join(directory.path, 'subject_${p.basename(imageFile.path)}.png');

    await Future.delayed(const Duration(seconds: 2));

    // In a real app, this would return a PNG with transparent background
    return imageFile.copy(outputPath);
  }
}
