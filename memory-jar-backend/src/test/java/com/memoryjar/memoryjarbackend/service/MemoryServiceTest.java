package com.memoryjar.memoryjarbackend.service;

import com.memoryjar.memoryjarbackend.delivery.DeliveryException;
import com.memoryjar.memoryjarbackend.delivery.DeliveryService;
import com.memoryjar.memoryjarbackend.model.DeliveryAttempt;
import com.memoryjar.memoryjarbackend.model.Memory;
import com.memoryjar.memoryjarbackend.repository.DeliveryAttemptRepository;
import com.memoryjar.memoryjarbackend.repository.MemoryRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MemoryServiceTest {

    @Mock
    private MemoryRepository memoryRepository;

    @Mock
    private DeliveryAttemptRepository deliveryAttemptRepository;

    @Mock
    private DeliveryService deliveryService;

    @InjectMocks
    private MemoryService memoryService;

    @Test
    void createMemoryResetsClientControlledDeliveryState() {
        Memory input = sampleMemory();
        input.setId(99L);
        input.setStatus(Memory.MemoryStatus.DELIVERED);
        input.setDeliveredAt(LocalDateTime.now());
        input.setLastError("client supplied");
        when(memoryRepository.save(any(Memory.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Memory saved = memoryService.createMemory(input);

        assertThat(saved.getId()).isNull();
        assertThat(saved.getStatus()).isEqualTo(Memory.MemoryStatus.PENDING);
        assertThat(saved.getDeliveredAt()).isNull();
        assertThat(saved.getLastError()).isNull();
    }

    @Test
    void deliverMemoryMarksFailedAndRecordsAttemptWhenChannelFails() {
        Memory memory = sampleMemory();
        memory.setId(7L);
        memory.setDeliveryChannels(new LinkedHashSet<>(Set.of(Memory.DeliveryChannel.SMS)));
        when(memoryRepository.findById(7L)).thenReturn(Optional.of(memory));
        when(deliveryService.deliver(memory, Memory.DeliveryChannel.SMS))
                .thenThrow(new DeliveryException("twilio.sms.number is not configured"));

        memoryService.deliverMemory(memory);

        assertThat(memory.getStatus()).isEqualTo(Memory.MemoryStatus.FAILED);
        assertThat(memory.getLastError()).contains("SMS: twilio.sms.number is not configured");
        ArgumentCaptor<DeliveryAttempt> attemptCaptor = ArgumentCaptor.forClass(DeliveryAttempt.class);
        verify(deliveryAttemptRepository).save(attemptCaptor.capture());
        assertThat(attemptCaptor.getValue().getOutcome()).isEqualTo(DeliveryAttempt.AttemptOutcome.ERROR);
        assertThat(attemptCaptor.getValue().getChannel()).isEqualTo(Memory.DeliveryChannel.SMS);
        verify(memoryRepository).save(memory);
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
