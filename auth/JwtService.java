package com.inventory.backend.auth;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

	private static final SecureRandom SECURE_RANDOM = new SecureRandom();

	private final SecretKey signingKey;
	private final String issuer;
	private final long accessTokenExpirationMs;
	private final long refreshTokenTtlDays;

	public JwtService(
			@Value("${app.security.jwt.secret}") String secret,
			@Value("${app.security.jwt.issuer}") String issuer,
			@Value("${app.security.jwt.accessTtlMinutes}") long accessTtlMinutes,
			@Value("${app.security.jwt.refreshTtlDays}") long refreshTtlDays) {
		this.signingKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
		this.issuer = issuer;
		this.accessTokenExpirationMs = accessTtlMinutes * 60_000L;
		this.refreshTokenTtlDays = refreshTtlDays;
	}

	public String generateAccessToken(User user) {
		Instant now = Instant.now();
		Instant exp = now.plusMillis(accessTokenExpirationMs);

		Long storeId = user.getStore() == null ? null : user.getStore().getId();

		return Jwts.builder()
				.issuer(issuer)
				.subject(user.getEmail())
				.issuedAt(Date.from(now))
				.expiration(Date.from(exp))
				.claim("uid", user.getId())
				.claim("role", user.getRole().name())
				.claim("storeId", storeId)
				.signWith(signingKey)
				.compact();
	}

	public Claims parseAccessToken(String token) {
		return Jwts.parser().verifyWith(signingKey).requireIssuer(issuer).build().parseSignedClaims(token).getPayload();
	}

	public String generateRefreshToken(User user) {
		byte[] bytes = new byte[48];
		SECURE_RANDOM.nextBytes(bytes);
		return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}

	public Instant getRefreshTokenExpiration() {
		return Instant.now().plusSeconds(refreshTokenTtlDays * 24L * 60L * 60L);
	}

	public long getAccessTokenExpirationMs() {
		return accessTokenExpirationMs;
	}
}

