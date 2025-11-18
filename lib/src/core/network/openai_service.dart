import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zest/src/core/constants/general_constants.dart';

/// Simple service for calling an OpenAI-compatible Chat Completions API.
///
/// - No UI logic, only networking.
/// - Reads configuration from runtime env variables loaded via `flutter_dotenv`:
///   - `OPENAI_BASE_URL` (e.g. `https://api.openai.com/v1`)
///   - `OPENAI_API_KEY`
///   - `OPENAI_MODEL` (e.g. `gpt-4.1-mini`)
///
/// Example (from JS) that this mirrors conceptually:
/// - `baseURL`  -> `OPENAI_BASE_URL`
/// - `apiKey`   -> `OPENAI_API_KEY`
/// - `model`    -> `OPENAI_MODEL`
class OpenAiService {
  OpenAiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: GeneralConstants.kApiTimeoutDuration,
                receiveTimeout: GeneralConstants.kApiTimeoutDuration,
                headers: <String, Object?>{
                  'Authorization': 'Bearer $_apiKey',
                  'Content-Type': 'application/json',
                },
                validateStatus: (status) => switch (status) {
                  200 => true,
                  201 => true,
                  _ => false,
                },
              ),
            );

  final Dio _dio;

  // Values are read at runtime from .env via flutter_dotenv.
  static String get _baseUrl => dotenv.env['OPENAI_BASE_URL'] ?? '';
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get _model => dotenv.env['OPENAI_MODEL'] ?? '';

  /// Sends a single user message to the chat completions endpoint and
  /// returns the assistant's reply as a plain `String`.
  ///
  /// Throws [StateError] if required env values are missing or the response
  /// format is not what is expected from an OpenAI-compatible API.
  Future<String> sendMessage(String userMessage) async {
    _ensureEnvIsConfigured();

    final Response<dynamic> response = await _dio.post<dynamic>(
      '/chat/completions',
      data: <String, Object?>{
        'model': _model,
        'messages': <Map<String, String>>[
          <String, String>{
            'role': 'user',
            'content': userMessage,
          },
        ],
      },
    );

    final dynamic data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Unexpected response type from OpenAI API.');
    }

    final List<dynamic>? choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw StateError('No choices returned from OpenAI API.');
    }

    final dynamic firstChoice = choices.first;
    if (firstChoice is! Map<String, dynamic>) {
      throw StateError('Unexpected choice format from OpenAI API.');
    }

    final dynamic message = firstChoice['message'];
    if (message is! Map<String, dynamic>) {
      throw StateError('Missing "message" field in OpenAI response.');
    }

    final dynamic content = message['content'];
    if (content is! String) {
      throw StateError('Missing "content" in OpenAI message.');
    }

    return content;
  }

  void _ensureEnvIsConfigured() {
    final List<String> missing = <String>[];
    if (_baseUrl.isEmpty) {
      missing.add('OPENAI_BASE_URL');
    }
    if (_apiKey.isEmpty) {
      missing.add('OPENAI_API_KEY');
    }
    if (_model.isEmpty) {
      missing.add('OPENAI_MODEL');
    }

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required OpenAI environment variables: ${missing.join(', ')}\n'
        'Make sure your .env file contains them before running the app.',
      );
    }
  }
}


