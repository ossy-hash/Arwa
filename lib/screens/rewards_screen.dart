import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/reward_model.dart';
import '../utils/theme.dart';
import '../utils/data_loader.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  List<RewardModel>? _rewards;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rewards = await DataLoader.loadRewards();
    setState(() {
      _rewards = rewards;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Rewards')),
      body: _loaded
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatsHeader(appState),
                  const SizedBox(height: 24),
                  _buildProgressSection(appState),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '🏅 Badges & Achievements',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.purple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._rewards!.map((reward) => _buildBadgeCard(
                        reward: reward,
                        earned: appState.hasBadge(reward.id),
                      )),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildStatsHeader(AppStateProvider appState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.yellow, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('⭐', 'Stars', '${appState.stars}'),
          _buildStatItem('🪙', 'Coins', '${appState.coins}'),
          _buildStatItem('🏅', 'Badges',
              '${appState.earnedBadges.length}/${_rewards?.length ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 36)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(AppStateProvider appState) {
    const int totalLessons = 29;
    final completed = appState.completedLessons.length;
    final badges = _rewards?.length ?? 1;
    final earned = appState.earnedBadges.length;
    final progress = (completed / totalLessons).clamp(0.0, 1.0);
    final badgeProgress = (earned / badges).clamp(0.0, 1.0);

    return Column(
      children: [
        _buildProgressRow('📚 Lessons', progress, '$completed/$totalLessons'),
        const SizedBox(height: 12),
        _buildProgressRow('🏅 Badges', badgeProgress, '$earned/$badges'),
      ],
    );
  }

  Widget _buildProgressRow(String label, double progress, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.purple),
                minHeight: 14,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard({
    required RewardModel reward,
    required bool earned,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: earned ? AppTheme.yellow : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: earned ? AppTheme.yellow.withValues(alpha: 0.2) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                earned ? reward.emoji : '🔒',
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: earned ? AppTheme.darkPurple : Colors.grey,
                  ),
                ),
                Text(
                  reward.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: earned ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: earned ? AppTheme.green.withValues(alpha: 0.15) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              earned ? '✅ Earned' : 'Locked',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: earned ? AppTheme.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
