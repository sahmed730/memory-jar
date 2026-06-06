import 'package:flutter/material.dart';

import '../../models/memory.dart';
import '../../theme/app_spacing.dart';

class ChannelCard extends StatelessWidget {
  const ChannelCard({
    super.key,
    required this.channel,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    this.helperText,
  });

  final DeliveryChannel channel;
  final bool selected;
  final bool enabled;
  final String? helperText;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Opacity(
      opacity: enabled ? 1 : 0.38,
      child: Semantics(
        button: true,
        selected: selected,
        label: channel.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? () => onChanged(!selected) : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? scheme.primaryContainer : scheme.surface.withValues(alpha: 0.74),
              border: Border.all(color: selected ? scheme.primary : scheme.outlineVariant),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(_icon, color: selected ? scheme.primary : scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(channel.label, style: Theme.of(context).textTheme.titleSmall),
                        if (helperText != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            helperText!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Checkbox(
                    value: selected,
                    onChanged: enabled ? (value) => onChanged(value ?? false) : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData get _icon {
    return switch (channel) {
      DeliveryChannel.WHATSAPP => Icons.chat_bubble_outline,
      DeliveryChannel.PHONE_CALL => Icons.call_outlined,
      DeliveryChannel.SMS => Icons.sms_outlined,
      DeliveryChannel.EMAIL => Icons.mail_outline,
      DeliveryChannel.PUSH_NOTIFICATION => Icons.notifications_outlined,
    };
  }
}
