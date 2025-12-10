import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eczanem_mobile/src/model/chat_message.dart';
import 'package:eczanem_mobile/src/services/github_models_service.dart';

part 'ai_assistant_state.dart';

class AIAssistantCubit extends Cubit<AIAssistantState> {
  AIAssistantCubit() : super(AIAssistantInitial());

  final List<ChatMessage> messages = [];
  final GitHubModelsService _aiService = GitHubModelsService();

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);
    emit(AIAssistantMessageSent());

    // Get AI response
    emit(AIAssistantLoading());
    
    try {
      final response = await _aiService.sendMessage(text);
      
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
      emit(AIAssistantResponseReceived());
    } catch (e) {
      emit(AIAssistantError(e.toString()));
      emit(AIAssistantResponseReceived());
    }
  }

  Future<void> sendImageMessage(File imageFile) async {
    // Add user message with image
    final userMessage = ChatMessage(
      text: "What medicine is this?",
      isUser: true,
      timestamp: DateTime.now(),
      imagePath: imageFile.path,
    );
    messages.add(userMessage);
    emit(AIAssistantMessageSent());

    // Get AI response with vision
    emit(AIAssistantLoading());
    
    try {
      final response = await _aiService.analyzeImage(imageFile);
      
      final aiMessage = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
      emit(AIAssistantResponseReceived());
    } catch (e) {
      emit(AIAssistantError(e.toString()));
      emit(AIAssistantResponseReceived());
    }
  }

  void clearMessages() {
    messages.clear();
    emit(AIAssistantInitial());
  }
}