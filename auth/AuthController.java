package com.inventory.backend.auth;

import com.inventory.backend.auth.dto.ChangePasswordRequest;
import com.inventory.backend.auth.dto.LoginRequest;
import com.inventory.backend.auth.dto.LoginResponse;
import com.inventory.backend.auth.dto.RefreshTokenRequest;
import com.inventory.backend.auth.dto.RegisterRequest;
import com.inventory.backend.auth.dto.UserResponse;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

	private final AuthService authService;

	public AuthController(AuthService authService) {
		this.authService = authService;
	}

	@PostMapping("/register")
	public LoginResponse register(@Valid @RequestBody RegisterRequest request) {
		return authService.register(request);
	}

	@PostMapping("/login")
	public LoginResponse login(@Valid @RequestBody LoginRequest request) {
		return authService.login(request);
	}

	@PostMapping("/refresh")
	public LoginResponse refresh(@Valid @RequestBody RefreshTokenRequest request) {
		return authService.refresh(request);
	}

	@PostMapping("/logout")
	public void logout(@AuthenticationPrincipal User user) {
		authService.logout(user.getId());
	}

	@GetMapping("/me")
	public UserResponse me(@AuthenticationPrincipal User user) {
		return authService.getCurrentUser(user.getId());
	}

	@PostMapping("/change-password")
	public void changePassword(@AuthenticationPrincipal User user, @Valid @RequestBody ChangePasswordRequest request) {
		authService.changePassword(user.getId(), request);
	}
}
