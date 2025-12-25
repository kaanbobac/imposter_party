import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_strings.dart';
import '../../game/application/game_notifier.dart';
import '../../game/domain/game_state.dart';
import '../../../shared/domain/game_settings.dart';
import '../../../shared/presentation/widgets/animated_mystery_background.dart';
import '../../../shared/presentation/widgets/premium_button.dart';
import '../../../shared/presentation/widgets/glassmorphic_card.dart';
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
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D3A),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFF4ECDC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                AppStrings.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4ECDC4), width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFF4ECDC4)),
              onPressed: () => _showGameRules(context),
              tooltip: AppStrings.gameRulesTooltip,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E27), Color(0xFF1A1D3A), Color(0xFF2D1B69)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
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
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2D1B69).withOpacity(0.8),
                            const Color(0xFF1A1D3A).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4ECDC4).withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4ECDC4).withOpacity(0.1),
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
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4ECDC4).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.person_add,
                                    color: Color(0xFF4ECDC4), size: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  AppStrings.addPlayersTitle,
                                  style: const TextStyle(
                                    color: Color(0xFF4ECDC4),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A0E27).withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _playerNameController,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        labelText: AppStrings.playerNameLabel,
                                        labelStyle: const TextStyle(color: Color(0xFF4ECDC4)),
                                        hintText: AppStrings.playerNameHint,
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                        prefixIcon: const Icon(Icons.person,
                                          color: Color(0xFF4ECDC4)),
                                      ),
                                      onSubmitted: _addPlayer,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4ECDC4).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: _addPlayer,
                                    icon: const Icon(Icons.add_circle, color: Colors.white),
                                    label: Text(AppStrings.addButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
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
      statusText = AppStrings.minPlayersStatus.replaceAll('{min}', '${settings.minimumPlayers}');
      statusColor = Colors.red;
    } else if (playerCount > settings.maximumPlayers) {
      statusText = AppStrings.maxPlayersStatus.replaceAll('{max}', '${settings.maximumPlayers}');
      statusColor = Colors.red;
    } else if (!settings.isValidForPlayerCount(playerCount)) {
      final maxImposters = settings.getMaxImpostersForPlayerCount(playerCount);
      statusText = AppStrings.tooManyBoomerStatus
          .replaceAll('{max}', '$maxImposters')
          .replaceAll('{count}', '$playerCount');
      statusColor = Colors.red;
    } else {
      statusText = AppStrings.readyToStartStatus
          .replaceAll('{count}', '$playerCount')
          .replaceAll('{boomers}', '${settings.imposterCount}');
      statusColor = Colors.green;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1D3A).withOpacity(0.9),
            const Color(0xFF2D1B69).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canStart ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (canStart ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B))
                .withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status Icon and Message
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (canStart ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B))
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    canStart ? Icons.check_circle : Icons.warning,
                    color: canStart ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: canStart ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Start Game Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                gradient: canStart
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.2),
                      ],
                    ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: canStart
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
              ),
              child: ElevatedButton(
                onPressed: canStart ? gameNotifier.startGame : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      color: canStart ? Colors.white : Colors.grey,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppStrings.startGameButton,
                      style: TextStyle(
                        color: canStart ? Colors.white : Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGameRules(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const GameRulesDialog(),
    );
  }
}