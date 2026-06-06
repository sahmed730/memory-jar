package com.memoryjar.memoryjarbackend.delivery.twilio;

import com.memoryjar.memoryjarbackend.delivery.DeliveryException;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import com.twilio.type.Twiml;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
@RequiredArgsConstructor
public class TwilioDeliveryService {

    private final TwilioProperties properties;

    public String sendWhatsApp(String recipientIdentifier, String message) {
        initialize();
        require(properties.getWhatsappNumber(), "twilio.whatsapp.number");

        Message sentMessage = Message.creator(
                new PhoneNumber("whatsapp:" + normalizePhone(recipientIdentifier)),
                new PhoneNumber("whatsapp:" + normalizePhone(properties.getWhatsappNumber())),
                message
        ).create();

        return sentMessage.getSid();
    }

    public String sendSms(String recipientIdentifier, String message) {
        initialize();
        require(properties.getSmsNumber(), "twilio.sms.number");

        Message sentMessage = Message.creator(
                new PhoneNumber(normalizePhone(recipientIdentifier)),
                new PhoneNumber(normalizePhone(properties.getSmsNumber())),
                message
        ).create();

        return sentMessage.getSid();
    }

    public String makePhoneCall(String recipientIdentifier, String mediaUrl) {
        initialize();
        require(properties.getVoiceNumber(), "twilio.voice.number");
        require(mediaUrl, "mediaUrl");

        String twiml = "<Response><Play>" + escapeXml(mediaUrl) + "</Play></Response>";
        Call call = Call.creator(
                new PhoneNumber(normalizePhone(recipientIdentifier)),
                new PhoneNumber(normalizePhone(properties.getVoiceNumber())),
                new Twiml(twiml)
        ).create();

        return call.getSid();
    }

    private void initialize() {
        require(properties.getAccountSid(), "twilio.account.sid");
        require(properties.getAuthToken(), "twilio.auth.token");
        Twilio.init(properties.getAccountSid(), properties.getAuthToken());
    }

    private static void require(String value, String propertyName) {
        if (!StringUtils.hasText(value)) {
            throw new DeliveryException(propertyName + " is not configured");
        }
    }

    private static String normalizePhone(String value) {
        return value.trim();
    }

    private static String escapeXml(String value) {
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&apos;");
    }
}
