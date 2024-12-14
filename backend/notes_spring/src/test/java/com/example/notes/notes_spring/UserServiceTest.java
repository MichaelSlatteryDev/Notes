package com.example.notes.notes_spring;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.ArrayList;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.NoteData;
import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Repositories.UserRepositiory;
import com.example.notes.notes_spring.Services.JWTService;
import com.example.notes.notes_spring.Services.UserService;

class UserServiceTest {

    @Mock
    private JWTService jwtService;

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private UserRepositiory userRepositiory;

    @Mock
    private PasswordEncoder passwordEncoder;

    @InjectMocks
    private UserService userService;

    private UserEntity mockUser;
    private UserData mockUserData;
    private Authentication mockAuthentication;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        mockUser = new UserEntity(1, "username", "password", "USER", LocalDateTime.now(), LocalDateTime.now(), new ArrayList<NoteEntity>());
        mockUserData = new UserData("1", "username", "password", new ArrayList<NoteData>());
        mockAuthentication = mock(Authentication.class);
    }

    @Test
    void testCreateUser_DoesSucceed() {
        when(userRepositiory.getReferenceById(1)).thenReturn(mockUser);
        when(userRepositiory.save(any(UserEntity.class))).thenReturn(mockUser);

        try {
            UserData result = userService.createUser(mockUserData);
            assertNotNull(result);
            assertEquals("username", result.getUsername());
            assertEquals(0, result.getNotes().size());
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }
    }

    @Test
    void testCreateUser_DoesThrow() {
        when(userRepositiory.getReferenceById(1)).thenReturn(null);
        when(userRepositiory.save(any(UserEntity.class))).thenReturn(null);

        // Call and assert the exception
        assertThrows(Exception.class, () -> {
            userService.createUser(mockUserData);
        });
    }

    @Test
    void testVerify_DoesSucceed() {
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class))).thenReturn(mockAuthentication);
        when(mockAuthentication.isAuthenticated()).thenReturn(true);
        when(jwtService.generateToken(mockUser.getUsername())).thenReturn("abc123");

        // Call the verify method
        String token = userService.verify(mockUserData);

        // Assertions
        assertNotNull(token);
        assertEquals("abc123", token);

        // Verify interactions
        verify(authenticationManager, times(1)).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(jwtService, times(1)).generateToken(mockUser.getUsername());
    }

    @Test
    void testVerify_FailedAuthentication() {
        // Mock failed authentication (throws an exception)
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
            .thenThrow(new UsernameNotFoundException("User not found"));

        // Call and assert the exception
        assertThrows(UsernameNotFoundException.class, () -> {
            userService.verify(mockUserData);
        });

        // Verify the interactions
        verify(authenticationManager, times(1)).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(jwtService, never()).generateToken(anyString()); // Token generation shouldn't be called
    }
}
