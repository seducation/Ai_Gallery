import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filter_provider.g.dart';

enum GalleryFilter { all, photos, videos }

@riverpod
class GalleryFilterNotifier extends _$GalleryFilterNotifier {
  @override
  GalleryFilter build() => GalleryFilter.all;

  void setFilter(GalleryFilter filter) {
    state = filter;
  }
}
