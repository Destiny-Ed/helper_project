import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ViewState { idle, success, error, busy }

void showImageSourceModel(BuildContext context, {required Function(ImageSource) onResult}) {
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(ImageSource.values.length, (index) {
              final data = ImageSource.values[index];

              return ListTile(
                leading: const Icon(
                  Icons.upload,
                  color: Colors.blue,
                ),
                title: Text(
                  data.name,
                ),
                onTap: () {
                  Navigator.pop(context);
                  onResult(data);
                },
              );
            }),
            ListTile(
              leading: const Icon(
                Icons.cancel,
                color: Colors.purple,
              ),
              title: const Text(
                'Cancel',
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
