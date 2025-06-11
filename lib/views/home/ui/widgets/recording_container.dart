import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:gradprj/core/theming/my_colors.dart';

class RecordingContainer extends StatelessWidget {
  const RecordingContainer({
    super.key,
    required this.timerText,
    required this.recorderController,
    required this.refresh,
    required this.close,
  });

  final String timerText;
  final RecorderController recorderController;
  final void Function() refresh;
  final void Function() close;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [MyColors.button1Color, MyColors.button2Color],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Text(
              timerText,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            AudioWaveforms(
              enableGesture: false,
              size: const Size(300, 50),
              recorderController: recorderController,
              waveStyle: const WaveStyle(
                waveColor: Colors.white,
                extendWaveform: true,
                showMiddleLine: false,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _styledIconButton(
                  icon: Icons.close,
                  onTap: close,
                ),
                _styledIconButton(
                  icon: Icons.refresh,
                  onTap: refresh,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
