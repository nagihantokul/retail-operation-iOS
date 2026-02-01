package com.inventory.backend.availability;

import com.inventory.backend.availability.dto.ProductAvailabilityResponse;
import com.inventory.backend.availability.dto.StoreAvailabilityResponse;
import com.inventory.backend.common.NotFoundException;
import com.inventory.backend.inventory.InventoryLevelRepository;
import com.inventory.backend.product.Product;
import com.inventory.backend.product.ProductRepository;
import com.inventory.backend.product.dto.ProductResponse;
import com.inventory.backend.store.StoreService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AvailabilityService {

	private final ProductRepository productRepository;
	private final StoreService storeService;
	private final InventoryLevelRepository inventoryLevelRepository;

	public AvailabilityService(
			ProductRepository productRepository,
			StoreService storeService,
			InventoryLevelRepository inventoryLevelRepository) {
		this.productRepository = productRepository;
		this.storeService = storeService;
		this.inventoryLevelRepository = inventoryLevelRepository;
	}

	@Transactional(readOnly = true)
	public ProductAvailabilityResponse byBarcode(
			String barcode,
			long storeId,
			Double lat,
			Double lng,
			Double radiusKm,
			Double radiusMi,
			Integer limit) {
		var currentStore = storeService.get(storeId);

		Product product =
				productRepository.findByBarcode(barcode).orElseThrow(() -> new NotFoundException("Product not found"));

		var stores = new ArrayList<com.inventory.backend.store.dto.StoreResponse>();
		stores.add(currentStore);

		if (lat != null && lng != null) {
			for (var s : storeService.list(lat, lng, radiusKm, radiusMi, null, null, limit)) {
				if (s.id() != storeId) {
					stores.add(s);
				}
			}
		}

		List<Long> storeIds = stores.stream().map(com.inventory.backend.store.dto.StoreResponse::id).toList();
		var levels = inventoryLevelRepository.findByIdProductIdAndIdStoreIdIn(product.getId(), storeIds);

		Map<Long, Long> quantities = new HashMap<>();
		for (var level : levels) {
			quantities.put(level.getStoreId(), level.getQuantity());
		}

		List<StoreAvailabilityResponse> storeAvailabilities = stores.stream()
				.map(s -> new StoreAvailabilityResponse(
						s.id(),
						s.code(),
						s.name(),
						s.city(),
						s.state(),
						s.distanceKm(),
						s.distanceMi(),
						quantities.getOrDefault(s.id(), 0L),
						s.id() == storeId))
				.toList();

		return new ProductAvailabilityResponse(toProductResponse(product), storeAvailabilities);
	}

	private static ProductResponse toProductResponse(Product product) {
		return new ProductResponse(
				product.getId(),
				product.getSku(),
				product.getName(),
				product.getBarcode(),
				product.getCategory(),
				product.getPrice(),
				product.getCreatedAt(),
				product.getUpdatedAt());
	}
}
