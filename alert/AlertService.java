package com.inventory.backend.alert;

import com.inventory.backend.alert.dto.*;
import com.inventory.backend.auth.User;
import com.inventory.backend.common.NotFoundException;
import com.inventory.backend.inventory.InventoryLevel;
import com.inventory.backend.inventory.InventoryLevelRepository;
import com.inventory.backend.product.ProductRepository;
import com.inventory.backend.store.StoreRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AlertService {

    private final AlertRepository alertRepository;
    private final AlertThresholdRepository thresholdRepository;
    private final InventoryLevelRepository inventoryLevelRepository;
    private final ProductRepository productRepository;
    private final StoreRepository storeRepository;

    public AlertService(
            AlertRepository alertRepository,
            AlertThresholdRepository thresholdRepository,
            InventoryLevelRepository inventoryLevelRepository,
            ProductRepository productRepository,
            StoreRepository storeRepository) {
        this.alertRepository = alertRepository;
        this.thresholdRepository = thresholdRepository;
        this.inventoryLevelRepository = inventoryLevelRepository;
        this.productRepository = productRepository;
        this.storeRepository = storeRepository;
    }

    @Transactional(readOnly = true)
    public List<AlertResponse> getAlerts(Long storeId, AlertStatus status) {
        List<Alert> alerts;
        if (storeId != null && status != null) {
            alerts = alertRepository.findByStoreIdAndStatus(storeId, status);
        } else if (storeId != null) {
            alerts = alertRepository.findByStoreId(storeId);
        } else if (status != null) {
            alerts = alertRepository.findByStatus(status);
        } else {
            alerts = alertRepository.findByStatus(AlertStatus.ACTIVE);
        }

        return alerts.stream()
            .map(this::toAlertResponse)
            .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public AlertResponse getAlert(Long id) {
        Alert alert = alertRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Alert not found"));
        return toAlertResponse(alert);
    }

    @Transactional
    public AlertResponse acknowledge(Long id, User user) {
        Alert alert = alertRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("Alert not found"));

        alert.setStatus(AlertStatus.ACKNOWLEDGED);
        alert.setAcknowledgedBy(user);
        alert.setAcknowledgedAt(Instant.now());

        alert = alertRepository.save(alert);
        return toAlertResponse(alert);
    }

    @Transactional
    public AlertThresholdResponse setThreshold(AlertThresholdRequest request) {
        AlertThreshold threshold = thresholdRepository
            .findByStoreIdAndProductId(request.storeId(), request.productId())
            .orElse(new AlertThreshold());

        threshold.setStoreId(request.storeId());
        threshold.setProductId(request.productId());
        threshold.setLowStockThreshold(request.lowStockThreshold());
        threshold.setReorderPoint(request.reorderPoint());
        threshold.setMaxStock(request.maxStock());
        threshold.setEnabled(request.enabled() != null ? request.enabled() : true);

        threshold = thresholdRepository.save(threshold);
        return AlertThresholdResponse.from(threshold);
    }

    @Transactional(readOnly = true)
    public List<AlertThresholdResponse> getThresholds(Long storeId) {
        List<AlertThreshold> thresholds;
        if (storeId != null) {
            thresholds = thresholdRepository.findByStoreId(storeId);
        } else {
            thresholds = thresholdRepository.findAll();
        }
        return thresholds.stream()
            .map(AlertThresholdResponse::from)
            .collect(Collectors.toList());
    }

    @Transactional
    public void deleteThreshold(Long id) {
        if (!thresholdRepository.existsById(id)) {
            throw new NotFoundException("Threshold not found");
        }
        thresholdRepository.deleteById(id);
    }

    @Transactional
    public int checkAndCreateAlerts() {
        int alertsCreated = 0;
        List<AlertThreshold> thresholds = thresholdRepository.findByEnabledTrue();

        for (AlertThreshold threshold : thresholds) {
            InventoryLevel level = inventoryLevelRepository
                .findById(new com.inventory.backend.inventory.InventoryLevelId(
                    threshold.getStoreId(), threshold.getProductId()))
                .orElse(null);

            long quantity = level != null ? level.getQuantity() : 0;

            // Check for out of stock
            if (quantity == 0) {
                if (createAlertIfNotExists(threshold, AlertType.OUT_OF_STOCK, (int) quantity, 0)) {
                    alertsCreated++;
                }
            }
            // Check for low stock
            else if (quantity <= threshold.getLowStockThreshold()) {
                if (createAlertIfNotExists(threshold, AlertType.LOW_STOCK, (int) quantity, threshold.getLowStockThreshold())) {
                    alertsCreated++;
                }
            }
            // Check for overstock
            else if (threshold.getMaxStock() != null && quantity > threshold.getMaxStock()) {
                if (createAlertIfNotExists(threshold, AlertType.OVERSTOCK, (int) quantity, threshold.getMaxStock())) {
                    alertsCreated++;
                }
            }
        }

        return alertsCreated;
    }

    private boolean createAlertIfNotExists(AlertThreshold threshold, AlertType type, int currentQty, int thresholdValue) {
        var existing = alertRepository.findByStoreIdAndProductIdAndAlertTypeAndStatus(
            threshold.getStoreId(), threshold.getProductId(), type, AlertStatus.ACTIVE);

        if (existing.isEmpty()) {
            Alert alert = new Alert(
                threshold.getStoreId(),
                threshold.getProductId(),
                type,
                currentQty,
                thresholdValue
            );
            alertRepository.save(alert);
            return true;
        }
        return false;
    }

    private AlertResponse toAlertResponse(Alert alert) {
        String storeName = storeRepository.findById(alert.getStoreId())
            .map(s -> s.getName())
            .orElse("Unknown Store");

        String productName = productRepository.findById(alert.getProductId())
            .map(p -> p.getName())
            .orElse("Unknown Product");

        return AlertResponse.from(alert, storeName, productName);
    }
}
