import 'package:flutter/material.dart';

class RecordingControl extends StatelessWidget {
  final bool isRecording;
  final double progress;
  final VoidCallback onToggleRecording;
  final VoidCallback onFlipCamera;

  const RecordingControl({
    Key? key,
    required this.isRecording,
    required this.progress,
    required this.onToggleRecording,
    required this.onFlipCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Spacer untuk mengatur jarak dari kiri
        SizedBox(
          width: 65,
        ),
        // Kolom untuk indikator perekaman
        Column(
          mainAxisSize: MainAxisSize.min, // Menghindari ekspansi vertikal
          children: [
            SizedBox(
              height: 4,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Circular Progress Indicator dengan ukuran yang lebih kecil
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: isRecording ? progress : 0.0,
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                // Tombol Record dengan Icon yang lebih kecil
                GestureDetector(
                  onTap: onToggleRecording,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: isRecording ? Colors.white : Colors.red,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 20), // Jarak antara Recording dan Flip Camera
        // Tombol Flip Camera
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.5),
          ),
          child: IconButton(
            onPressed: onFlipCamera,
            icon: Icon(Icons.flip_camera_android_rounded),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
