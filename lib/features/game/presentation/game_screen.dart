import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../application/game_notifier.dart';
import '../domain/game_state.dart';
import 'widgets/game_timer_widget.dart';
import 'widgets/game_rules_reminder.dart';
import 'widgets/player_status_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    // Navigate automatically when game phase changes
    ref.listen(gameNotifierProvider, (previous, next) {
      if (previous?.currentPhase != next.currentPhase) {
        switch (next.currentPhase) {
          case GamePhase.lobby:
            context.go('/');
            break;
          case GamePhase.roleReveal:
            context.go('/role-reveal');
            break;
          case GamePhase.voting:
            context.go('/voting');
            break;
          case GamePhase.gameOver:
            context.go('/game-over');
            break;
          case GamePhase.playing:
            // Already on game screen
            break;
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppStrings.discussionPhase,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.how_to_vote, color: Colors.white),
            onPressed: gameNotifier.startVoting,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              gameNotifier.resetGame();
              context.go('/');
            },
            tooltip: AppStrings.newGameTooltip,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Game Timer
              GameTimerWidget(
                timeRemaining: gameState.gameTimeRemaining,
                formattedTime: gameNotifier.getFormattedTimeRemaining(),
                isRunning: gameState.isGameTimerRunning,
              ),

              const SizedBox(height: 24),

              // Player Status
              PlayerStatusWidget(
                players: gameState.players,
                imposterCount: gameState.settings.imposterCount,
              ),

              const SizedBox(height: 24),

              // Game Rules Reminder
              const Expanded(
                child: GameRulesReminder(),
              ),

              const SizedBox(height: 24),

              // Start Voting Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: gameNotifier.startVoting,
                  icon: const Icon(Icons.how_to_vote),
                  label: Text(AppStrings.startVotingButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}