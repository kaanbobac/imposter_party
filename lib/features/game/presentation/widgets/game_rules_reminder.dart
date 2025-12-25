import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

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
                AppStrings.discussionPhaseTitle,
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
                    title: AppStrings.forFenomens,
                    description: AppStrings.fenomenInstructions,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.warning_amber,
                    title: AppStrings.forBoomers,
                    description: AppStrings.boomerInstructions,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.psychology,
                    title: AppStrings.strategyTips,
                    description: AppStrings.strategyDescription,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                    context,
                    icon: Icons.timer,
                    title: AppStrings.timePressure,
                    description: AppStrings.timePressureDescription,
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