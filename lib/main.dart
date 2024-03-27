import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:microphone/microphone.dart';

enum AudioState { recording, stop, play, init }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

void main() {
  runApp(RecordingScreen());
}

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  AudioState? audioState = AudioState.init;
  MicrophoneRecorder _recorder = MicrophoneRecorder();
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _recorder = MicrophoneRecorder()..init();
  }

  void handleAudioState(AudioState state) {
    setState(() {
      if (audioState == AudioState.init) {
        // Starts recording
        audioState = AudioState.recording;
        _recorder.start();
        // Finished recording
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.play;
        _recorder.stop();
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        audioState = AudioState.stop;
        _audioPlayer = AudioPlayer();
        _audioPlayer.setUrl(_recorder.value.recording!.url).then((_) {
          _audioPlayer.play().then((_) {
            setState(() => audioState = AudioState.play);
          });
        });

        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        audioState = AudioState.play;
        _audioPlayer.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microphone Flutter Web',
      home: Scaffold(
        backgroundColor: veryDarkBlue,
        body: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: handleAudioColour(),
                ),
                child: RawMaterialButton(
                  fillColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(30),
                  onPressed: () => handleAudioState(audioState!),
                  child: getIcon(audioState!),
                ),
              ),
              SizedBox(width: 20),
              if (audioState == AudioState.play ||
                  audioState == AudioState.stop)
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kindaDarkBlue,
                  ),
                  child: RawMaterialButton(
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(30),
                    onPressed: () => setState(() {
                      audioState = null;
                      _recorder.dispose();
                      _recorder = MicrophoneRecorder()..init();
                    }),
                    child: Icon(Icons.replay, size: 50),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color handleAudioColour() {
    if (audioState == AudioState.recording) {
      return Colors.deepOrangeAccent.shade700.withOpacity(0.5);
    } else if (audioState == AudioState.stop) {
      return Colors.green.shade900;
    } else {
      return kindaDarkBlue;
    }
  }

  Icon getIcon(AudioState state) {
    switch (state) {
      case AudioState.play:
        return Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return Icon(Icons.stop, size: 50);
      case AudioState.recording:
        return Icon(Icons.mic, color: Colors.redAccent, size: 50);
      default:
        return Icon(Icons.mic, size: 50);
    }
  }
}







// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:cross_file/cross_file.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path/path.dart' as p;
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// // import 'package:just_audio/just_audio.dart';
// import 'package:http/http.dart' as http;
// import 'package:share_plus/share_plus.dart';
// // import 'package:universal_html/html.dart' as html;
// import 'dart:typed_data';
//
// import 'package:universal_platform/universal_platform.dart';
//
//
// void main() {
//   runApp(const RecordingScreen());
// }
//
//
// class RecordingScreen extends StatefulWidget {
//   const RecordingScreen({super.key});
//
//   @override
//   _RecordingScreenState createState() => _RecordingScreenState();
// }
//
// class _RecordingScreenState extends State<RecordingScreen> {
//   // late AudioRecorder audioRecord;
//   late Record audioRecord;
//   // late AudioPlayer audioPlayer;
//   final audioPlayer = AudioPlayer();
//   bool isRecording = false;
//   String audioPath = "";
//
//   @override
//   void initState() {
//     super.initState();
//     // audioPlayer = AudioPlayer();
//     audioRecord = Record();
//     // audioRecord = AudioRecorder();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     audioRecord.dispose();
//     audioPlayer.dispose();
//   }
//   bool playing=false;
//   Future<void> startRecording() async {
//     try {
//       // Surya here is the issue on mobile
//       String directoryPath = '';
//       if (!UniversalPlatform.isWeb){
//         final Directory extDir = await getApplicationDocumentsDirectory();
//         directoryPath = '${extDir.path}/smart_sell_pdf';
//         await Directory(directoryPath).create(recursive: true);
//       }
//
//
//       if (await audioRecord.hasPermission()) {
//        print("Surya record has permission");
//        // AudioEncoder encoder = UniversalPlatform.isIOS ? AudioEncoder.pcm16bit : AudioEncoder.aacLc;
//        AudioEncoder encoder =  AudioEncoder.aacLc;
//         // await audioRecord.start(path: '$directoryPath/myFile.mp3',encoder:encoder);
//         // final RecordConfig config = RecordConfig(encoder: encoder);
//         // in iOS file should be m4a
//        // todo: check conversion for m4a to mp3
//        String filePath = '';
//        if (UniversalPlatform.isWeb){
//          filePath = '${audioPath}/${DateTime.now()}-myFile.mp3}';
//        } else {
//          filePath = '$directoryPath/${DateTime.now()}-myFile.${UniversalPlatform.isIOS ? 'm4a': 'mp3'}';
//        }
//        print("START RECODING+++++++++++++ $filePath ++++++++++++++++++++++++++++++++++++");
//         // await audioRecord.start(config, path: filePath);//m4a//mp3
//         await audioRecord.start(path: filePath,encoder: encoder);
//         setState(() {
//           isRecording = true;
//         });
//       }
//     } catch (e, stackTrace) {
//       print("START RECODING+++++++++++++++++++++${e}++++++++++${stackTrace}+++++++++++++++++");
//     }
//   }
//   Future<String> getFileSize(String filepath, int decimals) async {
//     var file = File(filepath);
//     int bytes = await file.length();
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//     var i = (log(bytes) / log(1024)).floor();
//     String size = ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
//     print('File Size - $size');
//     return size;
//   }
//
//   getFileSizeForWeb() async {
//     final file = File(audioPath);
//     int bytes = await file.length();
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//     var i = (log(bytes) / log(1024)).floor();
//     String size = ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
//     print('File Size - $size');
//     //   final blobFilePath = html.window.sessionStorage[audioPath];
//     //   if (blobFilePath != null) {
//     //     final uri = Uri.parse(blobFilePath);
//     //     final client = http.Client();
//     //     final request = await client.get(uri);
//     //     final uinitBytes = await request.bodyBytes;
//     //     print('response bytes.length: ${uinitBytes.length}');
//     //     int bytes =  await File.fromRawPath(uinitBytes).length();
//     //     if (bytes <= 0) return "0 B";
//     //     const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//     //     var i = (log(bytes) / log(1024)).floor();
//     //     String size = ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i];
//     //     print('File Size - $size');
//     // }
//   }
//
//   Future<void> stopRecording() async {
//     try {
//       String? path = await audioRecord.stop();
//       // Get file size
//       // if (UniversalPlatform.isWeb){
//       //   getFileSizeForWeb();
//       // } else {
//       //   getFileSize(path!,1);
//       // }
//
//
//       print("STOP RECODING+++++++++++++++${path}++++++++++++++++++++++++++++++++++");
//       setState(() {
//         recoding_now=false;
//         isRecording = false;
//         audioPath = path!;
//       });
//     } catch (e) {
//       print("STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
//     }
//   }
//
//   Future<void> playRecording() async {
//     try {
//       playing = true;
//       setState(() {});
//
//
//       print("AUDIO PLAYING+++++++++++++++++++ $audioPath ++++++++++++++++++++++++++++++");
//       // if (UniversalPlatform.isWeb) {
//       //   print("audio play here");
//       //   final Uint8List bytes = await File('${audioPath}/myFile.mp3').readAsBytes();
//       //   // List<int> list = utf8.encode('${audioPath}/myFile.mp3');
//       //   // Uint8List bytes = Uint8List.fromList(list);
//       //   print("audio play here 1");
//       //   // await audioPlayer.setFilePath('${audioPath}/myFile.m4a'); // Replace with your file path
//       //   await audioPlayer.setAudioSource(WebBufferAudioSource(bytes));
//       //   print("audio play here 2");
//       // } else {
//       //   await audioPlayer.setFilePath('${audioPath}/myFile.m4a');
//       // }
//       // print("audio play here 3");
//       // audioPlayer.play();
//       print("audio play here");
//       print('Surya - audio path - $audioPath');
// // if (Platform.isIOS){
// //   DeviceFileSource urlSource = DeviceFileSource(audioPath);
// //   print("audio play here 1 url source- $urlSource");
// //   await audioPlayer.play(urlSource);
// // } else {
// //   Source urlSource = UrlSource(audioPath);
// //   print("audio play here 1 url source- $urlSource");
// //   await audioPlayer.play(urlSource);
// // }
//
//
//       // await audioPlayer.setSourceDeviceFile(audioPath);
//
//       // Source urlSource = UrlSource(audioPath);
//       // print("audio play here 1 url source- $urlSource");
//       // await audioPlayer.setUrl(           // Load a URL
//       //     'https://foo.com/bar.mp3');
//       print('Surya audio path - $audioPath');
//       // await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse('asset:$audioPath')));
//       if (UniversalPlatform.isWeb){
//         await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioPath)));
//         print('***********');
//         // print(audioPlayer.duration!.inSeconds.toDouble());
//         print('***********');
//         await audioPlayer.play();
//       } else {
//         await audioPlayer.setAudioSource(AudioSource.file(audioPath));
//         await audioPlayer.play();
//       }
//       // Add an event listener to be notified when the audio playback completes
//       // audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       //   if (state == PlayerState.completed) {
//       //     playing = false;
//       //     print("AUDIO PLAYING ENDED+++++++++++++++++++++++++++++++++++++++++++++++++");
//       //     setState(() {});
//       //   }
//       // });
//
//     } catch (e,stack) {
//       print("AUDIO PLAYING++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
//       print(stack);
//     }
//   }
//
//   Future<void> pauseRecording() async {
//     try {
//       playing=false;
//
//       print("AUDIO PAUSED+++++++++++++++++++++++++++++++++++++++++++++++++");
//
//       await audioPlayer.pause();
//       setState(() {
//
//       });
//       //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
//     } catch (e) {
//       print("AUDIO PAUSED++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
//     }
//   }
//
//   Future<void> uploadAndDeleteRecording() async {
//     // try {
//       // final url = Uri.parse('YOUR_UPLOAD_URL'); // Replace with your server's upload URL
//
//     if (UniversalPlatform.isWeb){
//       final Uint8List bytes = await XFile(audioPath).readAsBytes();
//       print(bytes);
//       print('Surya - here in 238');
//       // downloadLocalFileForWeb(context: context, file: bytes);
//     } else {
//       await Share.shareXFiles(
//         [XFile(audioPath)],
//       );
//     }
//       // final file = File(audioPath);
//       // if (!file.existsSync()) {
//       //   print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
//       //   return;
//       // }
//
//       // print("UPLOADING FILE ++++++++++++++++${audioPath}+++++++++++++++++++++++++++++++++");
//       // final request = http.MultipartRequest('POST', url)
//       //   ..files.add(
//       //     http.MultipartFile(
//       //       'audio',
//       //       file.readAsBytes().asStream(),
//       //       file.lengthSync(),
//       //       filename: 'audio.mp3', // You may need to adjust the file extension
//       //     ),
//       //   );
//
//       // final response = await http.Response.fromStream(await request.send());
//
//       // if (response.statusCode == 200) {
//       //   // Upload successful, you can delete the recording if needed
//       //   // Show a snackbar or any other UI feedback for a successful upload
//       //   const snackBar = SnackBar(
//       //     content: Text('Audio uploaded.'),
//       //   );
//       //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       //
//       //   // Refresh the UI
//       //   setState(() {
//       //     audioPath = "";
//       //   });
//       // } else {
//       //   // Handle the error or show an error message
//       //   print('Failed to upload audio. Status code: ${response.statusCode}');
//       // }
//     // } catch (e) {
//     //   print('Error uploading audio: $e');
//     // }
//   }
//
//   Future<void> deleteRecording() async {
//
//     if (audioPath.isNotEmpty) {
//       Future<void> _deleteDir({required String dirName}) async {
//         final extDir = await getApplicationDocumentsDirectory();
//         final directoryPath = p.join(extDir.path, dirName);
//         if (await Directory(directoryPath).exists()) {
//           await Directory(directoryPath).delete(recursive: true);
//         }
//       }
//       try {
//         recoding_now=true;
//         _deleteDir(dirName: 'smart_sell_pdf');
//         print("FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
//         // File file = File(audioPath);
//         // if (file.existsSync()) {
//         //   file.deleteSync();
//         //   const snackBar = SnackBar(
//         //     content: Text('Recoding deleted'),);
//         //   print("FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
//         // }
//       } catch (e) {
//         print("FILE NOT DELETED++++++++++++++++${e}+++++++++++++++++++++++++++++++++");
//       }
//
//       setState(() {
//         audioPath = "";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Voice Recorder'),
//           ),
//           body: Row(mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               recoding_now? IconButton(
//                 icon: !isRecording
//                     ? const Icon(Icons.mic_none, color: Colors.red,size: 50,)
//                     : const Icon(Icons.fiber_manual_record, color: Colors.red,size: 50),
//                 onPressed: isRecording ? stopRecording : startRecording,
//               ):
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: !playing? Icon(Icons.play_circle, color: Colors.green,size: 50):Icon(Icons.pause_circle, color: Colors.green,size: 50),
//                     onPressed: !playing?playRecording:pauseRecording,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red,size: 50),
//                     onPressed: deleteRecording,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.trending_up, color: Colors.green,size: 50),
//                     onPressed: uploadAndDeleteRecording,
//                   ),
//                 ],
//               ),
//
//
//
//
//             ],)
//
//
//
//
//
//
//       ),
//     );
//   }
//   bool recoding_now=true;
//
//   // static Future<void> downloadLocalFileForWeb({
//   //   required BuildContext context,
//   //   required Uint8List file,
//   //   String? fileName,
//   //   String errorMsg = 'Something went wrong. Please try again!!',
//   // }) async {
//   //   print(' Surya 363');
//   //   try {
//   //     print('Downloading the file');
//   //     final String data =
//   //         "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(file)}";
//   //     final html.AnchorElement anchorElement = html.AnchorElement(href: data);
//   //     anchorElement.target = "blank";
//   //     anchorElement.download = "web.mp3";
//   //     html.document.body!.append(anchorElement);
//   //     anchorElement
//   //       ..click()
//   //       ..remove();
//   //   } catch (e) {
//   //     print(' Surya 376');
//   //     print(e);
//   //     ScaffoldMessenger.of(context)
//   //         .showSnackBar(SnackBar(content: Text(errorMsg)));
//   //
//   //   }
//   // }
//
// }
//
// // class WebBufferAudioSource extends StreamAudioSource {
// //   final Uint8List _buffer;
// //
// //   WebBufferAudioSource(this._buffer) : super(tag: "web-buffer-audio-source");
// //
// //   @override
// //   Future<StreamAudioResponse> request([int? start, int? end]) {
// //     final int lStart = start ?? 0;
// //     final int lEnd = end ?? _buffer.length;
// //
// //     return Future.value(
// //       StreamAudioResponse(
// //         sourceLength: _buffer.length,
// //         contentLength: lEnd - lStart,
// //         offset: start,
// //         contentType: 'audio/mp3',
// //         stream: Stream.value(List<int>.from(_buffer.skip(lStart).take(lEnd - lStart))),
// //       ),
// //     );
// //   }
// // }