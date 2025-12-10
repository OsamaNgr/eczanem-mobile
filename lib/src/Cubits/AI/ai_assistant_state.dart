part of 'ai_assistant_cubit.dart';

abstract class AIAssistantState {}

class AIAssistantInitial extends AIAssistantState {}

class AIAssistantLoading extends AIAssistantState {}

class AIAssistantMessageSent extends AIAssistantState {}

class AIAssistantResponseReceived extends AIAssistantState {}

class AIAssistantError extends AIAssistantState {
  final String error;
  AIAssistantError(this.error);
}