import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSettingsCard(
              icon: Icons.star_rounded,
              iconColor: Colors.amber,
              title: 'Total Stars Earned',
              subtitle: '${appState.stars} stars',
              trailing: const Icon(Icons.star,
                  color: Colors.amber, size: 28),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              icon: Icons.monetization_on_rounded,
              iconColor: Colors.orange,
              title: 'Total Coins Earned',
              subtitle: '${appState.coins} coins',
              trailing: const Icon(Icons.monetization_on_rounded,
                  color: Colors.orange, size: 28),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              icon: Icons.check_circle_rounded,
              iconColor: AppTheme.green,
              title: 'Lessons Completed',
              subtitle:
                  '${appState.completedLessons.length} lessons done',
              trailing: const Icon(Icons.check_circle,
                  color: AppTheme.green, size: 28),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard(
              icon: Icons.emoji_events_rounded,
              iconColor: AppTheme.yellow,
              title: 'Badges Earned',
              subtitle:
                  '${appState.earnedBadges.length} badges collected',
              trailing: const Icon(Icons.emoji_events,
                  color: AppTheme.yellow, size: 28),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showResetDialog(context),
                icon: const Icon(Icons.delete_sweep_rounded,
                    color: Colors.white),
                label: const Text(
                  'Reset All Progress',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ARWA v1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Text('⚠️ '),
            Text('Reset Progress',
                style: TextStyle(color: AppTheme.red)),
          ],
        ),
        content: const Text(
          'Are you sure? This will delete all your stars, coins, badges, and completed lessons!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppStateProvider>().resetProgress();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Progress reset successfully'),
                  backgroundColor: AppTheme.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.red,
            ),
            child: const Text('Reset',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
