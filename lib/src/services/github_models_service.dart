import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';  // ← ADD THIS! 

class GitHubModelsService {
  // You'll need to add your GitHub Personal Access Token here  
  static String get _apiKey => dotenv.env['GITHUB_TOKEN'] ??  '';
  static const String _baseUrl = 'https://models.inference.ai.azure.com';
  static const String _model = 'gpt-4o'; // or 'gpt-4o-mini' for faster responses

  // System prompt to give context to the AI
  static const String _systemPrompt = '''
You are a helpful pharmacy assistant AI in the Eczanem application. 
Your role is to help users with:
- Medicine information (usage, dosage, side effects, warnings)
- Identifying medicines from photos
- Answering health-related questions
- Providing general medical advice (with disclaimers)

Important guidelines:
- Always be accurate and helpful
- If unsure, recommend consulting a healthcare professional
- For prescription medicines, remind users to follow doctor's orders
- Be concise but informative
- Support both English and Arabic languages
- When identifying medicine from images, describe what you see and provide information

Remember: You are an assistant, not a replacement for professional medical advice.
''';

  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _systemPrompt,
            },
            {
              'role': 'user',
              'content': userMessage,
            },
          ],
          'temperature': 0.7,
          'max_tokens': 800,
          'top_p': 0.95,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }

  Future<String> analyzeImage(File imageFile) async {
    try {
      // Convert image to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': _systemPrompt,
            },
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': 'Please identify this medicine and provide information about it including: name, usage, dosage instructions, side effects, and any warnings.',
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image',
                  },
                },
              ],
            },
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        throw Exception('Failed to analyze image: ${response. statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error analyzing image: $e');
    }
  }
}