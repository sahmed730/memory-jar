package com.memoryjar.memoryjarbackend.model;

import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.Set;

@Entity
@Table(
        name = "memories",
        indexes = @Index(
                name = "idx_memories_status_delivery_date",
                columnList = "status, delivery_date"
        )
)
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Memory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    @Column(nullable = false)
    private String title;

    @NotBlank
    @jakarta.persistence.Convert(converter = com.memoryjar.memoryjarbackend.util.StringEncryptorConverter.class)
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private MemoryType type;

    @Column(name = "media_url")
    private String mediaUrl;

    @NotNull
    @FutureOrPresent
    @Column(name = "delivery_date", nullable = false)
    private LocalDateTime deliveryDate;

    @ElementCollection(targetClass = DeliveryChannel.class)
    @CollectionTable(name = "memory_delivery_channels", joinColumns = @JoinColumn(name = "memory_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "channel", nullable = false)
    @NotEmpty
    @Builder.Default
    private Set<DeliveryChannel> deliveryChannels = new LinkedHashSet<>();

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private MemoryStatus status = MemoryStatus.PENDING;

    @NotBlank
    @Column(name = "recipient_identifier", nullable = false)
    private String recipientIdentifier;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "delivered_at")
    private LocalDateTime deliveredAt;

    @Column(name = "last_error", columnDefinition = "TEXT")
    private String lastError;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (status == null) {
            status = MemoryStatus.PENDING;
        }
    }

    public enum MemoryType {
        TEXT, AUDIO, IMAGE, VIDEO, DOCUMENT
    }

    public enum DeliveryChannel {
        WHATSAPP, PHONE_CALL, SMS, EMAIL, PUSH_NOTIFICATION
    }

    public enum MemoryStatus {
        PENDING, DELIVERED, FAILED
    }
}
