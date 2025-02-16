import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:helper_app/firebase_storage_example/image_source_modal.dart';

Future<UploadDocResultModel> uploadDocumentToServer(String docPath) async {
  UploadTask uploadTask;

  final docName = docPath.split('/').last;

  log("Uploading document to server");

  try {
    Reference ref = FirebaseStorage.instance.ref().child('example_storage').child('/$docName');

    uploadTask = ref.putFile(File(docPath));

    TaskSnapshot snapshot = await uploadTask.whenComplete(() => log("Task completed"));

    final downloadUrl = await snapshot.ref.getDownloadURL();

    log("url: $downloadUrl");

    return Future.value(UploadDocResultModel(state: ViewState.success, fileUrl: downloadUrl));
  } on FirebaseException catch (error) {
    log("F-Error uploading image : $error");

    return Future.value(UploadDocResultModel(state: ViewState.error, fileUrl: 'F-Error uploading image'));
  } on TimeoutException catch (_) {
    return Future.value(UploadDocResultModel(
        state: ViewState.error, fileUrl: "connection timeout. please check your internet connection"));
  } catch (error) {
    log("Error uploading image : $error");

    return Future.value(UploadDocResultModel(state: ViewState.error, fileUrl: 'Error uploading image'));
  }
}

Future<UploadDocResultModel> deleteDocumentFromServer(String downloadUrl) async {
  log("deleting document from server");
  if (downloadUrl.isEmpty) return Future.value(UploadDocResultModel(state: ViewState.idle, fileUrl: ''));

  try {
    Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
    await ref.delete();
    return Future.value(UploadDocResultModel(state: ViewState.success, fileUrl: downloadUrl));
  } on FirebaseException catch (error) {
    log("F-Error deleting image : $error");
    return Future.value(UploadDocResultModel(state: ViewState.error, fileUrl: 'F-Error deleting image'));
  } on TimeoutException catch (_) {
    return Future.value(UploadDocResultModel(
        state: ViewState.error, fileUrl: "connection timeout. please check your internet connection"));
  } catch (error) {
    log("Error deleting image : $error");
    return Future.value(UploadDocResultModel(state: ViewState.error, fileUrl: 'Error deleting image'));
  }
}

class UploadDocResultModel {
  final ViewState state;
  final String fileUrl;
  UploadDocResultModel({required this.state, required this.fileUrl});
}
