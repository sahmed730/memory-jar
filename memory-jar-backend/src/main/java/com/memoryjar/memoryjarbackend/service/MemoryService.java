package com.memoryjar.memoryjarbackend.service;

import com.memoryjar.memoryjarbackend.delivery.DeliveryResult;
import com.memoryjar.memoryjarbackend.delivery.DeliveryService;
import com.memoryjar.memoryjarbackend.model.DeliveryAttempt;
import com.memoryjar.memoryjarbackend.model.Memory;
import com.memoryjar.memoryjarbackend.repository.DeliveryAttemptRepository;
import com.memoryjar.memoryjarbackend.repository.MemoryRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemoryService {

    private final MemoryRepository memoryRepository;
    private final DeliveryAttemptRepository deliveryAttemptRepository;
    private final DeliveryService deliveryService;

    @Transactional
    public Memory createMemory(Memory memory) {
        memory.setId(null);
        memory.setStatus(Memory.MemoryStatus.PENDING);
        memory.setDeliveredAt(null);
        memory.setLastError(null);
        if (memory.getType() == null) {
            memory.setType(Memory.MemoryType.TEXT);
        }
        if (memory.getDeliveryChannels() != null) {
            memory.setDeliveryChannels(new LinkedHashSet<>(memory.getDeliveryChannels()));
        }
        return memoryRepository.save(memory);
    }

    @Transactional(readOnly = true)
    public List<Memory> getAllMemories() {
        return memoryRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Memory> getMemoryById(Long id) {
        return memoryRepository.findById(id);
    }

    @Transactional
    public void deleteMemory(Long id) {
        if (!memoryRepository.existsById(id)) {
            throw new MemoryNotFoundException(id);
        }
        memoryRepository.deleteById(id);
    }

    public int deliverDueMemories() {
        List<Memory> dueMemories = memoryRepository.findByStatusAndDeliveryDateLessThanEqual(
                Memory.MemoryStatus.PENDING,
                LocalDateTime.now()
        );
        dueMemories.forEach(this::deliverMemory);
        return dueMemories.size();
    }

    @Transactional
    public void deliverMemory(Memory memory) {
        Memory managedMemory = memoryRepository.findById(memory.getId()).orElseThrow(
                () -> new MemoryNotFoundException(memory.getId())
        );
        if (managedMemory.getStatus() != Memory.MemoryStatus.PENDING) {
            return;
        }

        boolean delivered = true;
        StringBuilder errors = new StringBuilder();

        for (Memory.DeliveryChannel channel : managedMemory.getDeliveryChannels()) {
            try {
                DeliveryResult result = deliveryService.deliver(managedMemory, channel);
                deliveryAttemptRepository.save(DeliveryAttempt.builder()
                        .memory(managedMemory)
                        .channel(channel)
                        .outcome(DeliveryAttempt.AttemptOutcome.OK)
                        .externalReference(result.externalReference())
                        .build());
            } catch (RuntimeException exception) {
                delivered = false;
                String message = exception.getMessage() == null
                        ? exception.getClass().getSimpleName()
                        : exception.getMessage();
                appendError(errors, channel, message);
                deliveryAttemptRepository.save(DeliveryAttempt.builder()
                        .memory(managedMemory)
                        .channel(channel)
                        .outcome(DeliveryAttempt.AttemptOutcome.ERROR)
                        .errorMessage(message)
                        .build());
                log.warn("Delivery failed for memory {} through {}: {}", managedMemory.getId(), channel, message);
            }
        }

        managedMemory.setStatus(delivered ? Memory.MemoryStatus.DELIVERED : Memory.MemoryStatus.FAILED);
        managedMemory.setDeliveredAt(delivered ? LocalDateTime.now() : null);
        managedMemory.setLastError(delivered ? null : errors.toString());
        memoryRepository.save(managedMemory);
    }

    private static void appendError(StringBuilder errors, Memory.DeliveryChannel channel, String message) {
        if (!errors.isEmpty()) {
            errors.append("; ");
        }
        errors.append(channel.name()).append(": ").append(message);
    }
}
