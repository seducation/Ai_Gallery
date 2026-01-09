import 'dart:io';
import 'package:ai_gallery_app/features/editor/presentation/edit_screen.dart';
import 'package:ai_gallery_app/features/gallery/presentation/similar_photos_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:exif/exif.dart';
import 'package:ai_gallery_app/features/gallery/domain/media_item.dart';

class MediaViewScreen extends ConsumerStatefulWidget {
  final MediaItem mediaItem;

  const MediaViewScreen({super.key, required this.mediaItem});

  @override
  ConsumerState<MediaViewScreen> createState() => _MediaViewScreenState();
}

class _MediaViewScreenState extends ConsumerState<MediaViewScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  Map<String, IfdTag>? _exifData;

  @override
  void initState() {
    super.initState();
    if (widget.mediaItem.isVideo) {
      _videoPlayerController = VideoPlayerController.file(File(widget.mediaItem.path));
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
    } else {
      _loadExifData();
    }
  }

  Future<void> _loadExifData() async {
    final fileBytes = await File(widget.mediaItem.path).readAsBytes();
    final exifData = await readExifFromBytes(fileBytes);
    setState(() {
      _exifData = exifData;
    });
  }

  @override
  void dispose() {
    if (widget.mediaItem.isVideo) {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (!widget.mediaItem.isVideo)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScreen(imagePath: widget.mediaItem.path),
                  ),
                );
              },
            ),
          if (!widget.mediaItem.isVideo)
            IconButton(
              icon: const Icon(Icons.people_alt_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimilarPhotosScreen(mediaItem: widget.mediaItem),
                  ),
                );
              },
            ),
          if (!widget.mediaItem.isVideo)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showExifData(context),
            ),
        ],
      ),
      body: Center(
        child: widget.mediaItem.isVideo
            ? Chewie(controller: _chewieController)
            : Image.file(File(widget.mediaItem.path)),
      ),
    );
  }

  void _showExifData(BuildContext context) {
    if (_exifData == null) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: _exifData!.entries
                .map((entry) => Text('${entry.key}: ${entry.value}'))
                .toList(),
          ),
        );
      },
    );
  }
}
