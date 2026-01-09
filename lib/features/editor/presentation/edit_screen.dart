import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_gallery_app/features/editor/data/subject_extraction_service.dart';

class EditScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const EditScreen({super.key, required this.imagePath});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  bool _isExtracting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: _extractSubject,
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Image.file(File(widget.imagePath)),
            if (_isExtracting)
              Container(
                color: Colors.black.withAlpha(128),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _extractSubject() async {
    setState(() {
      _isExtracting = true;
    });

    final service = ref.read(subjectExtractionServiceProvider.notifier);
    final extractedSubject = await service.extractSubject(File(widget.imagePath));

    setState(() {
      _isExtracting = false;
    });

    if (!mounted) return;

    if (extractedSubject != null) {
      // TODO: Display the extracted subject
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject extracted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to extract subject.')),
      );
    }
  }
}
