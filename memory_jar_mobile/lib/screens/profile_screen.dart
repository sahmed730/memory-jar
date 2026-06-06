import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.04), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.04, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutCubic));

    // Animate once on first paint
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pulseController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon.')),
              );
            },
            child: Text('Edit', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),
            // Avatar Hero
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Avatar upload available in Phase 3.')),
                      );
                    },
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Center(
                        child: Text(
                          'MY',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontFamily: 'Fraunces',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Maya Y.', style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'maya@example.com',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatsCard(
                    title: 'Sealed',
                    number: '12',
                    subtitle: 'Still waiting',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatsCard(
                    title: 'Sent',
                    number: '3',
                    subtitle: 'This year',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xxl),
            
            // Public/Shared Memories Placeholder
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Public Memories', style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'Public sharing will be available in Phase 5.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String number;
  final String subtitle;

  const _StatsCard({
    required this.title,
    required this.number,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 88,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleMedium),
              Text(
                number,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontFamily: 'Fraunces',
                  color: theme.colorScheme.primary,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
