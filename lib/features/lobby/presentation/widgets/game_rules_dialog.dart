import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class GameRulesDialog extends StatelessWidget {
  const GameRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.help_outline, color: Colors.red),
          const SizedBox(width: 8),
          Text(AppStrings.gameRules),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSection(
              AppStrings.objective,
              AppStrings.objectiveText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              AppStrings.setup,
              AppStrings.setupText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              AppStrings.roleReveal,
              AppStrings.roleRevealText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              AppStrings.discussionPhaseRules,
              AppStrings.discussionPhaseText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              AppStrings.voting,
              AppStrings.votingText,
            ),
            const SizedBox(height: 16),
            _buildSection(
              AppStrings.winning,
              AppStrings.winningText,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.gameRulesTip,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.gotIt),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}