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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1B69).withOpacity(0.9),
            const Color(0xFF1A1D3A).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  '⚙️ Game Settings',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Imposter Count Slider
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27).withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFF6B6B).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.person_remove,
                              color: Color(0xFFFF6B6B), size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Imposters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B6B).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '$currentImposters',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFFF6B6B),
                      inactiveTrackColor: const Color(0xFFFF6B6B).withOpacity(0.3),
                      thumbColor: const Color(0xFFFF6B6B),
                      overlayColor: const Color(0xFFFF6B6B).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: currentImposters.toDouble(),
                      min: 1,
                      max: math.max(1, maxImposters).toDouble(),
                      divisions: math.max(1, maxImposters) > 1 ? math.max(1, maxImposters) - 1 : 1,
                      onChanged: (value) => widget.onImposterCountChanged(value.round()),
                    ),
                  ),
                  if (widget.playerCount > 0)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        'Max imposters for ${widget.playerCount} players: $maxImposters',
                        style: const TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Word Category
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27).withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF4ECDC4).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.category,
                          color: Color(0xFF4ECDC4), size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Word Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D3A).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonFormField<WordCategory>(
                      value: widget.settings.wordCategory,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      dropdownColor: const Color(0xFF1A1D3A),
                      style: const TextStyle(color: Colors.white),
                      items: WordCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ECDC4).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  _getCategoryIcon(category),
                                  size: 16,
                                  color: const Color(0xFF4ECDC4),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                category.displayName,
                                style: const TextStyle(color: Colors.white),
                              ),
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
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4ECDC4).withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      '💭 A random word from this category will be assigned to civilians',
                      style: TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Game Duration Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E27).withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFFB74D).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB74D).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.timer,
                              color: Color(0xFFFFB74D), size: 18),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Game Duration',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB74D).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${widget.settings.gameDurationSeconds ~/ 60} min',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFFFB74D),
                      inactiveTrackColor: const Color(0xFFFFB74D).withOpacity(0.3),
                      thumbColor: const Color(0xFFFFB74D),
                      overlayColor: const Color(0xFFFFB74D).withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      trackHeight: 6,
                    ),
                    child: Slider(
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
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFFFB74D).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '⏱️ Discussion time: ${widget.settings.gameDurationSeconds ~/ 60} minutes',
                      style: const TextStyle(
                        color: Color(0xFFFFB74D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
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