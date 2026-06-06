import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/memory.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../ui/components/buttons.dart';
import '../ui/effects/glass_panel.dart';

class MemoryDetailScreen extends StatefulWidget {
  final Memory memory;

  const MemoryDetailScreen({super.key, required this.memory});

  @override
  State<MemoryDetailScreen> createState() => _MemoryDetailScreenState();
}

class _MemoryDetailScreenState extends State<MemoryDetailScreen> {
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;

  void _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Put this one back?'),
          content: const Text('This cancels the memory and removes it from your jar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No, keep it'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes, cancel it'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _isProcessing = true);
      try {
        await _apiService.deleteMemory(widget.memory.id!);
        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate deletion
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateFormat('MMMM d, yyyy').format(widget.memory.deliveryDate);
    final time = DateFormat('h:mm a').format(widget.memory.deliveryDate);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Editing will be available soon.')),
              );
            },
          ),
        ],
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Header
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            blurRadius: 24,
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Icon(
                        _typeIcon(widget.memory.type),
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      widget.memory.type.name,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Text(
                      widget.memory.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontFamily: 'Fraunces',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Content Block
                  Text(
                    widget.memory.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Metadata Card
                  GlassPanel(
                    borderRadius: 16,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetaRow(context, Icons.person_outline, 'Recipient', widget.memory.recipientIdentifier),
                          const Divider(height: 32),
                          _buildMetaRow(context, Icons.calendar_today_outlined, 'Delivery Date', '$date at $time'),
                          const Divider(height: 32),
                          _buildMetaRow(context, Icons.send_outlined, 'Channels', widget.memory.deliveryChannels.map((c) => c.label).join(', ')),
                          const Divider(height: 32),
                          _buildMetaRow(context, Icons.info_outline, 'Status', widget.memory.status.label),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _confirmDelete,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.error),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Cancel Memory', style: TextStyle(color: theme.colorScheme.error)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  label: 'Send Now',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Send Now feature coming soon.')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
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
}
