import 'package:flutter/material.dart';

import '../../../../shared/domain/player.dart';

class RoleCard extends StatelessWidget {
  final Player player;
  final String secretWord;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.player,
    required this.secretWord,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isImposter = player.role == PlayerRole.imposter;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isImposter ? Colors.red[900] : Colors.blue[900],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isImposter ? Colors.red : Colors.blue,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (isImposter ? Colors.red : Colors.blue).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Role Icon
            Icon(
              isImposter ? Icons.warning : Icons.shield,
              size: 80,
              color: isImposter ? Colors.red[300] : Colors.blue[300],
            ),
            const SizedBox(height: 24),

            // Player Name
            Text(
              player.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Role Text
            if (isImposter) ...[
              Text(
                'YOU ARE THE',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red[300],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'IMPOSTER',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⚠️ You don\'t know the secret word!\nBlend in with the conversation.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red[200],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              Text(
                'YOU ARE A',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'CIVILIAN',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Secret Word:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.blue[200],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      secretWord,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '🔍 Find the imposters who don\'t know this word!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue[200],
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Hide button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.visibility_off,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to Hide',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}