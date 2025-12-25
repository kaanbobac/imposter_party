// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
  name: json['name'] as String,
  role: $enumDecode(_$PlayerRoleEnumMap, json['role']),
  isEliminated: json['isEliminated'] as bool? ?? false,
  secretWord: json['secretWord'] as String? ?? '',
);

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'role': _$PlayerRoleEnumMap[instance.role]!,
      'isEliminated': instance.isEliminated,
      'secretWord': instance.secretWord,
    };

const _$PlayerRoleEnumMap = {
  PlayerRole.civilian: 'civilian',
  PlayerRole.imposter: 'imposter',
};
