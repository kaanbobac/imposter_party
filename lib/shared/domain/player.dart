import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

enum PlayerRole {
  civilian,
  imposter,
}

@freezed
class Player with _$Player {
  const factory Player({
    required String name,
    required PlayerRole role,
    @Default(false) bool isEliminated,
    @Default('') String secretWord,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}