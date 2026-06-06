package com.memoryjar.memoryjarbackend.repository;

import com.memoryjar.memoryjarbackend.model.Memory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface MemoryRepository extends JpaRepository<Memory, Long> {
    List<Memory> findByStatusAndDeliveryDateLessThanEqual(Memory.MemoryStatus status, LocalDateTime deliveryDate);
}
