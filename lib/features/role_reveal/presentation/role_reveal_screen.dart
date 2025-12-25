import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../game/application/game_notifier.dart';
import '../../game/domain/game_state.dart';
import '../../../shared/domain/player.dart';
import 'widgets/role_card.dart';
import 'widgets/pass_to_player_card.dart';

class RoleRevealScreen extends ConsumerWidget {
  const RoleRevealScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    // Navigate automatically when game phase changes
    ref.listen(gameNotifierProvider, (previous, next) {
      if (previous?.currentPhase != next.currentPhase) {
        switch (next.currentPhase) {
          case GamePhase.playing:
            context.go('/game');
            break;
          case GamePhase.voting:
            context.go('/voting');
            break;
          case GamePhase.gameOver:
            context.go('/game-over');
            break;
          case GamePhase.lobby:
            context.go('/');
            break;
          case GamePhase.roleReveal:
            // Already on role reveal
            break;
        }
      }
    });

    final currentPlayer = gameState.currentRevealPlayer;

    if (currentPlayer == null) {
      // All players have revealed, should transition to playing phase
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(gameNotifierProvider.notifier).resetGame();
              context.go('/');
            },
            tooltip: 'New Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with progress
              _buildHeader(context, gameState.currentRevealIndex + 1, gameState.players.length),

              const Spacer(),

              // Main content area
              if (!gameState.isRoleRevealed)
                PassToPlayerCard(
                  playerName: currentPlayer.name,
                  onTap: gameNotifier.showRole,
                )
              else
                RoleCard(
                  player: currentPlayer,
                  secretWord: currentPlayer.secretWord,
                  onTap: gameNotifier.hideRoleAndNext,
                ),

              const Spacer(),

              // Instructions at bottom
              _buildInstructions(context, gameState.isRoleRevealed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int currentPlayer, int totalPlayers) {
    return Column(
      children: [
        Text(
          'Role Reveal',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: currentPlayer / totalPlayers,
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
        ),
        const SizedBox(height: 8),
        Text(
          'Player $currentPlayer of $totalPlayers',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions(BuildContext context, bool isRoleRevealed) {
    final instruction = isRoleRevealed
        ? 'Tap anywhere to hide and pass to next player'
        : 'Pass the device to the next player, then tap to reveal';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        children: [
          Icon(
            isRoleRevealed ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              instruction,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}