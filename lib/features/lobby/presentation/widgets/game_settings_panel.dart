import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/domain/game_settings.dart';
import '../../../../shared/domain/word_categories.dart';

class GameSettingsPanel extends StatefulWidget {
  final GameSettings settings;
  final int playerCount;
  final void Function(GameSettings) onSettingsChanged;
  final void Function(int) onImposterCountChanged;

  const GameSettingsPanel({
    super.key,
    required this.settings,
    required this.playerCount,
    required this.onSettingsChanged,
    required this.onImposterCountChanged,
  });

  @override
  State<GameSettingsPanel> createState() => _GameSettingsPanelState();
}

class _GameSettingsPanelState extends State<GameSettingsPanel> {

  @override
  Widget build(BuildContext context) {
    final maxImposters = widget.playerCount > 0
        ? widget.settings.getMaxImpostersForPlayerCount(widget.playerCount)
        : 1;
    final currentImposters = maxImposters > 0
        ? widget.settings.imposterCount.clamp(1, maxImposters)
        : 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings),
                const SizedBox(width: 8),
                Text(
                  'Game Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Imposter Count Slider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Imposters',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        '$currentImposters',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: currentImposters.toDouble(),
                  min: 1,
                  max: math.max(1, maxImposters).toDouble(),
                  divisions: math.max(1, maxImposters) > 1 ? math.max(1, maxImposters) - 1 : 1,
                  onChanged: (value) => widget.onImposterCountChanged(value.round()),
                ),
                if (widget.playerCount > 0)
                  Text(
                    'Max imposters for ${widget.playerCount} players: $maxImposters',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Word Category
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Word Category',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<WordCategory>(
                  value: widget.settings.wordCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: WordCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(
                            _getCategoryIcon(category),
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(category.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (category) {
                    if (category != null) {
                      widget.onSettingsChanged(
                        widget.settings.copyWith(wordCategory: category),
                      );
                    }
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'A random word from this category will be assigned to civilians',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Game Duration Settings
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game Duration',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${widget.settings.gameDurationSeconds ~/ 60} min',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: widget.settings.gameDurationSeconds.toDouble(),
                  min: 60, // 1 minute
                  max: 900, // 15 minutes
                  divisions: 14,
                  onChanged: (value) {
                    widget.onSettingsChanged(
                      widget.settings.copyWith(gameDurationSeconds: value.round()),
                    );
                  },
                ),
                Text(
                  'Duration: ${widget.settings.gameDurationSeconds ~/ 60} minutes',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(WordCategory category) {
    switch (category) {
      case WordCategory.food:
        return Icons.restaurant;
      case WordCategory.countries:
        return Icons.public;
      case WordCategory.animals:
        return Icons.pets;
      case WordCategory.movies:
        return Icons.movie;
      case WordCategory.sports:
        return Icons.sports_soccer;
      case WordCategory.technology:
        return Icons.computer;
      case WordCategory.professions:
        return Icons.work;
      case WordCategory.colors:
        return Icons.palette;
    }
  }
}