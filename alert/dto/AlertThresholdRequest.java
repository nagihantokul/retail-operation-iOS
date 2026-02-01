package com.inventory.backend.alert.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record AlertThresholdRequest(
    @NotNull Long storeId,
    @NotNull Long productId,
    @NotNull @Min(0) Integer lowStockThreshold,
    Integer reorderPoint,
    Integer maxStock,
    Boolean enabled
) {}
