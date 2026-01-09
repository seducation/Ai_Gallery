import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subject_extraction_service.g.dart';

@riverpod
class SubjectExtractionService extends _$SubjectExtractionService {
  @override
  FutureOr<void> build() async {}

  Future<File?> extractSubject(File imageFile) async {
    // Placeholder for subject extraction
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }
}
