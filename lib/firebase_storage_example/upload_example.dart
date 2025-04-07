// import 'dart:async';
// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:helper_app/firebase_storage_example/image_source_modal.dart';
// import 'package:helper_app/firebase_storage_example/pick_image.dart';
// import 'package:helper_app/firebase_storage_example/upload_helper.dart';

// class UploadExample extends StatefulWidget {
//   const UploadExample({super.key});

//   @override
//   State<UploadExample> createState() => _UploadExampleState();
// }

// class _UploadExampleState extends State<UploadExample> {
//   ViewState loadingState = ViewState.idle;

//   List<String> images = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text("Upload example"),
//       ),
//       body: BusyOverlay(
//         show: loadingState == ViewState.busy,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Images"),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   spacing: 10,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         showImageSourceModel(
//                           context,
//                           onResult: (value) async {
//                             final result = await pickImage(value);

//                             if (result != null) {
//                               //set loading state
//                               loadingState = ViewState.busy;

//                               //upload image
//                               final uploadResult = await uploadDocumentToServer(result);

//                               loadingState = uploadResult.state;

//                               if (uploadResult.state == ViewState.error && context.mounted) {
//                                 log(uploadResult.fileUrl);
//                                 return;
//                               }

//                               if (uploadResult.state == ViewState.success && context.mounted) {
//                                 if (!images.contains(uploadResult.fileUrl)) {
//                                   images.add(uploadResult.fileUrl);
//                                 }
//                                 log('image saved');
//                               }
//                             }
//                           },
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.grey,
//                         ),
//                         height: MediaQuery.of(context).size.width / 5,
//                         width: MediaQuery.of(context).size.width / 5,
//                         child: Icon(
//                           Icons.upload,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                     ...List.generate(images.length, (index) {
//                       final image = images[index];
//                       return Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.grey,
//                           image: image.isEmpty
//                               ? null
//                               : DecorationImage(image: CachedNetworkImageProvider(image), fit: BoxFit.cover),
//                         ),
//                         height: MediaQuery.of(context).size.width / 5,
//                         width: MediaQuery.of(context).size.width / 5,
//                         child: GestureDetector(
//                           onTap: () {
//                             unawaited(deleteDocumentFromServer(image));
//                             if (images.contains(image)) {
//                               images.remove(image);
//                             }
//                           },
//                           child: Icon(
//                             Icons.delete,
//                             color: Colors.blue,
//                           ),
//                         ),
//                       );
//                     })
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 onPressed: () async {
//                   log(images.toString());
//                 },
//                 child: Text(
//                   "submit",
//                   style: TextStyle(color: Theme.of(context).primaryColor),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
