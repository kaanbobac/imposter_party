import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/domain/player.dart';
import '../../../shared/domain/game_settings.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

enum GamePhase {
  lobby,
  roleReveal,
  playing,
  voting,
  gameOver,
}

@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default([]) List<Player> players,
    @Default(GameSettings()) GameSettings settings,
    @Default(GamePhase.lobby) GamePhase currentPhase,
    @Default(0) int currentRevealIndex, // For pass-and-play
    @Default(false) bool isRoleRevealed, // Current player has seen their role
    @Default(0) int gameTimeRemaining, // Seconds remaining in game
    @Default(false) bool isGameTimerRunning,
    @Default([]) List<String> eliminatedPlayers, // Players voted out
    String? gameWinner, // 'imposters' or 'civilians' or null if ongoing
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

extension GameStateLogic on GameState {
  /// Check if we can start the game (enough players, valid settings)
  bool get canStartGame {
    return players.length >= settings.minimumPlayers &&
           players.length <= settings.maximumPlayers &&
           settings.isValidForPlayerCount(players.length);
  }

  /// Get the current player for role reveal
  Player? get currentRevealPlayer {
    if (currentRevealIndex >= 0 && currentRevealIndex < players.length) {
      return players[currentRevealIndex];
    }
    return null;
  }

  /// Check if all players have revealed their roles
  bool get allPlayersRevealed {
    return currentRevealIndex >= players.length;
  }

  /// Get imposters in the game
  List<Player> get imposters {
    return players.where((p) => p.role == PlayerRole.imposter).toList();
  }

  /// Get civilians in the game
  List<Player> get civilians {
    return players.where((p) => p.role == PlayerRole.civilian).toList();
  }

  /// Check if imposters won
  bool get impostersWon {
    final aliveCivilians = civilians.where((p) => !p.isEliminated).length;
    final aliveImposters = imposters.where((p) => !p.isEliminated).length;

    // Imposters win if they equal or outnumber civilians
    return aliveImposters >= aliveCivilians;
  }

  /// Check if civilians won
  bool get civiliansWon {
    final aliveImposters = imposters.where((p) => !p.isEliminated).length;

    // Civilians win if all imposters are eliminated
    return aliveImposters == 0;
  }
}