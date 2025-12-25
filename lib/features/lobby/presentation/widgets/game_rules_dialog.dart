import 'package:flutter/material.dart';

class GameRulesDialog extends StatelessWidget {
  const GameRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: Colors.red),
          SizedBox(width: 8),
          Text('Game Rules'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSection(
              'Objective',
              'Imposters try to blend in while civilians try to identify them.',
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Setup',
              '• Add 3-20 players\n'
              '• Configure number of imposters\n'
              '• Set the secret word\n'
              '• Choose game duration',
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Role Reveal',
              '• Pass the device around\n'
              '• Each player taps to see their role\n'
              '• Civilians see the secret word\n'
              '• Imposters see "YOU ARE THE IMPOSTER"',
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Discussion Phase',
              '• Everyone discusses the secret topic\n'
              '• Imposters must blend in without knowing the word\n'
              '• Civilians try to identify the imposters\n'
              '• Use the timer to limit discussion time',
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Voting',
              '• Vote to eliminate suspected imposters\n'
              '• Majority vote determines elimination\n'
              '• Continue until one side wins',
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Winning',
              '• Civilians win: Eliminate all imposters\n'
              '• Imposters win: Equal or outnumber civilians',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Imposters should ask questions and make comments that could apply to any topic!',
                      style: TextStyle(fontStyle: FontStyle.italic),
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
          child: const Text('Got it!'),
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