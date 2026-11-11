import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import '../models/activity.dart';
import '../models/app_config.dart';

List<Activity> decodeSuggestions(String response, List<Activity> candidates) {
  final decoded = jsonDecode(response);
  if (decoded is! Map<String, dynamic> || decoded['activity_ids'] is! List) {
    throw const FormatException('Missing activity IDs');
  }
  final byId = {for (final activity in candidates) activity.id: activity};
  final ids = (decoded['activity_ids'] as List)
      .whereType<String>()
      .where(byId.containsKey)
      .toSet()
      .take(3);
  return [for (final id in ids) byId[id]!];
}

class ActivitySuggestionService {
  const ActivitySuggestionService();

  Future<List<Activity>> suggest(
    AppConfig config,
    List<Activity> candidates,
  ) async {
    final token = await FirebaseAppCheck.instance.getToken();
    if (token == null || token.isEmpty) {
      throw StateError('App Check unavailable');
    }
    final model = FirebaseAI.googleAI().generativeModel(
      model: config.aiModel,
      systemInstruction: Content.system(config.aiPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'activity_ids': Schema.array(items: Schema.string(), maxItems: 3),
          },
        ),
      ),
    );
    // Only catalogue identifiers and fixed categories leave the device.
    final payload = jsonEncode([
      for (final item in candidates)
        {'id': item.id, 'group': item.groupId, 'minutes': item.minutes},
    ]);
    final response = await model.generateContent([Content.text(payload)]);
    return decodeSuggestions(response.text ?? '', candidates);
  }
}
