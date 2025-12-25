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
import '../../../shared/domain/player.dart';
import '../../../shared/presentation/widgets/animated_mystery_background.dart';
import '../../../shared/presentation/widgets/premium_button.dart';
import '../../../shared/presentation/widgets/glassmorphic_card.dart';
import 'widgets/premium_player_list.dart';
import 'widgets/premium_game_settings_panel.dart';
import 'widgets/game_rules_dialog.dart';

class PremiumLobbyScreen extends ConsumerStatefulWidget {
  const PremiumLobbyScreen({super.key});

  @override
  ConsumerState<PremiumLobbyScreen> createState() => _PremiumLobbyScreenState();
}

class _PremiumLobbyScreenState extends ConsumerState<PremiumLobbyScreen>
    with TickerProviderStateMixin {
  final TextEditingController _playerNameController = TextEditingController();
  late AnimationController _headerController;
  late AnimationController _pulseController;
  bool _isStartingGame = false;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start header animation
    _headerController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _headerController.dispose();
    _pulseController.dispose();
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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildPremiumAppBar(context),
      body: AnimatedMysteryBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Animated Header
                      _buildAnimatedHeader()
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 200.ms)
                          .slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack),

                      const SizedBox(height: 24),

                      // Unified Players Section (Add + List)
                      _buildUnifiedPlayersSection(gameNotifier, gameState)
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 400.ms)
                          .slideX(begin: -0.3, end: 0, curve: Curves.easeOutBack),

                      // Game Settings Panel (after you can see your roster)
                      GlassmorphicCard(
                        margin: const EdgeInsets.only(bottom: 20),
                        accentColor: const Color(0xFF4ECDC4),
                        child: PremiumGameSettingsPanel(
                          settings: gameState.settings,
                          playerCount: gameState.players.length,
                          onSettingsChanged: gameNotifier.updateSettings,
                          onImposterCountChanged: gameNotifier.updateImposterCount,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 600.ms)
                          .slideX(begin: 0.3, end: 0, curve: Curves.easeOutBack),

                      // Game Status and Start Button
                      _buildGameStatus(gameState, gameNotifier)
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 800.ms)
                          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
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

  PreferredSizeWidget _buildPremiumAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
      title: AnimatedBuilder(
        animation: _headerController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_headerController.value * 0.05),
            child: GlassmorphicCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: 25,
              accentColor: const Color(0xFF4ECDC4),
              hasShadow: false,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.mainTitle,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: AppStrings.mainTitleHighlight,
                            style: const TextStyle(
                              color: Color(0xFF00FFFF), // Neon cyan for "Boomer?"
                              shadows: [
                                Shadow(
                                  color: Color(0xFF00FFFF),
                                  blurRadius: 8,
                                ),
                              ],
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
        },
      )
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .shimmer(
            duration: 3000.ms,
            color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
          ),
      actions: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _showGameRules(context);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 12,
              accentColor: const Color(0xFF6C5CE7),
              hasShadow: false,
              child: const Icon(
                Icons.help_outline,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                        const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.group,
                    size: 48,
                    color: Color(0xFF4ECDC4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.subHeader,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.warningMessage,
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF4ECDC4),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUnifiedPlayersSection(GameNotifier gameNotifier, GameState gameState) {
    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: 20),
      accentColor: const Color(0xFF6C5CE7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with unified title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFA55EEA)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.group,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                AppStrings.playersTitle,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (gameState.players.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6C5CE7),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${gameState.players.length}',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFF6C5CE7),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Add player input (always visible)
          Row(
            children: [
              Expanded(
                child: GlassmorphicCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  borderRadius: 12,
                  accentColor: const Color(0xFF6C5CE7),
                  hasShadow: false,
                  child: TextField(
                    controller: _playerNameController,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: AppStrings.playerNameLabel,
                      labelStyle: GoogleFonts.montserrat(
                        color: const Color(0xFF6C5CE7),
                        fontSize: 14,
                      ),
                      hintText: AppStrings.playerNameHint,
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: _addPlayer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              PremiumButton(
                text: AppStrings.addButton,
                style: PremiumButtonStyle.primary,
                icon: Icons.add_circle,
                onPressed: () => _addPlayer(),
                width: 100,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Players list or empty state
          if (gameState.players.isEmpty)
            _buildEmptyPlayersState()
          else
            _buildPlayersList(gameState.players, gameNotifier),
        ],
      ),
    );
  }

  Widget _buildEmptyPlayersState() {
    return const SizedBox(height: 60);
  }

  Widget _buildPlayersList(List<Player> players, GameNotifier gameNotifier) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GlassmorphicCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 12,
              accentColor: const Color(0xFF6C5CE7),
              hasShadow: false,
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getPlayerGradient(player.name),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: _getPlayerGradient(player.name)[0].withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getPlayerAvatar(player.name),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Player name
                  Expanded(
                    child: Text(
                      player.name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Remove button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      gameNotifier.removePlayer(player.name);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFFFF6B6B),
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddPlayerSection(GameNotifier gameNotifier) {
    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: 20),
      accentColor: const Color(0xFF4ECDC4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                AppStrings.addPlayerButton,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GlassmorphicCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  borderRadius: 12,
                  accentColor: const Color(0xFF4ECDC4),
                  hasShadow: false,
                  child: TextField(
                    controller: _playerNameController,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: AppStrings.playerNameLabel,
                      labelStyle: GoogleFonts.montserrat(
                        color: const Color(0xFF4ECDC4),
                        fontSize: 14,
                      ),
                      hintText: AppStrings.playerNameHint,
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF4ECDC4),
                      ),
                    ),
                    onSubmitted: _addPlayer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              PremiumButton(
                text: AppStrings.addButton,
                style: PremiumButtonStyle.primary,
                icon: Icons.add_circle,
                onPressed: () => _addPlayer(),
                width: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getPlayerGradient(String name) {
    final hash = name.hashCode;
    final gradients = [
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFF6C5CE7), const Color(0xFFA55EEA)],
      [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)],
      [const Color(0xFFFFB74D), const Color(0xFFFFA726)],
      [const Color(0xFF26DE81), const Color(0xFF2ECC71)],
      [const Color(0xFFFF8A80), const Color(0xFFFF5722)],
    ];
    return gradients[hash.abs() % gradients.length];
  }

  String _getPlayerAvatar(String name) {
    final hash = name.hashCode;
    final avatars = [
      // Faces & People
      '😀', '😎', '🤓', '😊', '😋', '😍', '🤗', '🥳', '🤩', '🙃',
      '😄', '😆', '🤠', '🤡', '🥸', '😇', '🤑', '🤓', '😈', '👻',

      // Animals
      '🐶', '🐱', '🐼', '🦊', '🐨', '🐸', '🦆', '🐧', '🐯', '🦁',
      '🐰', '🐻', '🐵', '🐮', '🐷', '🐺', '🐙', '🦀', '🐢', '🦄',

      // Fun Objects
      '🎭', '🎪', '🎨', '🎯', '🎲', '🎮', '🎸', '🎺', '🎻', '🎹',
      '⚽', '🏀', '🎾', '🏆', '🎖️', '🏅', '🎂', '🍕', '🍔', '🎈',
    ];
    return avatars[hash.abs() % avatars.length];
  }

  Widget _buildGameStatus(GameState gameState, GameNotifier gameNotifier) {
    final canStart = gameState.canStartGame;
    final playerCount = gameState.players.length;
    final settings = gameState.settings;

    String statusText;
    PremiumButtonStyle buttonStyle;
    IconData statusIcon;

    if (playerCount < settings.minimumPlayers) {
      statusText = AppStrings.minPlayersError;
      buttonStyle = PremiumButtonStyle.secondary;
      statusIcon = Icons.group_add;
    } else if (playerCount > settings.maximumPlayers) {
      statusText = AppStrings.maxPlayersError;
      buttonStyle = PremiumButtonStyle.danger;
      statusIcon = Icons.warning;
    } else if (!settings.isValidForPlayerCount(playerCount)) {
      final maxImposters = settings.getMaxImpostersForPlayerCount(playerCount);
      statusText = 'Çok fazla Boomer seçildi!';
      buttonStyle = PremiumButtonStyle.danger;
      statusIcon = Icons.warning;
    } else {
      statusText = AppStrings.readyToPlay;
      buttonStyle = PremiumButtonStyle.success;
      statusIcon = Icons.play_circle_filled;
    }

    return PulsatingGlassmorphicCard(
      accentColor: canStart ? const Color(0xFF26DE81) : const Color(0xFFFF6B6B),
      child: Column(
        children: [
          // Status Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canStart
                        ? [const Color(0xFF26DE81), const Color(0xFF2ECC71)]
                        : [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusText,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (canStart) ...[
                      const SizedBox(height: 4),
                      Text(
                        '$playerCount kişi, ${settings.imposterCount} Boomer',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF4ECDC4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Start Button
          PremiumButton(
            text: _isStartingGame ? 'BAŞLIYORUZ...' : AppStrings.startGameButton,
            style: buttonStyle,
            icon: _isStartingGame ? null : Icons.psychology,
            isExpanded: true,
            height: 64,
            isLoading: _isStartingGame,
            onPressed: canStart && !_isStartingGame ? () => _startGame(gameNotifier) : null,
          ),
        ],
      ),
    );
  }

  void _addPlayer([String? name]) {
    final playerName = name ?? _playerNameController.text.trim();
    if (playerName.isNotEmpty) {
      HapticFeedback.lightImpact();
      ref.read(gameNotifierProvider.notifier).addPlayer(playerName);
      _playerNameController.clear();

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$playerName kadroya katıldı! 🎭',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF4ECDC4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _startGame(GameNotifier gameNotifier) async {
    setState(() => _isStartingGame = true);
    HapticFeedback.heavyImpact();

    // Add dramatic pause for effect
    await Future.delayed(const Duration(milliseconds: 1500));

    gameNotifier.startGame();
    setState(() => _isStartingGame = false);
  }

  void _showGameRules(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => const GameRulesDialog(),
    );
  }
}