import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/game/domain/game_state.dart';
import '../features/game/application/game_notifier.dart';
import '../features/lobby/presentation/lobby_screen.dart';
import '../features/role_reveal/presentation/role_reveal_screen.dart';
import '../features/game/presentation/game_screen.dart';
import '../features/game/presentation/voting_screen.dart';
import '../features/game/presentation/game_over_screen.dart';
import '../features/game/presentation/elimination_result_screen.dart';
import '../shared/domain/player.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'lobby',
        builder: (context, state) => const LobbyScreen(),
      ),
      GoRoute(
        path: '/role-reveal',
        name: 'roleReveal',
        builder: (context, state) => const RoleRevealScreen(),
      ),
      GoRoute(
        path: '/game',
        name: 'game',
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: '/voting',
        name: 'voting',
        builder: (context, state) => const VotingScreen(),
      ),
      GoRoute(
        path: '/game-over',
        name: 'gameOver',
        builder: (context, state) => const GameOverScreen(),
      ),
      GoRoute(
        path: '/elimination-result',
        name: 'eliminationResult',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return EliminationResultScreen(
            eliminatedPlayerName: extra?['playerName'] as String? ?? '',
            eliminatedPlayerRole: extra?['playerRole'] as PlayerRole? ?? PlayerRole.civilian,
          );
        },
      ),
    ],
  );
});

// Navigation helper class
class AppNavigation {
  const AppNavigation._();

  static void toLobby(BuildContext context) {
    context.go('/');
  }

  static void toRoleReveal(BuildContext context) {
    context.go('/role-reveal');
  }

  static void toGame(BuildContext context) {
    context.go('/game');
  }

  static void toVoting(BuildContext context) {
    context.go('/voting');
  }

  static void toGameOver(BuildContext context) {
    context.go('/game-over');
  }
}