class TranscriptionModel {
  final String transcription;

  TranscriptionModel({required this.transcription});

  factory TranscriptionModel.fromJson(Map<String, dynamic> json) {
    return TranscriptionModel(
      transcription: json['transcription'] ?? '',
    );
  }
}
