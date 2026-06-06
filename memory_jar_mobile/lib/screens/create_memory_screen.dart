import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../services/api_service.dart';
import '../ui/components/section_header.dart';
import '../ui/components/inputs.dart';
import '../ui/components/tiles.dart';
import '../ui/components/channel_card.dart';
import 'voice_recording_screen.dart';

class CreateMemoryScreen extends StatefulWidget {
  const CreateMemoryScreen({super.key});

  @override
  State<CreateMemoryScreen> createState() => _CreateMemoryScreenState();
}

class _CreateMemoryScreenState extends State<CreateMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  String _content = '';
  MemoryType _selectedType = MemoryType.TEXT;
  String _recipientType = 'Myself';
  String _recipientIdentifier = '';
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _deliveryTime = TimeOfDay.now();
  List<DeliveryChannel> _selectedChannels = [DeliveryChannel.WHATSAPP];
  
  bool _isSaving = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _deliveryTime,
    );
    if (picked != null && picked != _deliveryTime) {
      setState(() {
        _deliveryTime = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      if (_selectedChannels.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one delivery channel.')),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      final finalDate = DateTime(
        _deliveryDate.year,
        _deliveryDate.month,
        _deliveryDate.day,
        _deliveryTime.hour,
        _deliveryTime.minute,
      );

      final newMemory = Memory(
        title: _content.split('\n').first.substring(0, _content.length > 20 ? 20 : _content.length), // generate title
        content: _content,
        type: _selectedType,
        deliveryDate: finalDate,
        deliveryChannels: _selectedChannels,
        recipientIdentifier: _recipientType == 'Myself' ? 'self' : _recipientIdentifier,
      );

      try {
        await _apiService.createMemory(newMemory);
        if (mounted) {
          // Success! Show confirmation sheet or just pop back to Home for now
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Capture Memory'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _submitForm,
            child: _isSaving 
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('Save', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SectionHeader(title: "What's on your mind?"),
                const SizedBox(height: 16),
                MemoryTextField(
                  label: 'Message',
                  placeholder: 'Write something to your future self...',
                  maxLines: 8,
                  validator: (value) => value!.isEmpty ? 'Enter a message' : null,
                  onSaved: (value) => _content = value!,
                ),
                const SizedBox(height: 16),
                MemoryChoiceChips<MemoryType>(
                  options: const [MemoryType.TEXT, MemoryType.AUDIO, MemoryType.IMAGE, MemoryType.VIDEO],
                  selectedOption: _selectedType,
                  labelBuilder: (type) => type.name,
                  onSelected: (type) async {
                    if (type == MemoryType.AUDIO) {
                      final audioPath = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VoiceRecordingScreen()),
                      );
                      if (audioPath != null) {
                        setState(() {
                          _selectedType = MemoryType.AUDIO;
                          _content = "Voice note attached: $audioPath";
                        });
                      }
                    } else if (type == MemoryType.IMAGE || type == MemoryType.VIDEO) {
                      // We don't have image_picker imported, but the logic would look like:
                      // final picker = ImagePicker();
                      // final xFile = type == MemoryType.IMAGE ? await picker.pickImage(...) : await picker.pickVideo(...);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Picker opened for ${type.name} (Implementation placeholder)')),
                      );
                      setState(() {
                         _selectedType = type;
                         _content = "Media attached: dummy_${type.name.toLowerCase()}.file";
                      });
                    } else {
                       setState(() => _selectedType = MemoryType.TEXT);
                    }
                  },
                ),
                
                const SizedBox(height: 32),
                const SectionHeader(title: "Send to"),
                const SizedBox(height: 16),
                MemoryChoiceChips<String>(
                  options: const ['Myself', 'Someone else', 'The world (public, future)'],
                  selectedOption: _recipientType,
                  labelBuilder: (v) => v,
                  onSelected: (val) {
                    setState(() => _recipientType = val);
                    if (val == 'The world (public, future)') {
                      ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Public sharing will be available in Phase 5+.')),
                       );
                       setState(() => _recipientType = 'Myself');
                    }
                  },
                ),
                if (_recipientType == 'Someone else') ...[
                  const SizedBox(height: 16),
                  MemoryTextField(
                    label: 'Recipient (Phone or Email)',
                    placeholder: 'Who should receive this?',
                    validator: (value) => value!.isEmpty ? 'Enter recipient' : null,
                    onSaved: (value) => _recipientIdentifier = value!,
                  ),
                ],

                const SizedBox(height: 32),
                const SectionHeader(title: "Open on"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: DateTile(
                        title: 'Date',
                        date: _deliveryDate,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TimeTile(
                        title: 'Time',
                        time: _deliveryTime,
                        onTap: () => _selectTime(context),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                const SectionHeader(title: "How should it arrive?"),
                const SizedBox(height: 16),
                ...DeliveryChannel.values.map((channel) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ChannelCard(
                      channel: channel,
                      selected: _selectedChannels.contains(channel),
                      helperText: _getSubtitleForChannel(channel),
                      onChanged: (selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedChannels.add(channel);
                          } else {
                            _selectedChannels.remove(channel);
                          }
                        });
                      },
                    ),
                  );
                }),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSubtitleForChannel(DeliveryChannel channel) {
    switch (channel) {
      case DeliveryChannel.WHATSAPP:
        return 'Receive a message on WhatsApp';
      case DeliveryChannel.EMAIL:
        return 'Get an email with your memory';
      case DeliveryChannel.SMS:
        return 'Standard text message';
      case DeliveryChannel.PHONE_CALL:
        return 'An automated voice call';
      case DeliveryChannel.PUSH_NOTIFICATION:
        return 'Push notification on your phone';
    }
  }
}
