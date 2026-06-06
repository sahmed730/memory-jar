package com.memoryjar.memoryjarbackend.delivery.twilio;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "twilio")
public class TwilioProperties {

    private String accountSid;
    private String authToken;
    private String whatsappNumber;
    private String smsNumber;
    private String voiceNumber;
}
