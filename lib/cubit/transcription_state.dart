import 'package:flutter/material.dart';
import 'package:gradprj/core/models/transicription.dart';

@immutable
abstract class TranscriptionState {}

class TranscriptionInitial extends TranscriptionState {}

class TranscriptionLoading extends TranscriptionState {}

class TranscriptionSuccess extends TranscriptionState {
  final TranscriptionModel model;
  TranscriptionSuccess(this.model);
}

class TranscriptionFailure extends TranscriptionState {
  final String error;
  TranscriptionFailure(this.error);
}
