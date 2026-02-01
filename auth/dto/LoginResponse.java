package com.inventory.backend.auth.dto;

public record LoginResponse(String accessToken, String refreshToken, long expiresInSeconds, UserResponse user) {}
