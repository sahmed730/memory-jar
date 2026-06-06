package com.memoryjar.memoryjarbackend.delivery;

public class DeliveryException extends RuntimeException {

    public DeliveryException(String message) {
        super(message);
    }

    public DeliveryException(String message, Throwable cause) {
        super(message, cause);
    }
}
