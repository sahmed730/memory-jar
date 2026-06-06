package com.memoryjar.memoryjarbackend.util;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class StringEncryptorConverter implements AttributeConverter<String, String> {

    @Override
    public String convertToDatabaseColumn(String attribute) {
        if (attribute == null) {
            return null;
        }
        return EncryptionUtil.encrypt(attribute);
    }

    @Override
    public String convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }
        // Basic check to prevent crash if data is not Base64 encrypted
        // Normally you'd migrate legacy data, but for v1 we attempt decrypt.
        try {
            return EncryptionUtil.decrypt(dbData);
        } catch (Exception e) {
            return dbData; // Return as-is if decryption fails (e.g., plain text dev data)
        }
    }
}
