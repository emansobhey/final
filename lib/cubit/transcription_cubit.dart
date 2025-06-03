import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradprj/core/services/api_service.dart';
import 'package:gradprj/cubit/transcription_state.dart';

class TranscriptionCubit extends Cubit<TranscriptionState> {
  final AudioService audioService;

  TranscriptionCubit(this.audioService) : super(TranscriptionInitial());

  transcribeAudio(File file) async {
    emit(TranscriptionLoading());
    try {
      final result = await audioService.transcribe(file);
      emit(TranscriptionSuccess(result));
    } catch (e) {
      emit(TranscriptionFailure(e.toString()));
    }
  }
}
