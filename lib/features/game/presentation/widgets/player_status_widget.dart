import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/domain/player.dart';

class PlayerStatusWidget extends StatelessWidget {
  final List<Player> players;
  final int imposterCount;

  const PlayerStatusWidget({
    super.key,
    required this.players,
    required this.imposterCount,
  });

  @override
  Widget build(BuildContext context) {
    final activePlayers = players.where((p) => !p.isEliminated).length;
    final eliminatedPlayers = players.length - activePlayers;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            AppStrings.gameStatus,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Active Players
              Expanded(
                child: _buildStatusCard(
                  context,
                  icon: Icons.group,
                  label: AppStrings.activePlayers,
                  value: activePlayers.toString(),
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              // Imposters
              Expanded(
                child: _buildStatusCard(
                  context,
                  icon: Icons.warning,
                  label: AppStrings.impostersLabel,
                  value: imposterCount.toString(),
                  color: Colors.red,
                ),
              ),
              if (eliminatedPlayers > 0) ...[
                const SizedBox(width: 12),
                // Eliminated
                Expanded(
                  child: _buildStatusCard(
                    context,
                    icon: Icons.remove_circle,
                    label: AppStrings.eliminatedPlayers,
                    value: eliminatedPlayers.toString(),
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}