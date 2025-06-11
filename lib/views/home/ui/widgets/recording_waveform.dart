import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class RecordingWaveform extends StatelessWidget {
  final RecorderController recorderController;

  const RecordingWaveform({super.key, required this.recorderController});

  @override
  Widget build(BuildContext context) {
    return AudioWaveforms(
      enableGesture: false,
      size: const Size(300, 50),
      recorderController: recorderController,
      waveStyle: const WaveStyle(
        waveColor: Colors.white,
        extendWaveform: true,
        showMiddleLine: false,
      ),
    );
  }
}
