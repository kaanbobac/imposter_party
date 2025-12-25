import 'package:flutter/material.dart';

class GameTimerWidget extends StatelessWidget {
  final int timeRemaining;
  final String formattedTime;
  final bool isRunning;

  const GameTimerWidget({
    super.key,
    required this.timeRemaining,
    required this.formattedTime,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    final progress = timeRemaining / 300.0; // Assuming 5 minutes default
    final isLowTime = timeRemaining <= 60; // Last minute
    final isVeryLowTime = timeRemaining <= 30; // Last 30 seconds

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVeryLowTime
              ? Colors.red
              : isLowTime
                  ? Colors.orange
                  : Colors.grey[600]!,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Timer Icon and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isRunning ? Icons.timer : Icons.timer_off,
                color: isVeryLowTime
                    ? Colors.red
                    : isLowTime
                        ? Colors.orange
                        : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isRunning ? 'Time Remaining' : 'Timer Paused',
                style: TextStyle(
                  color: isVeryLowTime
                      ? Colors.red
                      : isLowTime
                          ? Colors.orange
                          : Colors.grey[300],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Large Timer Display
          Text(
            formattedTime,
            style: TextStyle(
              color: isVeryLowTime
                  ? Colors.red
                  : isLowTime
                      ? Colors.orange
                      : Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),

          const SizedBox(height: 16),

          // Progress Bar
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              isVeryLowTime
                  ? Colors.red
                  : isLowTime
                      ? Colors.orange
                      : Colors.blue,
            ),
          ),

          if (isLowTime) ...[
            const SizedBox(height: 8),
            Text(
              isVeryLowTime ? '⚠️ HURRY UP!' : '⏰ Time is running low',
              style: TextStyle(
                color: isVeryLowTime ? Colors.red : Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}