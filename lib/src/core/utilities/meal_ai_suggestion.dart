import 'dart:convert';

class MealResponse {
  final Map<String, dynamic> metadata;
  final List<MealSuggestion> suggests;

  MealResponse({required this.metadata, required this.suggests});

  factory MealResponse.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    final List<dynamic> rawSuggests = json['suggests'] as List<dynamic>;
    final List<MealSuggestion> parsedSuggests = rawSuggests
        .map((row) => MealSuggestion.fromArray(row as List<dynamic>))
        .toList();

    return MealResponse(
      metadata: json['metadata'] as Map<String, dynamic>,
      suggests: parsedSuggests,
    );
  }

  String toPrettyJson() {
    final List<Map<String, dynamic>> suggestsJson =
        suggests.map((s) => s.toJson()).toList();

    final Map<String, dynamic> output = {
      'metadata': metadata,
      'suggests': suggestsJson,
    };
    
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(output);
  }
}

class MealSuggestion {
  final String name;
  final int totalCalories;
  final String description;
  final List<String> usedIngredients;
  final List<String> missingIngredients;
  final int matchScore;
  final Map<String, int> macros;

  MealSuggestion({
    required this.name,
    required this.totalCalories,
    required this.description,
    required this.usedIngredients,
    required this.missingIngredients,
    required this.matchScore,
    required this.macros,
  });

  factory MealSuggestion.fromArray(List<dynamic> array) {
    final List<dynamic> macrosArray = array[6] as List<dynamic>;

    return MealSuggestion(
      name: array[0] as String,
      totalCalories: int.parse(array[1].toString()),
      description: array[2] as String,
      usedIngredients: _parseIngredientsField(array[3]),
      missingIngredients: _parseIngredientsField(array[4]),
      matchScore: int.parse(array[5].toString()),
      macros: {
        'protein': int.parse(macrosArray[0].toString()),
        'carbs': int.parse(macrosArray[1].toString()),
        'fats': int.parse(macrosArray[2].toString()),
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total_calories': totalCalories,
      'description': description,
      'used_ingredients': usedIngredients,
      'missing_ingredients': missingIngredients,
      'match_score': matchScore,
      'macros': macros,
    };
  }
}

List<String> _parseIngredientsField(dynamic value) {
  // If the model followed the schema strictly, this will be a List<dynamic>.
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }

  // Some models may return a comma‑separated string instead of an array.
  if (value is String) {
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  // Fallback: try to coerce to string and split by comma; at worst, single item.
  return value
      .toString()
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}
