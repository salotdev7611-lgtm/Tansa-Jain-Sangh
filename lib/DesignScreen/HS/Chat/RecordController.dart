// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';
//
// class RecordController extends GetxController {
//   // Recording State
//   var isRecording = false.obs;
//   var isPaused = false.obs;
//
//   // Saved file path
//   String? recordedFilePath;
//
//   // Recorder Controller
//   late RecorderController recorderController;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     _requestMicPermission();
//
//     recorderController = RecorderController()
//       ..androidEncoder = AndroidEncoder.aac
//       ..androidOutputFormat = AndroidOutputFormat.mpeg4
//       ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//       ..sampleRate = 44100;
//   }
//
//   Future<void> _requestMicPermission() async {
//     await Permission.microphone.request();
//   }
//
//   Future<void> startRecording() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final filePath =
//         '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
//
//     await recorderController.record(path: filePath);
//
//     recordedFilePath = filePath;
//     isRecording.value = true;
//     isPaused.value = false;
//   }
//
//   Future<void> stopRecording() async {
//     await recorderController.stop();
//     isRecording.value = false;
//     isPaused.value = false;
//
//     print("Saved Recording: $recordedFilePath");
//   }
//
//   Future<void> cancelRecording() async {
//     await recorderController.stop();
//     isRecording.value = false;
//
//     if (recordedFilePath != null) {
//       final file = File(recordedFilePath!);
//       if (file.existsSync()) file.deleteSync();
//     }
//
//     recordedFilePath = null;
//   }
//
//   @override
//   void onClose() {
//     recorderController.dispose();
//     super.onClose();
//   }
// }
