// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameSettingsImpl _$$GameSettingsImplFromJson(Map<String, dynamic> json) =>
    _$GameSettingsImpl(
      imposterCount: (json['imposterCount'] as num?)?.toInt() ?? 1,
      gameDurationSeconds:
          (json['gameDurationSeconds'] as num?)?.toInt() ?? 300,
      wordCategory:
          $enumDecodeNullable(_$WordCategoryEnumMap, json['wordCategory']) ??
          WordCategory.food,
      minimumPlayers: (json['minimumPlayers'] as num?)?.toInt() ?? 3,
      maximumPlayers: (json['maximumPlayers'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$GameSettingsImplToJson(_$GameSettingsImpl instance) =>
    <String, dynamic>{
      'imposterCount': instance.imposterCount,
      'gameDurationSeconds': instance.gameDurationSeconds,
      'wordCategory': _$WordCategoryEnumMap[instance.wordCategory]!,
      'minimumPlayers': instance.minimumPlayers,
      'maximumPlayers': instance.maximumPlayers,
    };

const _$WordCategoryEnumMap = {
  WordCategory.food: 'food',
  WordCategory.countries: 'countries',
  WordCategory.animals: 'animals',
  WordCategory.movies: 'movies',
  WordCategory.sports: 'sports',
  WordCategory.technology: 'technology',
  WordCategory.professions: 'professions',
  WordCategory.colors: 'colors',
};
