import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../game/application/game_notifier.dart';
import '../../game/domain/game_state.dart';
import '../../../shared/domain/game_settings.dart';
import 'widgets/player_list.dart';
import 'widgets/game_settings_panel.dart';
import 'widgets/game_rules_dialog.dart';

class LobbyScreen extends ConsumerStatefulWidget {
  const LobbyScreen({super.key});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  final TextEditingController _playerNameController = TextEditingController();

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final gameNotifier = ref.read(gameNotifierProvider.notifier);

    // Navigate automatically when game phase changes
    ref.listen(gameNotifierProvider, (previous, next) {
      if (previous?.currentPhase != next.currentPhase) {
        switch (next.currentPhase) {
          case GamePhase.roleReveal:
            context.go('/role-reveal');
            break;
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
            // Already on lobby
            break;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Imposter Game - Lobby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showGameRules(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Game Settings Panel
                    GameSettingsPanel(
                      settings: gameState.settings,
                      playerCount: gameState.players.length,
                      onSettingsChanged: gameNotifier.updateSettings,
                      onImposterCountChanged: gameNotifier.updateImposterCount,
                    ),

                    const SizedBox(height: 16),

                    // Add Player Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _playerNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Player Name',
                                  hintText: 'Enter player name...',
                                  border: OutlineInputBorder(),
                                ),
                                onSubmitted: _addPlayer,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _addPlayer,
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Players List
                    Container(
                      height: 300, // Fixed height for scrollable area
                      child: PlayerList(
                        players: gameState.players,
                        onRemovePlayer: gameNotifier.removePlayer,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Game Status and Start Button
                    _buildGameStatus(gameState, gameNotifier),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPlayer([String? name]) {
    final playerName = name ?? _playerNameController.text.trim();
    if (playerName.isNotEmpty) {
      ref.read(gameNotifierProvider.notifier).addPlayer(playerName);
      _playerNameController.clear();
    }
  }

  Widget _buildGameStatus(GameState gameState, GameNotifier gameNotifier) {
    final canStart = gameState.canStartGame;
    final playerCount = gameState.players.length;
    final settings = gameState.settings;

    String statusText;
    Color statusColor;

    if (playerCount < settings.minimumPlayers) {
      statusText = 'Need at least ${settings.minimumPlayers} players to start';
      statusColor = Colors.red;
    } else if (playerCount > settings.maximumPlayers) {
      statusText = 'Too many players (max ${settings.maximumPlayers})';
      statusColor = Colors.red;
    } else if (!settings.isValidForPlayerCount(playerCount)) {
      final maxImposters = settings.getMaxImpostersForPlayerCount(playerCount);
      statusText = 'Too many imposters (max $maxImposters for $playerCount players)';
      statusColor = Colors.red;
    } else {
      statusText = 'Ready to start! ($playerCount players, ${settings.imposterCount} imposters)';
      statusColor = Colors.green;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canStart ? gameNotifier.startGame : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: canStart ? Colors.red : null,
              foregroundColor: canStart ? Colors.white : null,
            ),
            child: Text(
              'START GAME',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGameRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const GameRulesDialog(),
    );
  }
}