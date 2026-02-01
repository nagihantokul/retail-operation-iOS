package com.inventory.backend.alert;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AlertThresholdRepository extends JpaRepository<AlertThreshold, Long> {
    Optional<AlertThreshold> findByStoreIdAndProductId(Long storeId, Long productId);
    List<AlertThreshold> findByStoreId(Long storeId);
    List<AlertThreshold> findByEnabledTrue();
    boolean existsByStoreIdAndProductId(Long storeId, Long productId);
}
