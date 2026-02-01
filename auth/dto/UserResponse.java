package com.inventory.backend.auth.dto;

import com.inventory.backend.auth.User;
import com.inventory.backend.auth.UserRole;
import java.time.Instant;

public record UserResponse(
    Long id,
    String email,
    String firstName,
    String lastName,
    UserRole role,
    Long storeId,
    String storeName,
    boolean active,
    Instant createdAt
) {
    public static UserResponse from(User user) {
        return new UserResponse(
            user.getId(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName(),
            user.getRole(),
            user.getStore() != null ? user.getStore().getId() : null,
            user.getStore() != null ? user.getStore().getName() : null,
            user.isActive(),
            user.getCreatedAt()
        );
    }
}
