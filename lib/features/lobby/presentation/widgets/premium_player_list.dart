import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/domain/player.dart';
import '../../../../shared/presentation/widgets/glassmorphic_card.dart';

class PremiumPlayerList extends StatefulWidget {
  final List<Player> players;
  final void Function(String) onRemovePlayer;

  const PremiumPlayerList({
    super.key,
    required this.players,
    required this.onRemovePlayer,
  });

  @override
  State<PremiumPlayerList> createState() => _PremiumPlayerListState();
}

class _PremiumPlayerListState extends State<PremiumPlayerList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Player> _displayedPlayers = [];

  @override
  void initState() {
    super.initState();
    _displayedPlayers = List.from(widget.players);
  }

  @override
  void didUpdateWidget(PremiumPlayerList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle additions
    for (int i = 0; i < widget.players.length; i++) {
      if (i >= _displayedPlayers.length ||
          widget.players[i].name != _displayedPlayers[i].name) {
        _displayedPlayers.insert(i, widget.players[i]);
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 500));
      }
    }

    // Handle removals
    for (int i = _displayedPlayers.length - 1; i >= 0; i--) {
      if (i >= widget.players.length ||
          (i < widget.players.length && _displayedPlayers[i].name != widget.players[i].name)) {
        final removedPlayer = _displayedPlayers.removeAt(i);
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildPlayerTile(removedPlayer, animation, true),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    // Sync the lists
    _displayedPlayers = List.from(widget.players);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.players.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA55EEA)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.group,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Players',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF6C5CE7),
                  width: 1,
                ),
              ),
              child: Text(
                '${widget.players.length}',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6C5CE7),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Player List
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _displayedPlayers.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index, animation) {
              if (index >= _displayedPlayers.length) return Container();
              return _buildPlayerTile(_displayedPlayers[index], animation, false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: const Icon(
            Icons.person_add,
            size: 48,
            color: Color(0xFF6C5CE7),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              duration: 2000.ms,
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 16),
        Text(
          'No players yet',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add players to start the mystery',
          style: GoogleFonts.montserrat(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(Player player, Animation<double> animation, bool isRemoving) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutBack)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutBack)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 16,
              accentColor: const Color(0xFF6C5CE7),
              hasShadow: false,
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getPlayerGradient(player.name),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _getPlayerGradient(player.name)[0].withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                      .animate(
                        target: isRemoving ? 0 : 1,
                      )
                      .rotate(
                        duration: 300.ms,
                        begin: 0,
                        end: isRemoving ? 1 : 0,
                      ),

                  const SizedBox(width: 16),

                  // Player Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready to play',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6C5CE7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Remove Button
                  GestureDetector(
                    onTap: () => _removePlayer(player.name),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFFF6B6B),
                        size: 16,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 150.ms,
                        curve: Curves.easeOut,
                      )
                      .then()
                      .shimmer(
                        duration: 1000.ms,
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getPlayerGradient(String name) {
    final hash = name.hashCode;
    final gradients = [
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFF6C5CE7), const Color(0xFFA55EEA)],
      [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)],
      [const Color(0xFFFFB74D), const Color(0xFFFFA726)],
      [const Color(0xFF26DE81), const Color(0xFF2ECC71)],
      [const Color(0xFFFF8A80), const Color(0xFFFF5722)],
    ];
    return gradients[hash.abs() % gradients.length];
  }

  void _removePlayer(String playerName) {
    HapticFeedback.lightImpact();

    // Show confirmation with haptic feedback
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Player',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Remove $playerName from the game?',
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                color: const Color(0xFF6C5CE7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRemovePlayer(playerName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}