import 'package:freezed_annotation/freezed_annotation.dart';
import 'word_categories.dart';

part 'game_settings.freezed.dart';
part 'game_settings.g.dart';

@freezed
class GameSettings with _$GameSettings {
  const factory GameSettings({
    @Default(1) int imposterCount,
    @Default(300) int gameDurationSeconds, // 5 minutes default
    @Default(WordCategory.food) WordCategory wordCategory,
    @Default(3) int minimumPlayers,
    @Default(20) int maximumPlayers,
  }) = _GameSettings;

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsFromJson(json);
}

extension GameSettingsValidation on GameSettings {
  /// Validates that imposter count is less than half of total players
  bool isValidForPlayerCount(int playerCount) {
    return imposterCount < (playerCount / 2) &&
           playerCount >= minimumPlayers &&
           playerCount <= maximumPlayers;
  }

  /// Get maximum allowed imposters for a given player count
  int getMaxImpostersForPlayerCount(int playerCount) {
    // Constraint: imposters < (playerCount / 2)
    // So max imposters = floor(playerCount / 2 - 0.001)
    // Which simplifies to: (playerCount - 1) ~/ 2
    return (playerCount - 1) ~/ 2;
  }

  /// Get a random secret word from the selected category
  String getRandomSecretWord() {
    return wordCategory.getRandomWord();
  }
}