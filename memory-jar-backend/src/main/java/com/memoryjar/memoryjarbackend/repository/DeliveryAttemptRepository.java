package com.memoryjar.memoryjarbackend.repository;

import com.memoryjar.memoryjarbackend.model.DeliveryAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeliveryAttemptRepository extends JpaRepository<DeliveryAttempt, Long> {
}
