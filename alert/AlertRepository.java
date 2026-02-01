package com.inventory.backend.alert;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface AlertRepository extends JpaRepository<Alert, Long> {
    List<Alert> findByStatus(AlertStatus status);
    List<Alert> findByStoreIdAndStatus(Long storeId, AlertStatus status);
    List<Alert> findByStoreId(Long storeId);
    Optional<Alert> findByStoreIdAndProductIdAndAlertTypeAndStatus(
            Long storeId, Long productId, AlertType alertType, AlertStatus status);
    long countByStatus(AlertStatus status);
    long countByStoreIdAndStatus(Long storeId, AlertStatus status);
}
