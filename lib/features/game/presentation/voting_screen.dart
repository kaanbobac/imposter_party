import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../application/game_notifier.dart';
import '../../../shared/domain/player.dart';

class VotingScreen extends ConsumerStatefulWidget {
  const VotingScreen({super.key});

  @override
  ConsumerState<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends ConsumerState<VotingScreen> {
  String? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    final activePlayers = gameState.players
        .where((p) => !p.isEliminated)
        .toList();

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        title: Text(
          AppStrings.votingPhase,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              ref.read(gameNotifierProvider.notifier).resetGame();
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
              // Voting Instructions
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.how_to_vote,
                      color: Colors.red[700],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.voteToEliminate,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.voteDescription,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Player List for Voting
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.selectToEliminate,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: activePlayers.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final player = activePlayers[index];
                          final isSelected = selectedPlayer == player.name;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPlayer = isSelected ? null : player.name;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.red[100] : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? Colors.red : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: isSelected
                                          ? const LinearGradient(
                                              colors: [Color(0xFFFF6B6B), Color(0xFFE74C3C)],
                                            )
                                          : LinearGradient(
                                              colors: _getPlayerGradient(player.name),
                                            ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: const Color(0xFFFF6B6B).withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getPlayerAvatar(player.name),
                                        style: const TextStyle(
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      player.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.red[700] : null,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.red[700],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Skip voting - could implement this feature
                        _showSkipVotingDialog(context, gameNotifier);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        side: BorderSide(color: Colors.grey[600]!),
                      ),
                      child: Text(AppStrings.skipVote),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: selectedPlayer != null
                          ? () => _confirmElimination(context, selectedPlayer!, gameNotifier)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        selectedPlayer != null
                            ? AppStrings.eliminatePlayerButton.replaceAll('{player}', selectedPlayer!.toUpperCase())
                            : AppStrings.selectPlayerButton,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmElimination(
    BuildContext context,
    String playerName,
    GameNotifier gameNotifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmElimination),
        content: Text(
          AppStrings.eliminationConfirm.replaceAll('{player}', playerName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _eliminateAndShowResult(context, playerName, gameNotifier);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.eliminate),
          ),
        ],
      ),
    );
  }

  void _eliminateAndShowResult(
    BuildContext context,
    String playerName,
    GameNotifier gameNotifier,
  ) {
    // Get player role before elimination
    final gameState = ref.read(gameNotifierProvider);
    final player = gameState.players.firstWhere((p) => p.name == playerName);
    final playerRole = player.role;

    // Eliminate the player
    gameNotifier.eliminatePlayer(playerName);

    // Navigate to elimination result screen
    context.go('/elimination-result', extra: {
      'playerName': playerName,
      'playerRole': playerRole,
    });
  }

  void _showSkipVotingDialog(BuildContext context, GameNotifier gameNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.skipVoting),
        content: Text(AppStrings.skipVotingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Continue game without elimination
              // For now, this could go back to discussion or end the game
              gameNotifier.resetGame();
            },
            child: Text(AppStrings.skip),
          ),
        ],
      ),
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