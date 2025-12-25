// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  List<Player> get players => throw _privateConstructorUsedError;
  GameSettings get settings => throw _privateConstructorUsedError;
  GamePhase get currentPhase => throw _privateConstructorUsedError;
  int get currentRevealIndex =>
      throw _privateConstructorUsedError; // For pass-and-play
  bool get isRoleRevealed =>
      throw _privateConstructorUsedError; // Current player has seen their role
  int get gameTimeRemaining =>
      throw _privateConstructorUsedError; // Seconds remaining in game
  bool get isGameTimerRunning => throw _privateConstructorUsedError;
  List<String> get eliminatedPlayers =>
      throw _privateConstructorUsedError; // Players voted out
  String? get gameWinner => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    List<Player> players,
    GameSettings settings,
    GamePhase currentPhase,
    int currentRevealIndex,
    bool isRoleRevealed,
    int gameTimeRemaining,
    bool isGameTimerRunning,
    List<String> eliminatedPlayers,
    String? gameWinner,
  });

  $GameSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? settings = null,
    Object? currentPhase = null,
    Object? currentRevealIndex = null,
    Object? isRoleRevealed = null,
    Object? gameTimeRemaining = null,
    Object? isGameTimerRunning = null,
    Object? eliminatedPlayers = null,
    Object? gameWinner = freezed,
  }) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<Player>,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as GameSettings,
            currentPhase: null == currentPhase
                ? _value.currentPhase
                : currentPhase // ignore: cast_nullable_to_non_nullable
                      as GamePhase,
            currentRevealIndex: null == currentRevealIndex
                ? _value.currentRevealIndex
                : currentRevealIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            isRoleRevealed: null == isRoleRevealed
                ? _value.isRoleRevealed
                : isRoleRevealed // ignore: cast_nullable_to_non_nullable
                      as bool,
            gameTimeRemaining: null == gameTimeRemaining
                ? _value.gameTimeRemaining
                : gameTimeRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            isGameTimerRunning: null == isGameTimerRunning
                ? _value.isGameTimerRunning
                : isGameTimerRunning // ignore: cast_nullable_to_non_nullable
                      as bool,
            eliminatedPlayers: null == eliminatedPlayers
                ? _value.eliminatedPlayers
                : eliminatedPlayers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            gameWinner: freezed == gameWinner
                ? _value.gameWinner
                : gameWinner // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameSettingsCopyWith<$Res> get settings {
    return $GameSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Player> players,
    GameSettings settings,
    GamePhase currentPhase,
    int currentRevealIndex,
    bool isRoleRevealed,
    int gameTimeRemaining,
    bool isGameTimerRunning,
    List<String> eliminatedPlayers,
    String? gameWinner,
  });

  @override
  $GameSettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? settings = null,
    Object? currentPhase = null,
    Object? currentRevealIndex = null,
    Object? isRoleRevealed = null,
    Object? gameTimeRemaining = null,
    Object? isGameTimerRunning = null,
    Object? eliminatedPlayers = null,
    Object? gameWinner = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<Player>,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as GameSettings,
        currentPhase: null == currentPhase
            ? _value.currentPhase
            : currentPhase // ignore: cast_nullable_to_non_nullable
                  as GamePhase,
        currentRevealIndex: null == currentRevealIndex
            ? _value.currentRevealIndex
            : currentRevealIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        isRoleRevealed: null == isRoleRevealed
            ? _value.isRoleRevealed
            : isRoleRevealed // ignore: cast_nullable_to_non_nullable
                  as bool,
        gameTimeRemaining: null == gameTimeRemaining
            ? _value.gameTimeRemaining
            : gameTimeRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        isGameTimerRunning: null == isGameTimerRunning
            ? _value.isGameTimerRunning
            : isGameTimerRunning // ignore: cast_nullable_to_non_nullable
                  as bool,
        eliminatedPlayers: null == eliminatedPlayers
            ? _value._eliminatedPlayers
            : eliminatedPlayers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        gameWinner: freezed == gameWinner
            ? _value.gameWinner
            : gameWinner // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    final List<Player> players = const [],
    this.settings = const GameSettings(),
    this.currentPhase = GamePhase.lobby,
    this.currentRevealIndex = 0,
    this.isRoleRevealed = false,
    this.gameTimeRemaining = 0,
    this.isGameTimerRunning = false,
    final List<String> eliminatedPlayers = const [],
    this.gameWinner,
  }) : _players = players,
       _eliminatedPlayers = eliminatedPlayers;

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  final List<Player> _players;
  @override
  @JsonKey()
  List<Player> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  @JsonKey()
  final GameSettings settings;
  @override
  @JsonKey()
  final GamePhase currentPhase;
  @override
  @JsonKey()
  final int currentRevealIndex;
  // For pass-and-play
  @override
  @JsonKey()
  final bool isRoleRevealed;
  // Current player has seen their role
  @override
  @JsonKey()
  final int gameTimeRemaining;
  // Seconds remaining in game
  @override
  @JsonKey()
  final bool isGameTimerRunning;
  final List<String> _eliminatedPlayers;
  @override
  @JsonKey()
  List<String> get eliminatedPlayers {
    if (_eliminatedPlayers is EqualUnmodifiableListView)
      return _eliminatedPlayers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eliminatedPlayers);
  }

  // Players voted out
  @override
  final String? gameWinner;

  @override
  String toString() {
    return 'GameState(players: $players, settings: $settings, currentPhase: $currentPhase, currentRevealIndex: $currentRevealIndex, isRoleRevealed: $isRoleRevealed, gameTimeRemaining: $gameTimeRemaining, isGameTimerRunning: $isGameTimerRunning, eliminatedPlayers: $eliminatedPlayers, gameWinner: $gameWinner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.currentPhase, currentPhase) ||
                other.currentPhase == currentPhase) &&
            (identical(other.currentRevealIndex, currentRevealIndex) ||
                other.currentRevealIndex == currentRevealIndex) &&
            (identical(other.isRoleRevealed, isRoleRevealed) ||
                other.isRoleRevealed == isRoleRevealed) &&
            (identical(other.gameTimeRemaining, gameTimeRemaining) ||
                other.gameTimeRemaining == gameTimeRemaining) &&
            (identical(other.isGameTimerRunning, isGameTimerRunning) ||
                other.isGameTimerRunning == isGameTimerRunning) &&
            const DeepCollectionEquality().equals(
              other._eliminatedPlayers,
              _eliminatedPlayers,
            ) &&
            (identical(other.gameWinner, gameWinner) ||
                other.gameWinner == gameWinner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_players),
    settings,
    currentPhase,
    currentRevealIndex,
    isRoleRevealed,
    gameTimeRemaining,
    isGameTimerRunning,
    const DeepCollectionEquality().hash(_eliminatedPlayers),
    gameWinner,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(this);
  }
}

abstract class _GameState implements GameState {
  const factory _GameState({
    final List<Player> players,
    final GameSettings settings,
    final GamePhase currentPhase,
    final int currentRevealIndex,
    final bool isRoleRevealed,
    final int gameTimeRemaining,
    final bool isGameTimerRunning,
    final List<String> eliminatedPlayers,
    final String? gameWinner,
  }) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  List<Player> get players;
  @override
  GameSettings get settings;
  @override
  GamePhase get currentPhase;
  @override
  int get currentRevealIndex; // For pass-and-play
  @override
  bool get isRoleRevealed; // Current player has seen their role
  @override
  int get gameTimeRemaining; // Seconds remaining in game
  @override
  bool get isGameTimerRunning;
  @override
  List<String> get eliminatedPlayers; // Players voted out
  @override
  String? get gameWinner;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
