import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final imageListProvider =
    StateNotifierProvider<ImageListNotifier, List<XFile>>((ref) {
  return ImageListNotifier();
});

class ImageListNotifier extends StateNotifier<List<XFile>> {
  ImageListNotifier() : super([]);

  void addImages(List<XFile> files) {
    state = [...state, ...files];
  }

  void removeImage(int index) {
    List<XFile> newList = List.from(state);
    newList.removeAt(index);
    state = newList;
  }

  void clearImages() {
    state = [];
  }
}
