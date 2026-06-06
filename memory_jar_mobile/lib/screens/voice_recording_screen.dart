import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class VoiceRecordingScreen extends StatefulWidget {
  const VoiceRecordingScreen({super.key});

  @override
  State<VoiceRecordingScreen> createState() => _VoiceRecordingScreenState();
}

class _VoiceRecordingScreenState extends State<VoiceRecordingScreen> with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _hasRecorded = false;
  int _recordDuration = 0;
  Timer? _timer;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.reverse();
      } else if (status == AnimationStatus.dismissed && _isRecording) {
        _pulseController.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _recordDuration = 0;
    });
    _pulseController.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
    // Actual recording logic with `record` package goes here.
  }

  void _stopRecording() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.animateTo(1.0, duration: const Duration(milliseconds: 600), curve: Curves.elasticOut);
    setState(() {
      _isRecording = false;
      _hasRecorded = true;
    });
    // Stop recording logic here.
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.8),
            radius: 1.2,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // balance
                  Text('Voice note', style: theme.textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Spacer(),
              
              // Recorder Button
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording ? theme.colorScheme.primary.withValues(alpha: 0.15) : theme.colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: _isRecording ? theme.colorScheme.primary.withValues(alpha: 0.5) : theme.colorScheme.outlineVariant,
                            width: 2,
                          ),
                          boxShadow: _isRecording ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 4 * _pulseAnimation.value,
                            )
                          ] : [],
                        ),
                        child: Center(
                          child: Icon(
                            _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                            size: 40,
                            color: _isRecording ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Timer
              Text(
                _formatDuration(_recordDuration),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontFamily: 'JetBrains Mono',
                  color: _isRecording ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              // Waveform Placeholder
              SizedBox(
                height: 64,
                width: double.infinity,
                child: Center(
                  child: Text(
                    _isRecording ? 'Recording... (Waveform active)' : (_hasRecorded ? 'Playback Waveform' : 'Ready to record'),
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Bottom Actions
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                    ),
                    FilledButton(
                      onPressed: _hasRecorded && _recordDuration >= 1 ? () {
                        // Return the file path
                        Navigator.pop(context, "dummy_audio_path.m4a");
                      } : null,
                      child: const Text('Use this'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
