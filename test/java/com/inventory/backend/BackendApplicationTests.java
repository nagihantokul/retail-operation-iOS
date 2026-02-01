package com.inventory.backend;

import com.inventory.backend.availability.AvailabilityService;
import com.inventory.backend.inventory.InventoryService;
import com.inventory.backend.inventory.dto.AdjustInventoryRequest;
import com.inventory.backend.product.ProductService;
import com.inventory.backend.product.dto.CreateProductRequest;
import com.inventory.backend.store.StoreService;
import com.inventory.backend.store.dto.CreateStoreRequest;
import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
class BackendApplicationTests {

	@Autowired
	ProductService productService;

	@Autowired
	InventoryService inventoryService;

	@Autowired
	StoreService storeService;

	@Autowired
	AvailabilityService availabilityService;

	@Test
	void createProductAndAdjustInventory() {
		var store = storeService.create(new CreateStoreRequest(
				"STORE-1", "Main Store", null, "New York", "NY", "10001", "US", null, null));
		var product =
				productService.create(new CreateProductRequest("SKU-1", "Test Product", "1234567890", "Test", null));

		var status = inventoryService.adjust(new AdjustInventoryRequest(store.id(), product.id(), 5, "Initial stock"));
		org.assertj.core.api.Assertions.assertThat(status.quantity()).isEqualTo(5);
	}

	@Test
	void availabilityByBarcodeReturnsCurrentAndNearbyStores() {
		var currentStore = storeService.create(new CreateStoreRequest(
				"STORE-A",
				"Store A",
				null,
				"New York",
				"NY",
				"10001",
				"US",
				new BigDecimal("41.008200"),
				new BigDecimal("28.978400")));
		var nearbyStore = storeService.create(new CreateStoreRequest(
				"STORE-B",
				"Store B",
				null,
				"Newark",
				"NJ",
				"07102",
				"US",
				new BigDecimal("41.015000"),
				new BigDecimal("28.980000")));

		var product = productService.create(new CreateProductRequest("SKU-2", "Test Product 2", "BRC-1", null, null));

		inventoryService.adjust(new AdjustInventoryRequest(currentStore.id(), product.id(), 3, "Init"));
		inventoryService.adjust(new AdjustInventoryRequest(nearbyStore.id(), product.id(), 7, "Init"));

		var availability = availabilityService.byBarcode("BRC-1", currentStore.id(), 41.0082, 28.9784, null, 5.0, 10);

		org.assertj.core.api.Assertions.assertThat(availability.product().barcode()).isEqualTo("BRC-1");
		org.assertj.core.api.Assertions.assertThat(availability.stores()).hasSize(2);
		org.assertj.core.api.Assertions.assertThat(availability.stores().getFirst().storeId()).isEqualTo(currentStore.id());
		org.assertj.core.api.Assertions.assertThat(availability.stores().getFirst().quantity()).isEqualTo(3);
		org.assertj.core.api.Assertions.assertThat(availability.stores().get(1).quantity()).isEqualTo(7);
	}
}
