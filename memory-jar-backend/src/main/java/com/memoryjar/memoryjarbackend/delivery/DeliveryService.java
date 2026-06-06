package com.memoryjar.memoryjarbackend.delivery;

import com.memoryjar.memoryjarbackend.model.Memory;

public interface DeliveryService {

    DeliveryResult deliver(Memory memory, Memory.DeliveryChannel channel);

    DeliveryResult sendWhatsApp(String recipientIdentifier, String message);

    DeliveryResult makePhoneCall(String recipientIdentifier, String mediaUrl);

    DeliveryResult sendSms(String recipientIdentifier, String message);

    DeliveryResult sendEmail(String recipientIdentifier, String subject, String message);
}
