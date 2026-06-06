import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/memory.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../effects/glass_panel.dart';

class MemoryCard extends StatefulWidget {
  const MemoryCard({
    super.key,
    required this.memory,
    required this.onDelete,
    this.onTap,
  });

  final Memory memory;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d, yyyy h:mm a').format(widget.memory.deliveryDate);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: GlassPanel(
          borderRadius: 16,
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_typeIcon(widget.memory.type), size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              _StatusPill(status: widget.memory.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.memory.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.memory.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Chip(icon: Icons.person_outline, label: widget.memory.recipientIdentifier),
              for (final channel in widget.memory.deliveryChannels)
                _Chip(icon: _channelIcon(channel), label: channel.label),
            ],
          ),
          if (widget.memory.lastError != null && widget.memory.lastError!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        widget.memory.lastError!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Cancel memory',
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),
    ),
   ),
  );
 }

  IconData _typeIcon(MemoryType type) {
    return switch (type) {
      MemoryType.TEXT => Icons.notes_outlined,
      MemoryType.AUDIO => Icons.mic_none_outlined,
      MemoryType.IMAGE => Icons.image_outlined,
      MemoryType.VIDEO => Icons.videocam_outlined,
      MemoryType.DOCUMENT => Icons.description_outlined,
    };
  }

  IconData _channelIcon(DeliveryChannel channel) {
    return switch (channel) {
      DeliveryChannel.WHATSAPP => Icons.chat_bubble_outline,
      DeliveryChannel.PHONE_CALL => Icons.call_outlined,
      DeliveryChannel.SMS => Icons.sms_outlined,
      DeliveryChannel.EMAIL => Icons.mail_outline,
      DeliveryChannel.PUSH_NOTIFICATION => Icons.notifications_outlined,
    };
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final MemoryStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      MemoryStatus.PENDING => AppColors.warning,
      MemoryStatus.DELIVERED => AppColors.tertiary,
      MemoryStatus.FAILED => AppColors.error,
    };
    final icon = switch (status) {
      MemoryStatus.PENDING => Icons.lock_outline,
      MemoryStatus.DELIVERED => Icons.check_circle_outline,
      MemoryStatus.FAILED => Icons.error_outline,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: AppSpacing.xs),
            Text(status.label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
