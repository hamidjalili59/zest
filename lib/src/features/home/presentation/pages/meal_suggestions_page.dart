import 'package:flutter/material.dart';
import 'package:zest/src/core/constants/app_theme.dart';
import 'package:zest/src/core/network/openai_service.dart';
import 'package:zest/src/core/utilities/meal_ai_suggestion.dart';
import 'package:zest/src/features/home/presentation/widgets/home_scaffold_widget.dart';

class MealSuggestionsPage extends StatefulWidget {
  const MealSuggestionsPage({super.key});

  @override
  State<MealSuggestionsPage> createState() => _MealSuggestionsPageState();
}

class _MealSuggestionsPageState extends State<MealSuggestionsPage> {
  final _ingredientsController = TextEditingController();
  final _caloriesController = TextEditingController(text: '800');
  String _dietPreference = 'None';
  String _religiousRestriction = 'Halal (Strictly Enforced)';
  String _outputLanguage = 'English';

  final _formKey = GlobalKey<FormState>();
  final _openAiService = OpenAiService();

  bool _isLoading = false;
  MealResponse? _mealResponse;
  String? _error;

  static const int _suggestionCount = 2;

  @override
  void dispose() {
    _ingredientsController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ingredientsRaw = _ingredientsController.text.trim();
    final caloriesRaw = _caloriesController.text.trim();
    final int? calories = int.tryParse(caloriesRaw);

    if (calories == null || calories <= 0) {
      setState(() {
        _error = 'Please enter a valid calorie value.';
      });
      return;
    }

    final ingredientsList = ingredientsRaw
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (ingredientsList.isEmpty) {
      setState(() {
        _error = 'Please enter at least one ingredient.';
      });
      return;
    }

    final prompt = _buildPrompt(
      targetCalories: calories,
      ingredients: ingredientsList,
      dietaryPreference: _dietPreference,
      religiousRestriction: _religiousRestriction,
      outputLanguage: _outputLanguage,
      suggestionCount: _suggestionCount,
    );

    setState(() {
      _isLoading = true;
      _error = null;
      _mealResponse = null;
    });

    try {
      final completion = await _openAiService.sendMessage(prompt);
      final jsonString = _extractJsonFromContent(completion);
      final parsed = MealResponse.fromJson(jsonString);
      setState(() {
        _mealResponse = parsed;
      });
    } catch (e) {
      setState(() {
        _error = 'Error while fetching meal suggestions: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Extracts the pure JSON string from an LLM response.
  ///
  /// Many models wrap JSON in ```json ... ``` code fences. This helper:
  /// - First tries to find a fenced block and return its inner content.
  /// - Otherwise, falls back to the substring between the first '{' and last '}'.
  String _extractJsonFromContent(String content) {
    // Try to extract from ```json ... ``` fenced block
    final RegExp fenced = RegExp(r'```(?:json)?\\s*([\\s\\S]*?)```', multiLine: true);
    final Match? match = fenced.firstMatch(content);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!.trim();
    }

    // Fallback: best-effort to grab JSON object substring
    final int start = content.indexOf('{');
    final int end = content.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return content.substring(start, end + 1).trim();
    }

    // As a last resort, return trimmed content (may still be valid JSON)
    return content.trim();
  }

  String _buildPrompt({
    required int targetCalories,
    required List<String> ingredients,
    required String dietaryPreference,
    required String religiousRestriction,
    required String outputLanguage,
    required int suggestionCount,
  }) {
    final ingredientsJoined = ingredients.join(' ');

    return '''
### Role & Objective
You are an advanced AI Nutritionist and Data Architect. Your goal is to suggest meals based on the user's available ingredients, caloric goals, religious restrictions, and dietary preferences. You must output the data strictly in JSON format based on the provided schema.

### Inputs

- Target Calories per Meal: ${targetCalories}kc (+/- 10% tolerance) 
- Number of Suggestions: $suggestionCount
- Available Ingredients: $ingredientsJoined
- Religious Restriction: $religiousRestriction
- Dietary Preference: $dietaryPreference
- Target Language: $outputLanguage

### Operational Rules
1. Safety & Restrictions: If Religious Restriction is violated, DO NOT suggest the meal. Prioritize Dietary Preference.
2. Ingredient Matching:
    - Prioritize meals using Available Ingredients.
    - You may suggest meals requiring additional ingredients.
    - Critical vs. Pantry: Distinguish between "Critical Missing Items" (e.g., Chicken, Pasta, Rice) and "Pantry Staples" (e.g., Salt, Oil, Pepper).
3. Output Quantity: The model MUST generate exactly $suggestionCount entries in the 'suggests' array. The 'metadata.suggestion_count' field must match this number.
4. Language & Localization: The JSON Keys MUST remain in English. The Values for user-facing fields (defined in the schema below) MUST be translated to $outputLanguage.
5. Output Structure: The core output structure is strictly a Row-Oriented JSON Array. The data elements in the suggests array MUST appear in the exact order defined in the SuggestsRow schema. The output MUST be minified (no spaces or newlines) to achieve maximum token savings.

### Output Schema (Array-Based Structure)

// DEFINITION 1: Order of elements within the 'macros' array.
// [0] = Protein (g), [1] = Carbs (g), [2] = Fats (g)
type MacrosArray = [number, number, number]; 

// DEFINITION 2: Order of elements within each suggestion row.
// IMPORTANT: The sequence MUST be maintained in the output.
type SuggestsRow = [
    // [0]: Name of the meal (Translated string)
    string,
    // [1]: Total Calories (number)
    number,
    // [2]: Description (Translated string, with critical warnings)
    string,
    // [3]: Used Ingredients (Array of translated strings)
    string[],
    // [4]: Missing Ingredients (Array of translated strings)
    string[],
    // [5]: Match Score (number, 0-100)
    number,
    // [6]: Macros Array [Protein, Carbs, Fats]
    MacrosArray
];

interface MealResponse {
  metadata: {
    suggestion_count: number;
    language: string; 
  };
  // The list of suggested meals, strictly adhering to the SuggestsRow array structure.
  suggests: SuggestsRow[]; 
}

### Execution
Analyze the inputs and generate the MINIFIED JSON response complying with the Array-Based MealResponse interface.
''';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 900;

    return HomeScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Meal Suggestions',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter ingredients, calorie target and diet preferences to generate AI-powered meal suggestions.',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isWide
                    ? Row(
                        children: [
                          // Form side
                          Flexible(
                            flex: 3,
                            child: _buildFormCard(theme),
                          ),
                          const SizedBox(width: 20),
                          // Result side
                          Flexible(
                            flex: 4,
                            child: _buildResultCard(theme, isWide: true),
                          ),
                        ],
                      )
                    : ListView(
                        children: [
                          _buildFormCard(theme),
                          const SizedBox(height: 16),
                          _buildResultCard(theme, isWide: false),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Parameters',
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ingredientsController,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Available Ingredients',
                labelStyle: TextStyle(color: Colors.white70),
                hintText: 'e.g. Sausage, Salt, Tomatoes, Bread, Pepper, Butter',
                hintStyle: TextStyle(color: Colors.white38),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _caloriesController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Calories per Meal (kcal)',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a calorie value.';
                }
                if (int.tryParse(value.trim()) == null) {
                  return 'Please enter an integer number.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _dietPreference,
                    dropdownColor: Colors.black87,
                    decoration: const InputDecoration(
                      labelText: 'Dietary Preference',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'None',
                        child: Text('None'),
                      ),
                      DropdownMenuItem(
                        value: 'Vegetarian',
                        child: Text('Vegetarian'),
                      ),
                      DropdownMenuItem(
                        value: 'High Protein',
                        child: Text('High Protein'),
                      ),
                      DropdownMenuItem(
                        value: 'Low Carb',
                        child: Text('Low Carb'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _dietPreference = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _religiousRestriction,
                    dropdownColor: Colors.black87,
                    decoration: const InputDecoration(
                      labelText: 'Religious Restriction',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'None',
                        child: Text('None'),
                      ),
                      DropdownMenuItem(
                        value: 'Halal (Strictly Enforced)',
                        child: Text('Halal (Strictly Enforced)'),
                      ),
                      DropdownMenuItem(
                        value: 'Kosher (Strictly Enforced)',
                        child: Text('Kosher (Strictly Enforced)'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _religiousRestriction = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _outputLanguage,
              dropdownColor: Colors.black87,
              decoration: const InputDecoration(
                labelText: 'Output Language',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'Persian',
                  child: Text('Persian'),
                ),
                DropdownMenuItem(
                  value: 'Arabic',
                  child: Text('Arabic'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _outputLanguage = value;
                });
              },
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isLoading ? 'Generating suggestions...' : 'Get meal suggestions',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ThemeData theme, {required bool isWide}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisSize: isWide ? MainAxisSize.max : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MealResponse (Pretty JSON)',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Currently the output is shown as JSON; later we can turn it into rich UI cards.',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 12),
          // For wide screens, use Expanded; for mobile, use fixed height
          if (isWide)
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: _buildResultContent(),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 400, // Fixed height for mobile
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: _buildResultContent(),
            ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    if (_error != null) {
      return SingleChildScrollView(
        child: SelectableText(
          _error!,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (_mealResponse == null) {
      return const Center(
        child: Text(
          'No request has been sent yet.',
          style: TextStyle(color: Colors.white54),
        ),
      );
    }

    final pretty = _mealResponse!.toPrettyJson();

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: SelectableText(
          pretty,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}


