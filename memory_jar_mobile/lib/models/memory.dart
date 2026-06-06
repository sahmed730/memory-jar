enum MemoryType { TEXT, AUDIO, IMAGE, VIDEO, DOCUMENT }
enum DeliveryChannel { WHATSAPP, PHONE_CALL, SMS, EMAIL, PUSH_NOTIFICATION }
enum MemoryStatus { PENDING, DELIVERED, FAILED }

class Memory {
  final int? id;
  final String title;
  final String content;
  final MemoryType type;
  final String? mediaUrl;
  final DateTime deliveryDate;
  final List<DeliveryChannel> deliveryChannels;
  final MemoryStatus status;
  final String recipientIdentifier;
  final DateTime? createdAt;
  final DateTime? deliveredAt;
  final String? lastError;

  Memory({
    this.id,
    required this.title,
    required this.content,
    required this.type,
    this.mediaUrl,
    required this.deliveryDate,
    required this.deliveryChannels,
    this.status = MemoryStatus.PENDING,
    required this.recipientIdentifier,
    this.createdAt,
    this.deliveredAt,
    this.lastError,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: MemoryType.values.byName(json['type']),
      mediaUrl: json['mediaUrl'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryChannels: (json['deliveryChannels'] as List)
          .map((e) => DeliveryChannel.values.byName(e))
          .toList(),
      status: MemoryStatus.values.byName(json['status']),
      recipientIdentifier: json['recipientIdentifier'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      lastError: json['lastError'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryChannels': deliveryChannels.map((e) => e.name).toList(),
      'status': status.name,
      'recipientIdentifier': recipientIdentifier,
      'createdAt': createdAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'lastError': lastError,
    };
  }
}

extension MemoryTypeLabel on MemoryType {
  String get label {
    return switch (this) {
      MemoryType.TEXT => 'Text',
      MemoryType.AUDIO => 'Voice',
      MemoryType.IMAGE => 'Photo',
      MemoryType.VIDEO => 'Video',
      MemoryType.DOCUMENT => 'Document',
    };
  }
}

extension DeliveryChannelLabel on DeliveryChannel {
  String get label {
    return switch (this) {
      DeliveryChannel.WHATSAPP => 'WhatsApp',
      DeliveryChannel.PHONE_CALL => 'Phone call',
      DeliveryChannel.SMS => 'SMS',
      DeliveryChannel.EMAIL => 'Email',
      DeliveryChannel.PUSH_NOTIFICATION => 'Push',
    };
  }
}

extension MemoryStatusLabel on MemoryStatus {
  String get label {
    return switch (this) {
      MemoryStatus.PENDING => 'Sealed',
      MemoryStatus.DELIVERED => 'Delivered',
      MemoryStatus.FAILED => 'Needs attention',
    };
  }
}
