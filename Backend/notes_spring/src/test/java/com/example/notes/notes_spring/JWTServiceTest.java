package com.example.notes.notes_spring;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.notes.notes_spring.Configurations.MockSecretKeyGenerator;
import com.example.notes.notes_spring.Services.JWTService;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

public class JWTServiceTest {

    private JWTService jwtService;
    private String testUsername = "testUser";
    private String secretKey = "778b387559a5ebf67da7328818ed41a7e6a956223cfaabd7b94ec9d4b9f99699";

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        this.jwtService = new JWTService(new MockSecretKeyGenerator(secretKey));
    }

    @Test
    void testGenerateToken() {
        String token = jwtService.generateToken(testUsername);
        assertNotNull(token, "Token should not be null");

        byte[] keybytes = Decoders.BASE64.decode(secretKey);

        Claims claims = Jwts.parser()
                .verifyWith(Keys.hmacShaKeyFor(keybytes))
                .build()
                .parseSignedClaims(token)
                .getPayload();

        assertEquals(testUsername, claims.getSubject(), "The username should match the subject in the claims");
    }

    @Test
    void testExtractUserName() {
        String token = jwtService.generateToken(testUsername);
        String extractedUsername = jwtService.extractUserName(token);

        assertEquals(testUsername, extractedUsername, "Extracted username should match the one used to create the token");
    }

    @Test
    void testValidateToken() {
        String token = jwtService.generateToken(testUsername);
        UserDetails userDetails = Mockito.mock(UserDetails.class);
        Mockito.when(userDetails.getUsername()).thenReturn(testUsername);

        boolean isValid = jwtService.validateToken(token, userDetails);

        assertTrue(isValid, "Token should be valid");
    }

    @Test
    void testValidateToken_InvalidUsername() {
        String token = jwtService.generateToken(testUsername);
        UserDetails userDetails = Mockito.mock(UserDetails.class);
        Mockito.when(userDetails.getUsername()).thenReturn("otherUser");

        boolean isValid = jwtService.validateToken(token, userDetails);

        assertFalse(isValid, "Token should be invalid due to username mismatch");
    }
}
