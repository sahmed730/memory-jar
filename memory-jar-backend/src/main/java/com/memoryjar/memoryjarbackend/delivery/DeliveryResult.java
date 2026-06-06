package com.memoryjar.memoryjarbackend.delivery;

import com.memoryjar.memoryjarbackend.model.Memory;

public record DeliveryResult(Memory.DeliveryChannel channel, String externalReference) {
}
