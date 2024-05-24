import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioRecorder audiorecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying  = false;
  String? recordingPath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(recordingPath != null)
              MaterialButton(
                color: Colors.blue,
                onPressed: ()async{
                  if(audioPlayer.playing){
                    audioPlayer.stop();
                    setState(() {
                      isPlaying = false;
                    });
                  }else{
                    await audioPlayer.setFilePath(recordingPath!);
                    audioPlayer.play();
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                child: isPlaying?Text("Stop Playing Recording"):
                Text("Start Recording",style: TextStyle(color: Colors.white),),
              ),
            if(recordingPath == null)
              Text("no recording found :(")

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          if(isRecording) {
          String? filePath = await audiorecorder.stop();
          if(filePath != null){
            setState(() {
              isRecording = false;
              recordingPath = filePath;
            });
          }
          }else{
            if(await audiorecorder.hasPermission()){
              final Directory appDocumentdir = await getApplicationDocumentsDirectory();
              final String filePath = p.join(appDocumentdir.path , "recordinng.wav");
              await audiorecorder.start(RecordConfig(), path: filePath);
              setState(() {
                isRecording = true;
                recordingPath = null;
              });
            }
          }
        },
        child: isRecording?Icon(Icons.stop): Icon(Icons.mic),
      ),
    );
  }

}
