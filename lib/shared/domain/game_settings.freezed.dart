// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameSettings _$GameSettingsFromJson(Map<String, dynamic> json) {
  return _GameSettings.fromJson(json);
}

/// @nodoc
mixin _$GameSettings {
  int get imposterCount => throw _privateConstructorUsedError;
  int get gameDurationSeconds =>
      throw _privateConstructorUsedError; // 5 minutes default
  WordCategory get wordCategory => throw _privateConstructorUsedError;
  int get minimumPlayers => throw _privateConstructorUsedError;
  int get maximumPlayers => throw _privateConstructorUsedError;

  /// Serializes this GameSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameSettingsCopyWith<GameSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameSettingsCopyWith<$Res> {
  factory $GameSettingsCopyWith(
    GameSettings value,
    $Res Function(GameSettings) then,
  ) = _$GameSettingsCopyWithImpl<$Res, GameSettings>;
  @useResult
  $Res call({
    int imposterCount,
    int gameDurationSeconds,
    WordCategory wordCategory,
    int minimumPlayers,
    int maximumPlayers,
  });
}

/// @nodoc
class _$GameSettingsCopyWithImpl<$Res, $Val extends GameSettings>
    implements $GameSettingsCopyWith<$Res> {
  _$GameSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imposterCount = null,
    Object? gameDurationSeconds = null,
    Object? wordCategory = null,
    Object? minimumPlayers = null,
    Object? maximumPlayers = null,
  }) {
    return _then(
      _value.copyWith(
            imposterCount: null == imposterCount
                ? _value.imposterCount
                : imposterCount // ignore: cast_nullable_to_non_nullable
                      as int,
            gameDurationSeconds: null == gameDurationSeconds
                ? _value.gameDurationSeconds
                : gameDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            wordCategory: null == wordCategory
                ? _value.wordCategory
                : wordCategory // ignore: cast_nullable_to_non_nullable
                      as WordCategory,
            minimumPlayers: null == minimumPlayers
                ? _value.minimumPlayers
                : minimumPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            maximumPlayers: null == maximumPlayers
                ? _value.maximumPlayers
                : maximumPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameSettingsImplCopyWith<$Res>
    implements $GameSettingsCopyWith<$Res> {
  factory _$$GameSettingsImplCopyWith(
    _$GameSettingsImpl value,
    $Res Function(_$GameSettingsImpl) then,
  ) = __$$GameSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int imposterCount,
    int gameDurationSeconds,
    WordCategory wordCategory,
    int minimumPlayers,
    int maximumPlayers,
  });
}

/// @nodoc
class __$$GameSettingsImplCopyWithImpl<$Res>
    extends _$GameSettingsCopyWithImpl<$Res, _$GameSettingsImpl>
    implements _$$GameSettingsImplCopyWith<$Res> {
  __$$GameSettingsImplCopyWithImpl(
    _$GameSettingsImpl _value,
    $Res Function(_$GameSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imposterCount = null,
    Object? gameDurationSeconds = null,
    Object? wordCategory = null,
    Object? minimumPlayers = null,
    Object? maximumPlayers = null,
  }) {
    return _then(
      _$GameSettingsImpl(
        imposterCount: null == imposterCount
            ? _value.imposterCount
            : imposterCount // ignore: cast_nullable_to_non_nullable
                  as int,
        gameDurationSeconds: null == gameDurationSeconds
            ? _value.gameDurationSeconds
            : gameDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        wordCategory: null == wordCategory
            ? _value.wordCategory
            : wordCategory // ignore: cast_nullable_to_non_nullable
                  as WordCategory,
        minimumPlayers: null == minimumPlayers
            ? _value.minimumPlayers
            : minimumPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        maximumPlayers: null == maximumPlayers
            ? _value.maximumPlayers
            : maximumPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameSettingsImpl implements _GameSettings {
  const _$GameSettingsImpl({
    this.imposterCount = 1,
    this.gameDurationSeconds = 300,
    this.wordCategory = WordCategory.food,
    this.minimumPlayers = 3,
    this.maximumPlayers = 20,
  });

  factory _$GameSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameSettingsImplFromJson(json);

  @override
  @JsonKey()
  final int imposterCount;
  @override
  @JsonKey()
  final int gameDurationSeconds;
  // 5 minutes default
  @override
  @JsonKey()
  final WordCategory wordCategory;
  @override
  @JsonKey()
  final int minimumPlayers;
  @override
  @JsonKey()
  final int maximumPlayers;

  @override
  String toString() {
    return 'GameSettings(imposterCount: $imposterCount, gameDurationSeconds: $gameDurationSeconds, wordCategory: $wordCategory, minimumPlayers: $minimumPlayers, maximumPlayers: $maximumPlayers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameSettingsImpl &&
            (identical(other.imposterCount, imposterCount) ||
                other.imposterCount == imposterCount) &&
            (identical(other.gameDurationSeconds, gameDurationSeconds) ||
                other.gameDurationSeconds == gameDurationSeconds) &&
            (identical(other.wordCategory, wordCategory) ||
                other.wordCategory == wordCategory) &&
            (identical(other.minimumPlayers, minimumPlayers) ||
                other.minimumPlayers == minimumPlayers) &&
            (identical(other.maximumPlayers, maximumPlayers) ||
                other.maximumPlayers == maximumPlayers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    imposterCount,
    gameDurationSeconds,
    wordCategory,
    minimumPlayers,
    maximumPlayers,
  );

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      __$$GameSettingsImplCopyWithImpl<_$GameSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameSettingsImplToJson(this);
  }
}

abstract class _GameSettings implements GameSettings {
  const factory _GameSettings({
    final int imposterCount,
    final int gameDurationSeconds,
    final WordCategory wordCategory,
    final int minimumPlayers,
    final int maximumPlayers,
  }) = _$GameSettingsImpl;

  factory _GameSettings.fromJson(Map<String, dynamic> json) =
      _$GameSettingsImpl.fromJson;

  @override
  int get imposterCount;
  @override
  int get gameDurationSeconds; // 5 minutes default
  @override
  WordCategory get wordCategory;
  @override
  int get minimumPlayers;
  @override
  int get maximumPlayers;

  /// Create a copy of GameSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameSettingsImplCopyWith<_$GameSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
