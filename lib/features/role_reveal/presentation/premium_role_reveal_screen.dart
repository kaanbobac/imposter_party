import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../game/application/game_notifier.dart';
import '../../game/domain/game_state.dart';
import '../../../shared/domain/player.dart';
import '../../../shared/presentation/widgets/animated_mystery_background.dart';
import '../../../shared/presentation/widgets/premium_button.dart';
import '../../../shared/presentation/widgets/glassmorphic_card.dart';

class PremiumRoleRevealScreen extends ConsumerStatefulWidget {
  const PremiumRoleRevealScreen({super.key});

  @override
  ConsumerState<PremiumRoleRevealScreen> createState() => _PremiumRoleRevealScreenState();
}

class _PremiumRoleRevealScreenState extends ConsumerState<PremiumRoleRevealScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _pulseController;
  late AnimationController _dangerController;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _cardScaleAnimation;
  bool _isRevealed = false;
  bool _isDangerMode = false;

  @override
  void initState() {
    super.initState();
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _dangerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardFlipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _cardController.dispose();
    _pulseController.dispose();
    _dangerController.dispose();
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
            context.go('/');
            break;
          case GamePhase.roleReveal:
            // Already on role reveal
            break;
        }
      }
    });

    final currentPlayer = gameState.currentRevealPlayer;
    _isRevealed = gameState.isRoleRevealed;

    if (currentPlayer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check if current player is imposter for danger mode
    final isImposter = currentPlayer.role == PlayerRole.imposter;
    if (isImposter && _isRevealed && !_isDangerMode) {
      _isDangerMode = true;
      _dangerController.repeat(reverse: true);
      HapticFeedback.heavyImpact();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: AnimatedMysteryBackground(
        isDangerMode: _isDangerMode,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Progress Header
                _buildProgressHeader(gameState)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.3, end: 0),

                const Spacer(),

                // Main Card Area
                Center(
                  child: _isRevealed
                      ? _buildRoleCard(currentPlayer, gameNotifier)
                      : _buildPassCard(currentPlayer, gameNotifier),
                ),

                const Spacer(),

                // Instructions
                _buildInstructions()
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'MYSTERY REVEAL',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 1.5,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            ref.read(gameNotifierProvider.notifier).resetGame();
            context.go('/');
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.5),
              ),
            ),
            child: const Icon(
              Icons.refresh,
              color: Color(0xFFFF6B6B),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressHeader(GameState gameState) {
    final currentIndex = gameState.currentRevealIndex + 1;
    final totalPlayers = gameState.players.length;
    final progress = currentIndex / totalPlayers;

    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'ROLE REVEALS',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )
              .animate()
              .scaleX(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 12),
          Text(
            'Player $currentIndex of $totalPlayers',
            style: GoogleFonts.montserrat(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassCard(Player player, GameNotifier gameNotifier) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.05),
          child: GestureDetector(
            onTap: () => _revealRole(gameNotifier),
            child: Container(
              width: 280,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GlassmorphicCard(
                padding: const EdgeInsets.all(32),
                borderRadius: 20,
                accentColor: const Color(0xFF4ECDC4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 64,
                        color: Color(0xFF4ECDC4),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      player.name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'TAP TO REVEAL\nYOUR ROLE',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF4ECDC4),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ECDC4).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF4ECDC4).withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        'Pass device securely',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFF4ECDC4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard(Player player, GameNotifier gameNotifier) {
    final isImposter = player.role == PlayerRole.imposter;

    return AnimatedBuilder(
      animation: _cardFlipAnimation,
      builder: (context, child) {
        // 3D flip effect
        final isShowingFront = _cardFlipAnimation.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.pi * _cardFlipAnimation.value),
          child: AnimatedBuilder(
            animation: _cardScaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _cardScaleAnimation.value,
                child: Container(
                  width: 280,
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isImposter ? const Color(0xFFFF6B6B) : const Color(0xFF26DE81))
                            .withValues(alpha: 0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: isShowingFront
                      ? _buildCardBack()
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: _buildRoleCardContent(player, gameNotifier, isImposter),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardBack() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(32),
      borderRadius: 20,
      accentColor: const Color(0xFF4ECDC4),
      child: Container(),
    );
  }

  Widget _buildRoleCardContent(Player player, GameNotifier gameNotifier, bool isImposter) {
    return GestureDetector(
      onTap: () => _hideAndNext(gameNotifier),
      child: GlassmorphicCard(
        padding: const EdgeInsets.all(32),
        borderRadius: 20,
        accentColor: isImposter ? const Color(0xFFFF6B6B) : const Color(0xFF26DE81),
        child: AnimatedBuilder(
          animation: _dangerController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Role Icon
                Transform.scale(
                  scale: isImposter && _isDangerMode
                      ? 1.0 + (_dangerController.value * 0.1)
                      : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (isImposter ? const Color(0xFFFF6B6B) : const Color(0xFF26DE81))
                              .withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Icon(
                      isImposter ? Icons.person_remove : Icons.person,
                      size: 48,
                      color: isImposter ? const Color(0xFFFF6B6B) : const Color(0xFF26DE81),
                    ),
                  ),
                ),

                // Player Name
                Text(
                  player.name,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Role
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isImposter
                          ? [const Color(0xFFFF6B6B), const Color(0xFFE74C3C)]
                          : [const Color(0xFF26DE81), const Color(0xFF2ECC71)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (isImposter ? const Color(0xFFFF6B6B) : const Color(0xFF26DE81))
                            .withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    isImposter ? 'IMPOSTER' : 'CIVILIAN',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                )
                    .animate(
                      target: _isDangerMode ? 1 : 0,
                    )
                    .shimmer(
                      duration: 1000.ms,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),

                // Secret Word (for civilians only)
                if (!isImposter && player.secretWord != null) ...[
                  Text(
                    'Your Secret Word:',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26DE81).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF26DE81).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      player.secretWord!.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF26DE81),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ] else if (isImposter) ...[
                  Text(
                    'Find the secret word\nwithout revealing yourself',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF6B6B),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                // Tap instruction
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Tap to hide and continue',
                    style: GoogleFonts.montserrat(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            _isRevealed ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF4ECDC4),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isRevealed
                  ? 'Keep your role secret! Tap to hide and pass to next player'
                  : 'Pass the device to the next player, then tap to reveal their role',
              style: GoogleFonts.montserrat(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _revealRole(GameNotifier gameNotifier) {
    HapticFeedback.mediumImpact();
    _cardController.forward();
    gameNotifier.showRole();
  }

  void _hideAndNext(GameNotifier gameNotifier) {
    HapticFeedback.lightImpact();
    _cardController.reverse().then((_) {
      gameNotifier.hideRoleAndNext();
      _isDangerMode = false;
      _dangerController.stop();
      _dangerController.reset();
    });
  }
}