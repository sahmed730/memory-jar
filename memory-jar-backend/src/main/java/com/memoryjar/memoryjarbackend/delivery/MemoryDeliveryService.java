package com.memoryjar.memoryjarbackend.delivery;

import com.memoryjar.memoryjarbackend.delivery.email.EmailDeliveryService;
import com.memoryjar.memoryjarbackend.delivery.twilio.TwilioDeliveryService;
import com.memoryjar.memoryjarbackend.model.Memory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MemoryDeliveryService implements DeliveryService {

    private final TwilioDeliveryService twilioDeliveryService;
    private final EmailDeliveryService emailDeliveryService;

    @Override
    public DeliveryResult deliver(Memory memory, Memory.DeliveryChannel channel) {
        return switch (channel) {
            case WHATSAPP -> sendWhatsApp(memory.getRecipientIdentifier(), memory.getContent());
            case PHONE_CALL -> makePhoneCall(memory.getRecipientIdentifier(), memory.getMediaUrl());
            case SMS -> sendSms(memory.getRecipientIdentifier(), memory.getContent());
            case EMAIL -> sendEmail(memory.getRecipientIdentifier(), memory.getTitle(), memory.getContent());
            case PUSH_NOTIFICATION -> throw new DeliveryException(
                    "Push notifications require a device-token integration before they can be delivered"
            );
        };
    }

    @Override
    public DeliveryResult sendWhatsApp(String recipientIdentifier, String message) {
        String sid = twilioDeliveryService.sendWhatsApp(recipientIdentifier, message);
        return new DeliveryResult(Memory.DeliveryChannel.WHATSAPP, sid);
    }

    @Override
    public DeliveryResult makePhoneCall(String recipientIdentifier, String mediaUrl) {
        String sid = twilioDeliveryService.makePhoneCall(recipientIdentifier, mediaUrl);
        return new DeliveryResult(Memory.DeliveryChannel.PHONE_CALL, sid);
    }

    @Override
    public DeliveryResult sendSms(String recipientIdentifier, String message) {
        String sid = twilioDeliveryService.sendSms(recipientIdentifier, message);
        return new DeliveryResult(Memory.DeliveryChannel.SMS, sid);
    }

    @Override
    public DeliveryResult sendEmail(String recipientIdentifier, String subject, String message) {
        emailDeliveryService.sendEmail(recipientIdentifier, subject, message);
        return new DeliveryResult(Memory.DeliveryChannel.EMAIL, null);
    }
}
