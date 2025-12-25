import 'package:flutter/material.dart';

class GameRulesReminder extends StatelessWidget {
  const GameRulesReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Colors.amber,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Discussion Phase',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRuleItem(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: 'For Civilians',
                    description: 'Discuss the secret word without saying it directly. Ask questions to identify the imposters.',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.warning_amber,
                    title: 'For Imposters',
                    description: 'Blend in! Ask general questions and make comments that could apply to any topic.',
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.psychology,
                    title: 'Strategy Tips',
                    description: 'Pay attention to who seems confused or asks suspicious questions. Imposters might avoid specific details.',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.timer,
                    title: 'Time Pressure',
                    description: 'Use the timer to create urgency. Quick thinking can reveal who really knows the word!',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}