import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../application/game_notifier.dart';
import '../domain/game_state.dart';
import '../../../shared/domain/player.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    final winner = gameState.gameWinner;
    final isImpostersWin = winner == 'imposters';
    final isCiviliansWin = winner == 'civilians';

    final imposters = gameState.imposters;
    final civilians = gameState.civilians;

    return Scaffold(
      backgroundColor: isImpostersWin ? Colors.red[900] : Colors.blue[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(),

              // Winner Announcement
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isImpostersWin ? Icons.warning : Icons.shield,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.gameOver,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isImpostersWin ? AppStrings.boomerWin : AppStrings.fenomenWin,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isImpostersWin
                          ? AppStrings.boomerWinMessage
                          : AppStrings.fenomenWinMessage,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Player Roles Reveal
              Expanded(
                child: Column(
                  children: [
                    Text(
                      AppStrings.playerRoles,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        children: [
                          // Imposters Column
                          Expanded(
                            child: _buildRoleColumn(
                              context,
                              title: AppStrings.boomersTitle,
                              players: imposters,
                              color: Colors.red,
                              icon: Icons.warning,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Civilians Column
                          Expanded(
                            child: _buildRoleColumn(
                              context,
                              title: AppStrings.fenomenlerTitle,
                              players: civilians,
                              color: Colors.blue,
                              icon: Icons.shield,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Game Stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.gameStats,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(context, AppStrings.totalPlayers, gameState.players.length.toString()),
                        _buildStat(context, AppStrings.totalBoomers, imposters.length.toString()),
                        _buildStat(context, AppStrings.eliminated, gameState.eliminatedPlayers.length.toString()),
                        _buildStat(context, AppStrings.secretWord,
                          civilians.isNotEmpty ? (civilians.first.secretWord ?? 'N/A') : 'N/A'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        gameNotifier.resetGame();
                        context.go('/');
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        AppStrings.newGameButton,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        gameNotifier.resetGame();
                        context.go('/');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isImpostersWin ? Colors.red[900] : Colors.blue[900],
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        AppStrings.playAgainButton,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleColumn(
    BuildContext context, {
    required String title,
    required List<Player> players,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: players.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final player = players[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _getPlayerGradient(player.name),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _getPlayerAvatar(player.name),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (player.isEliminated)
                              Text(
                                AppStrings.eliminated,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  String _getPlayerAvatar(String name) {
    final hash = name.hashCode;
    final avatars = [
      // Faces & People
      '😀', '😎', '🤓', '😊', '😋', '😍', '🤗', '🥳', '🤩', '🙃',
      '😄', '😆', '🤠', '🤡', '🥸', '😇', '🤑', '🤓', '😈', '👻',

      // Animals
      '🐶', '🐱', '🐼', '🦊', '🐨', '🐸', '🦆', '🐧', '🐯', '🦁',
      '🐰', '🐻', '🐵', '🐮', '🐷', '🐺', '🐙', '🦀', '🐢', '🦄',

      // Fun Objects
      '🎭', '🎪', '🎨', '🎯', '🎲', '🎮', '🎸', '🎺', '🎻', '🎹',
      '⚽', '🏀', '🎾', '🏆', '🎖️', '🏅', '🎂', '🍕', '🍔', '🎈',
    ];
    return avatars[hash.abs() % avatars.length];
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
}