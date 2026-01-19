import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class GuideSection {
  final String title;
  final String description;
  final List<String>? steps;
  final bool numbered;
  final String? subDescription;

  GuideSection({
    required this.title,
    required this.description,
    this.steps,
    this.numbered = true,
    this.subDescription,
  });
}

final List<GuideSection> raincheckGuide = [
  GuideSection(
    title: 'Calculate (Real-Time Flood Check)',
    description: 'Use this to assess current flood risk in your barangay.',
    steps: [
      'Tap Calculate',
      'Select Rainfall Intensity',
      'Choose your Barangay',
      'View the real-time flood likelihood',
    ],
  ),
  GuideSection(
    title: 'Predict (Future Flood Forecast)',
    description:
        'Use this to see weekly flood probabilities from Dec 2025 to Dec 2026.',
    steps: [
      'Tap Predict',
      'Choose a Week',
      'Select your Barangay',
      'View the flood probability for that week',
    ],
  ),
  GuideSection(
    numbered: false,
    title: 'Hazard Map',
    description:
        'Inside Predict, check the Hazard Map to see which barangays are:',
    steps: ['High Risk (Red)', 'Moderate Risk (Yellow)', 'Low Risk (Green)'],
    subDescription: 'Tap any barangay for more details',
  ),
];

@RoutePage()
class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('How to Use RainCheck')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: raincheckGuide.length,
        itemBuilder: (context, index) {
          final section = raincheckGuide[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    section.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    section.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 12),

                  // Steps
                  if (section.steps != null)
                    section.numbered
                        ? _buildNumberedSteps(section.steps!)
                        : _buildBulletSteps(section.steps!),

                  // Sub description
                  if (section.subDescription != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      section.subDescription!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Numbered list (1. 2. 3.)
  Widget _buildNumberedSteps(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('${entry.key + 1}. ${entry.value}'),
        );
      }).toList(),
    );
  }

  /// Bullet list (•)
  Widget _buildBulletSteps(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((step) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(step)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
