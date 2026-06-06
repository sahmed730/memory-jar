import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
        children: [
          _buildGroup(
            context,
            'Account',
            [
              _buildTile(
                context,
                icon: Icons.person_outline,
                title: 'Profile',
                showChevron: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
              _buildTile(context, icon: Icons.email_outlined, title: 'Email', value: 'maya@example.com'),
              _buildTile(context, icon: Icons.phone_outlined, title: 'Phone', value: '+1 555 0100'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGroup(
            context,
            'Delivery',
            [
              _buildTile(context, icon: Icons.send_outlined, title: 'Default channels', showChevron: true),
              _buildTile(context, icon: Icons.bedtime_outlined, title: 'Quiet hours', value: '10 PM - 8 AM'),
              _buildTile(context, icon: Icons.replay_outlined, title: 'Retry behavior', showChevron: true),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGroup(
            context,
            'Appearance',
            [
              _buildTile(context, icon: Icons.brightness_6_outlined, title: 'Theme', value: 'System default'),
              _buildTile(context, icon: Icons.animation_outlined, title: 'Reduced motion', trailing: Switch(value: false, onChanged: (v) {})),
              _buildTile(context, icon: Icons.text_fields, title: 'Text size', value: 'Comfortable'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGroup(
            context,
            'Privacy',
            [
              _buildTile(context, icon: Icons.security_outlined, title: 'Data & permissions', showChevron: true),
              _buildTile(context, icon: Icons.download_outlined, title: 'Export memories', showChevron: true),
              _buildTile(context, icon: Icons.delete_forever_outlined, title: 'Delete account', isDestructive: true),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildGroup(
            context,
            'About',
            [
              _buildTile(context, icon: Icons.info_outline, title: 'Version', value: '1.0.0'),
              _buildTile(context, icon: Icons.code_outlined, title: 'Open source licenses', showChevron: true),
              _buildTile(context, icon: Icons.help_outline, title: 'Help & feedback', showChevron: true),
              _buildTile(context, icon: Icons.logout_outlined, title: 'Sign out', isDestructive: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildGroup(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 1),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(height: 1, indent: 48, endIndent: 16, color: Theme.of(context).colorScheme.outlineVariant),
              ]
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? value,
    bool showChevron = false,
    Widget? trailing,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface;
    final iconColor = isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap ?? () {}, 
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(color: color),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing,
            ] else if (showChevron) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
