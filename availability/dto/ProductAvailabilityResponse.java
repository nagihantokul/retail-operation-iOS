package com.inventory.backend.availability.dto;

import com.inventory.backend.product.dto.ProductResponse;
import java.util.List;

public record ProductAvailabilityResponse(ProductResponse product, List<StoreAvailabilityResponse> stores) {}

