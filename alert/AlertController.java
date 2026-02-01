package com.inventory.backend.alert;

import com.inventory.backend.alert.dto.*;
import com.inventory.backend.auth.User;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/alerts")
public class AlertController {

    private final AlertService alertService;

    public AlertController(AlertService alertService) {
        this.alertService = alertService;
    }

    @GetMapping
    public List<AlertResponse> list(
            @RequestParam(name = "storeId", required = false) Long storeId,
            @RequestParam(name = "status", required = false) AlertStatus status) {
        return alertService.getAlerts(storeId, status);
    }

    @GetMapping("/{id}")
    public AlertResponse get(@PathVariable Long id) {
        return alertService.getAlert(id);
    }

    @PostMapping("/{id}/acknowledge")
    public AlertResponse acknowledge(@PathVariable Long id, @AuthenticationPrincipal User user) {
        return alertService.acknowledge(id, user);
    }

    @PostMapping("/thresholds")
    @ResponseStatus(HttpStatus.CREATED)
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public AlertThresholdResponse setThreshold(@Valid @RequestBody AlertThresholdRequest request) {
        return alertService.setThreshold(request);
    }

    @GetMapping("/thresholds")
    public List<AlertThresholdResponse> getThresholds(
            @RequestParam(name = "storeId", required = false) Long storeId) {
        return alertService.getThresholds(storeId);
    }

    @DeleteMapping("/thresholds/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public void deleteThreshold(@PathVariable Long id) {
        alertService.deleteThreshold(id);
    }

    @PostMapping("/check")
    @PreAuthorize("hasRole('ADMIN')")
    public int triggerCheck() {
        return alertService.checkAndCreateAlerts();
    }
}
