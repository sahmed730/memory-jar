package com.memoryjar.memoryjarbackend.controller;

import com.memoryjar.memoryjarbackend.model.Memory;
import com.memoryjar.memoryjarbackend.service.MemoryService;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class MemoryControllerTest {

    private final MemoryService memoryService = mock(MemoryService.class);
    private final MemoryController controller = new MemoryController(memoryService);

    @Test
    void createMemoryReturnsCreatedMemoryWithCreatedStatus() {
        Memory request = sampleMemory();
        Memory saved = sampleMemory();
        saved.setId(1L);
        when(memoryService.createMemory(request)).thenReturn(saved);

        var response = controller.createMemory(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isEqualTo(saved);
    }

    private static Memory sampleMemory() {
        return Memory.builder()
                .title("A small note")
                .content("Remember this day.")
                .type(Memory.MemoryType.TEXT)
                .deliveryDate(LocalDateTime.now().plusDays(1))
                .deliveryChannels(new LinkedHashSet<>(Set.of(Memory.DeliveryChannel.EMAIL)))
                .recipientIdentifier("maya@example.com")
                .build();
    }
}
