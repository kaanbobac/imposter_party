import 'dart:async';
import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/game_state.dart';
import '../../../shared/domain/player.dart';
import '../../../shared/domain/game_settings.dart';

part 'game_notifier.g.dart';

@riverpod
class GameNotifier extends _$GameNotifier {
  Timer? _gameTimer;
  final math.Random _random = math.Random();

  @override
  GameState build() {
    return const GameState();
  }

  /// Add a player to the game
  void addPlayer(String name) {
    if (name.trim().isEmpty) return;

    final trimmedName = name.trim();

    // Check if player already exists
    if (state.players.any((p) => p.name.toLowerCase() == trimmedName.toLowerCase())) {
      return;
    }

    state = state.copyWith(
      players: [
        ...state.players,
        Player(
          name: trimmedName,
          role: PlayerRole.civilian, // Default role, will be assigned later
        ),
      ],
    );
  }

  /// Remove a player from the game
  void removePlayer(String name) {
    state = state.copyWith(
      players: state.players.where((p) => p.name != name).toList(),
    );
  }

  /// Update game settings
  void updateSettings(GameSettings newSettings) {
    // Validate the new settings with current player count
    if (!newSettings.isValidForPlayerCount(state.players.length)) {
      return;
    }

    state = state.copyWith(settings: newSettings);
  }

  /// Update imposter count in settings
  void updateImposterCount(int count) {
    // Allow updates even with no players, but clamp to reasonable bounds
    final maxImposters = state.players.isNotEmpty
        ? state.settings.getMaxImpostersForPlayerCount(state.players.length)
        : 10; // Default max when no players

    final validCount = count.clamp(1, math.max(1, maxImposters)).toInt();

    state = state.copyWith(
      settings: state.settings.copyWith(imposterCount: validCount),
    );
  }

  /// Start the game - assign roles and move to role reveal phase
  void startGame() {
    if (!state.canStartGame) return;

    final playersWithRoles = _assignRoles();

    state = state.copyWith(
      players: playersWithRoles,
      currentPhase: GamePhase.roleReveal,
      currentRevealIndex: 0,
      isRoleRevealed: false,
      gameTimeRemaining: state.settings.gameDurationSeconds,
    );
  }

  /// Assign roles using robust shuffling algorithm
  List<Player> _assignRoles() {
    final playerCount = state.players.length;
    final imposterCount = state.settings.imposterCount;

    // Generate a random secret word for this game from the selected category
    final secretWord = state.settings.getRandomSecretWord();

    // Create list of indices and shuffle using Fisher-Yates algorithm
    final indices = List<int>.generate(playerCount, (i) => i);
    _fisherYatesShuffle(indices);

    // Take first N indices as imposters
    final imposterIndices = Set<int>.from(indices.take(imposterCount));

    // Assign roles
    final playersWithRoles = <Player>[];
    for (int i = 0; i < state.players.length; i++) {
      final player = state.players[i];
      final isImposter = imposterIndices.contains(i);

      playersWithRoles.add(player.copyWith(
        role: isImposter ? PlayerRole.imposter : PlayerRole.civilian,
        secretWord: isImposter ? '' : secretWord,
      ));
    }

    return playersWithRoles;
  }

  /// Fisher-Yates shuffle algorithm for robust randomization
  void _fisherYatesShuffle<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      final j = _random.nextInt(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  /// Show role to current player
  void showRole() {
    if (state.currentPhase != GamePhase.roleReveal) return;

    state = state.copyWith(isRoleRevealed: true);
  }

  /// Hide role and move to next player
  void hideRoleAndNext() {
    if (state.currentPhase != GamePhase.roleReveal) return;

    final nextIndex = state.currentRevealIndex + 1;

    if (nextIndex >= state.players.length) {
      // All players have seen their roles, start the game
      state = state.copyWith(
        currentPhase: GamePhase.playing,
        isGameTimerRunning: true,
      );
      _startGameTimer();
    } else {
      // Move to next player
      state = state.copyWith(
        currentRevealIndex: nextIndex,
        isRoleRevealed: false,
      );
    }
  }

  /// Start the game timer
  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.gameTimeRemaining <= 0) {
        timer.cancel();
        state = state.copyWith(
          isGameTimerRunning: false,
          currentPhase: GamePhase.voting,
        );
      } else {
        state = state.copyWith(
          gameTimeRemaining: state.gameTimeRemaining - 1,
        );
      }
    });
  }

  /// Move to voting phase
  void startVoting() {
    _gameTimer?.cancel();
    state = state.copyWith(
      currentPhase: GamePhase.voting,
      isGameTimerRunning: false,
    );
  }

  /// Eliminate a player
  void eliminatePlayer(String playerName) {
    if (state.currentPhase != GamePhase.voting) return;

    final updatedPlayers = state.players.map((player) {
      if (player.name == playerName) {
        return player.copyWith(isEliminated: true);
      }
      return player;
    }).toList();

    state = state.copyWith(
      players: updatedPlayers,
      eliminatedPlayers: [...state.eliminatedPlayers, playerName],
    );

    _checkGameEnd();
  }

  /// Check if the game has ended
  void _checkGameEnd() {
    String? winner;

    if (state.civiliansWon) {
      winner = 'civilians';
    } else if (state.impostersWon) {
      winner = 'imposters';
    }

    if (winner != null) {
      _gameTimer?.cancel();
      state = state.copyWith(
        currentPhase: GamePhase.gameOver,
        gameWinner: winner,
        isGameTimerRunning: false,
      );
    }
  }

  /// Continue game after elimination (return to playing phase)
  void continueGame() {
    if (state.currentPhase == GamePhase.gameOver) return;

    state = state.copyWith(
      currentPhase: GamePhase.playing,
      isGameTimerRunning: true,
      gameTimeRemaining: state.settings.gameDurationSeconds,
    );
    _startGameTimer();
  }

  /// Reset game to lobby
  void resetGame() {
    _gameTimer?.cancel();

    // Reset players (keep names but reset roles and elimination status)
    final resetPlayers = state.players.map((player) => Player(
      name: player.name,
      role: PlayerRole.civilian,
      isEliminated: false,
      secretWord: '',
    )).toList();

    state = GameState(
      players: resetPlayers,
      settings: state.settings,
    );
  }

  /// Get formatted time remaining
  String getFormattedTimeRemaining() {
    final minutes = state.gameTimeRemaining ~/ 60;
    final seconds = state.gameTimeRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void dispose() {
    _gameTimer?.cancel();
  }
}