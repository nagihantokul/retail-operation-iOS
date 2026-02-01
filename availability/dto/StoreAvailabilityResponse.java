package com.inventory.backend.availability.dto;

public record StoreAvailabilityResponse(
		long storeId,
		String code,
		String name,
		String city,
		String state,
		Double distanceKm,
		Double distanceMi,
		long quantity,
		boolean current) {}
