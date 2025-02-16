import 'package:image_picker/image_picker.dart';

Future<String?> pickImage(ImageSource source) async {
  final result = await ImagePicker().pickImage(
    imageQuality: 70,
    maxWidth: 1440,
    source: source,
  );

  return result?.path;
}
