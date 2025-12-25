import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/game_notifier.dart';
import '../domain/game_state.dart';
import '../../../shared/domain/player.dart';

class EliminationResultScreen extends ConsumerWidget {
  final String eliminatedPlayerName;
  final PlayerRole eliminatedPlayerRole;

  const EliminationResultScreen({
    super.key,
    required this.eliminatedPlayerName,
    required this.eliminatedPlayerRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    final wasImposter = eliminatedPlayerRole == PlayerRole.imposter;
    final isGameOver = gameState.currentPhase == GamePhase.gameOver;

    return Scaffold(
      backgroundColor: wasImposter ? Colors.green[50] : Colors.red[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Result Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: wasImposter ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  wasImposter ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              const SizedBox(height: 24),

              // Result Title
              Text(
                wasImposter ? 'EXCELLENT!' : 'WRONG CHOICE!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: wasImposter ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Eliminated Player Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: wasImposter ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _getPlayerGradient(eliminatedPlayerName),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (wasImposter ? Colors.red : Colors.blue).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getPlayerAvatar(eliminatedPlayerName),
                          style: const TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      eliminatedPlayerName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: wasImposter ? Colors.red : Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        wasImposter ? 'IMPOSTER' : 'CIVILIAN',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Result Message
              Text(
                wasImposter
                    ? 'You eliminated an imposter! Well done!'
                    : 'You eliminated a civilian. The imposters are still among you...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: wasImposter ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Game Status
              if (isGameOver)
                _buildGameOverActions(context, gameState, gameNotifier)
              else
                _buildContinueActions(context, gameNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverActions(BuildContext context, GameState gameState, GameNotifier gameNotifier) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange),
          ),
          child: Column(
            children: [
              Icon(Icons.emoji_events, color: Colors.orange[700], size: 32),
              const SizedBox(height: 8),
              Text(
                'Game Over!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${gameState.gameWinner?.toUpperCase()} WIN!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.go('/game-over'),
                child: const Text('View Results'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  gameNotifier.resetGame();
                  context.go('/');
                },
                child: const Text('New Game'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContinueActions(BuildContext context, GameNotifier gameNotifier) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'The game continues. Return to discussion or start a new game.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  gameNotifier.continueGame();
                  context.go('/game');
                },
                child: const Text('Continue Game'),
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
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('New Game'),
              ),
            ),
          ],
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