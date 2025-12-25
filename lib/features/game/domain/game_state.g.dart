// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      players:
          (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings: json['settings'] == null
          ? const GameSettings()
          : GameSettings.fromJson(json['settings'] as Map<String, dynamic>),
      currentPhase:
          $enumDecodeNullable(_$GamePhaseEnumMap, json['currentPhase']) ??
          GamePhase.lobby,
      currentRevealIndex: (json['currentRevealIndex'] as num?)?.toInt() ?? 0,
      isRoleRevealed: json['isRoleRevealed'] as bool? ?? false,
      gameTimeRemaining: (json['gameTimeRemaining'] as num?)?.toInt() ?? 0,
      isGameTimerRunning: json['isGameTimerRunning'] as bool? ?? false,
      eliminatedPlayers:
          (json['eliminatedPlayers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      gameWinner: json['gameWinner'] as String?,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'players': instance.players,
      'settings': instance.settings,
      'currentPhase': _$GamePhaseEnumMap[instance.currentPhase]!,
      'currentRevealIndex': instance.currentRevealIndex,
      'isRoleRevealed': instance.isRoleRevealed,
      'gameTimeRemaining': instance.gameTimeRemaining,
      'isGameTimerRunning': instance.isGameTimerRunning,
      'eliminatedPlayers': instance.eliminatedPlayers,
      'gameWinner': instance.gameWinner,
    };

const _$GamePhaseEnumMap = {
  GamePhase.lobby: 'lobby',
  GamePhase.roleReveal: 'roleReveal',
  GamePhase.playing: 'playing',
  GamePhase.voting: 'voting',
  GamePhase.gameOver: 'gameOver',
};
