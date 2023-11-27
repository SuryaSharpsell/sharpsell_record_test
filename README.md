# record_test

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
Scaffold(
appBar: AppBar(
title: const Text('Voice Recorder'),
),
body: Row(mainAxisAlignment: MainAxisAlignment.center,
children: [
recoding_now? IconButton(
icon: !isRecording
? const Icon(Icons.mic_none, color: Colors.red,size: 50,)
: const Icon(Icons.fiber_manual_record, color: Colors.red,size: 50),
onPressed: isRecording ? stopRecording : startRecording,
):
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
IconButton(
icon: !playing? Icon(Icons.play_circle, color: Colors.green,size: 50):Icon(Icons.pause_circle, color: Colors.green,size: 50),
onPressed: !playing?playRecording:pauseRecording,
),
IconButton(
icon: const Icon(Icons.delete, color: Colors.red,size: 50),
onPressed: deleteRecording,
),
IconButton(
icon: const Icon(Icons.trending_up, color: Colors.green,size: 50),
onPressed: uploadAndDeleteRecording,
),
],
),




            ],)






      ),