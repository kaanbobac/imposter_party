import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/domain/game_settings.dart';
import '../../../../shared/domain/word_categories.dart';
import '../../../../shared/presentation/widgets/glassmorphic_card.dart';

class PremiumGameSettingsPanel extends StatefulWidget {
  final GameSettings settings;
  final int playerCount;
  final void Function(GameSettings) onSettingsChanged;
  final void Function(int) onImposterCountChanged;

  const PremiumGameSettingsPanel({
    super.key,
    required this.settings,
    required this.playerCount,
    required this.onSettingsChanged,
    required this.onImposterCountChanged,
  });

  @override
  State<PremiumGameSettingsPanel> createState() => _PremiumGameSettingsPanelState();
}

class _PremiumGameSettingsPanelState extends State<PremiumGameSettingsPanel> {
  @override
  Widget build(BuildContext context) {
    final maxImposters = widget.playerCount > 0
        ? widget.settings.getMaxImpostersForPlayerCount(widget.playerCount)
        : 1;
    final currentImposters = maxImposters > 0
        ? widget.settings.imposterCount.clamp(1, maxImposters)
        : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Game Settings',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Imposter Count Section
        _buildImposterCountSection(currentImposters, maxImposters),

        const SizedBox(height: 20),

        // Word Category Section
        _buildWordCategorySection(),

        const SizedBox(height: 20),

        // Game Duration Section
        _buildGameDurationSection(),
      ],
    );
  }

  Widget _buildImposterCountSection(int currentImposters, int maxImposters) {
    // Ensure valid slider bounds
    final validMaxImposters = maxImposters.clamp(1, 20);
    final validCurrentImposters = currentImposters.clamp(1, validMaxImposters);

    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      accentColor: const Color(0xFFFF6B6B),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_remove,
                      color: Color(0xFFFF6B6B),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Imposters',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFE74C3C)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '$validCurrentImposters',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
                  .animate(
                    target: validCurrentImposters.toDouble(),
                  )
                  .scale(
                    duration: 200.ms,
                    begin: const Offset(0.8, 0.8),
                    curve: Curves.bounceOut,
                  ),
            ],
          ),

          const SizedBox(height: 16),

          // Custom Slider - only show if we have meaningful bounds
          if (validMaxImposters > 1)
            _buildCustomSlider(
              value: validCurrentImposters.toDouble(),
              min: 1,
              max: validMaxImposters.toDouble(),
              divisions: validMaxImposters - 1,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                widget.onImposterCountChanged(value.round());
              },
              color: const Color(0xFFFF6B6B),
            )
          else
            // Show fixed value when only one imposter is possible
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFFF6B6B),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Imposter count: $validCurrentImposters (fixed based on player count)',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFFF6B6B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          if (widget.playerCount > 0)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF4ECDC4),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Max imposters for ${widget.playerCount} players: $maxImposters',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF4ECDC4),
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
    );
  }

  Widget _buildWordCategorySection() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      accentColor: const Color(0xFF6C5CE7),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.category,
                  color: Color(0xFF6C5CE7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Word Category',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GlassmorphicCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 12,
            accentColor: const Color(0xFF6C5CE7),
            hasShadow: false,
            child: DropdownButtonFormField<WordCategory>(
              value: widget.settings.wordCategory,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              dropdownColor: const Color(0xFF1A1D3A),
              style: GoogleFonts.montserrat(color: Colors.white),
              items: WordCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getCategoryIcon(category),
                          size: 16,
                          color: const Color(0xFF6C5CE7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        category.displayName,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (category) {
                if (category != null) {
                  HapticFeedback.selectionClick();
                  widget.onSettingsChanged(
                    widget.settings.copyWith(wordCategory: category),
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF6C5CE7),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'A random word from this category will be assigned to civilians',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF6C5CE7),
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
    );
  }

  Widget _buildGameDurationSection() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      accentColor: const Color(0xFFFFB74D),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.timer,
                      color: Color(0xFFFFB74D),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Game Duration',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB74D), Color(0xFFFFA726)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB74D).withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${widget.settings.gameDurationSeconds ~/ 60} min',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildCustomSlider(
            value: widget.settings.gameDurationSeconds.toDouble(),
            min: 60, // 1 minute
            max: 900, // 15 minutes
            divisions: 14,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              widget.onSettingsChanged(
                widget.settings.copyWith(gameDurationSeconds: value.round()),
              );
            },
            color: const Color(0xFFFFB74D),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB74D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFFFB74D).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: Color(0xFFFFB74D),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Discussion time: ${widget.settings.gameDurationSeconds ~/ 60} minutes',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFFB74D),
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
    );
  }

  Widget _buildCustomSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required void Function(double) onChanged,
    required Color color,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: color,
        inactiveTrackColor: color.withValues(alpha: 0.3),
        thumbColor: color,
        overlayColor: color.withValues(alpha: 0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        trackHeight: 6,
        valueIndicatorColor: color,
        valueIndicatorTextStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
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