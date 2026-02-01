package com.inventory.backend.alert.dto;

import com.inventory.backend.alert.Alert;
import com.inventory.backend.alert.AlertStatus;
import com.inventory.backend.alert.AlertType;
import java.time.Instant;

public record AlertResponse(
    Long id,
    Long storeId,
    String storeName,
    Long productId,
    String productName,
    AlertType alertType,
    int currentQuantity,
    int thresholdValue,
    AlertStatus status,
    Instant acknowledgedAt,
    Instant resolvedAt,
    Instant createdAt
) {
    public static AlertResponse from(Alert alert, String storeName, String productName) {
        return new AlertResponse(
            alert.getId(),
            alert.getStoreId(),
            storeName,
            alert.getProductId(),
            productName,
            alert.getAlertType(),
            alert.getCurrentQuantity(),
            alert.getThresholdValue(),
            alert.getStatus(),
            alert.getAcknowledgedAt(),
            alert.getResolvedAt(),
            alert.getCreatedAt()
        );
    }
}
