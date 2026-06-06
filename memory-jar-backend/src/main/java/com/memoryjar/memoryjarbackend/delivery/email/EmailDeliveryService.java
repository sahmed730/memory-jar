package com.memoryjar.memoryjarbackend.delivery.email;

import com.memoryjar.memoryjarbackend.delivery.DeliveryException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailDeliveryService {

    private final ObjectProvider<JavaMailSender> mailSenderProvider;

    @Value("${memory-jar.email.from:no-reply@memoryjar.local}")
    private String fromAddress;

    public void sendEmail(String recipientIdentifier, String subject, String message) {
        JavaMailSender mailSender = mailSenderProvider.getIfAvailable();
        if (mailSender == null) {
            throw new DeliveryException("Spring mail is not configured");
        }

        SimpleMailMessage mailMessage = new SimpleMailMessage();
        mailMessage.setFrom(fromAddress);
        mailMessage.setTo(recipientIdentifier);
        mailMessage.setSubject(subject);
        mailMessage.setText(message);
        mailSender.send(mailMessage);
    }
}
