package com.inventory.backend.alert.dto;

import com.inventory.backend.alert.AlertThreshold;

public record AlertThresholdResponse(
    Long id,
    Long storeId,
    Long productId,
    int lowStockThreshold,
    Integer reorderPoint,
    Integer maxStock,
    boolean enabled
) {
    public static AlertThresholdResponse from(AlertThreshold threshold) {
        return new AlertThresholdResponse(
            threshold.getId(),
            threshold.getStoreId(),
            threshold.getProductId(),
            threshold.getLowStockThreshold(),
            threshold.getReorderPoint(),
            threshold.getMaxStock(),
            threshold.isEnabled()
        );
    }
}
