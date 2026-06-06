import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../ui/components/memory_card.dart';
import '../ui/effects/glass_panel.dart';
import '../ui/effects/jar_mark.dart';
import '../ui/effects/soft_background.dart';
import '../ui/patterns/state_panels.dart';
import 'create_memory_screen.dart';
import 'memory_detail_screen.dart';
import 'settings_screen.dart';

enum _MemoryFilter { all, sealed, openingSoon, delivered, failed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Memory>> _memoriesFuture;
  _MemoryFilter _filter = _MemoryFilter.all;

  @override
  void initState() {
    super.initState();
    _refreshMemories();
  }

  void _refreshMemories() {
    setState(() {
      _memoriesFuture = _apiService.getMemories();
    });
  }

  Future<void> _openCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMemoryScreen()),
    );
    if (result == true) {
      _refreshMemories();
    }
  }

  Future<void> _deleteMemory(Memory memory) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Put this one back?'),
          content: Text('This cancels "${memory.title}" and removes it from your jar.'),
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

    if (confirmed != true || memory.id == null) {
      return;
    }

    try {
      await _apiService.deleteMemory(memory.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Memory cancelled.')),
        );
      }
      _refreshMemories();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("We couldn't cancel that memory. $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SoftBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Memory Jar', style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
              tooltip: 'Refresh jar',
              icon: const Icon(Icons.refresh_outlined),
              onPressed: _refreshMemories,
            ),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: FutureBuilder<List<Memory>>(
          future: _memoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MemorySkeletonList();
            }

            if (snapshot.hasError) {
              return Column(
                children: [
                  ErrorBanner(
                    message: "We couldn't load your jar.",
                    onRetry: _refreshMemories,
                  ),
                  Expanded(
                    child: EmptyJarPanel(onCreate: _openCreate),
                  ),
                ],
              );
            }

            final memories = (snapshot.data ?? [])
              ..sort((a, b) => a.deliveryDate.compareTo(b.deliveryDate));
            if (memories.isEmpty) {
              return EmptyJarPanel(onCreate: _openCreate);
            }

            final visibleMemories = _filtered(memories);
            return RefreshIndicator(
              onRefresh: () async => _refreshMemories(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 96),
                children: [
                  _HeroStrip(memories: memories),
                  const SizedBox(height: AppSpacing.lg),
                  _FilterRow(
                    selected: _filter,
                    onChanged: (filter) => setState(() => _filter = filter),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (visibleMemories.isEmpty)
                    _NoFilteredResults(onReset: () => setState(() => _filter = _MemoryFilter.all))
                  else
                    ..._memoryCards(visibleMemories),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openCreate,
          icon: const Icon(Icons.add),
          label: const Text('New memory'),
        ),
      ),
    );
  }

  List<Memory> _filtered(List<Memory> memories) {
    final now = DateTime.now();
    return switch (_filter) {
      _MemoryFilter.all => memories,
      _MemoryFilter.sealed => memories.where((memory) => memory.status == MemoryStatus.PENDING).toList(),
      _MemoryFilter.openingSoon => memories
          .where(
            (memory) =>
                memory.status == MemoryStatus.PENDING &&
                memory.deliveryDate.isAfter(now) &&
                memory.deliveryDate.difference(now).inDays <= 30,
          )
          .toList(),
      _MemoryFilter.delivered => memories.where((memory) => memory.status == MemoryStatus.DELIVERED).toList(),
      _MemoryFilter.failed => memories.where((memory) => memory.status == MemoryStatus.FAILED).toList(),
    };
  }

  List<Widget> _memoryCards(List<Memory> memories) {
    final widgets = <Widget>[];
    for (var index = 0; index < memories.length; index++) {
      widgets.add(
        MemoryCard(
          key: ValueKey(memories[index].id ?? '${memories[index].title}-$index'),
          memory: memories[index],
          onDelete: () => _deleteMemory(memories[index]),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MemoryDetailScreen(memory: memories[index])),
            );
            if (result == true) {
              _refreshMemories();
            }
          },
        ),
      );
      widgets.add(const SizedBox(height: AppSpacing.md));
    }
    return widgets;
  }
}

class _HeroStrip extends StatelessWidget {
  const _HeroStrip({required this.memories});

  final List<Memory> memories;

  @override
  Widget build(BuildContext context) {
    final sealed = memories.where((memory) => memory.status == MemoryStatus.PENDING).length;
    final delivered = memories.where((memory) => memory.status == MemoryStatus.DELIVERED).length;
    final openingThisMonth = memories.where((memory) {
      final now = DateTime.now();
      return memory.status == MemoryStatus.PENDING &&
          memory.deliveryDate.isAfter(now) &&
          memory.deliveryDate.difference(now).inDays <= 30;
    }).length;

    return GlassPanel(
      child: Row(
        children: [
          const JarMark(size: 82),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your jar', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$sealed sealed, $openingThisMonth opening this month, $delivered delivered',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onChanged});

  final _MemoryFilter selected;
  final ValueChanged<_MemoryFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _chip(context, _MemoryFilter.all, 'All'),
          _chip(context, _MemoryFilter.sealed, 'Sealed'),
          _chip(context, _MemoryFilter.openingSoon, 'Opening soon'),
          _chip(context, _MemoryFilter.delivered, 'Delivered'),
          _chip(context, _MemoryFilter.failed, 'Needs attention'),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, _MemoryFilter filter, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        selected: selected == filter,
        onSelected: (_) => onChanged(filter),
        label: Text(label),
      ),
    );
  }
}

class _NoFilteredResults extends StatelessWidget {
  const _NoFilteredResults({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        children: [
          const Icon(Icons.filter_alt_off_outlined, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text('Nothing here yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Try a different view of your jar.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(onPressed: onReset, child: const Text('Show all')),
        ],
      ),
    );
  }
}
