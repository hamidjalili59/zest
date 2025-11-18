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
      usedIngredients: (array[3] as List<dynamic>).cast<String>(),
      missingIngredients: (array[4] as List<dynamic>).cast<String>(),
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
