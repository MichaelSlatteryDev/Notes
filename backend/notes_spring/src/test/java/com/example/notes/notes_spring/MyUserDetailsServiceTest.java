package com.example.notes.notes_spring;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.core.userdetails.UserDetails;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Repositories.UserRepositiory;
import com.example.notes.notes_spring.Services.MyUserDetailsService;

class MyUserDetailsServiceTest {

    @Mock
    private UserRepositiory userRepositiory;

    @InjectMocks
    private MyUserDetailsService userDetailsService;

    private Optional<UserEntity> mockUser;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        mockUser = Optional.of(new UserEntity(1, "username", "password", "USER", LocalDateTime.now(), LocalDateTime.now(), new ArrayList<NoteEntity>()));
    }

    @Test
    void testLoadByUsername_DoesSucceed() {
        when(userRepositiory.findByUsername("username")).thenReturn(mockUser);

        try {
            UserDetails userDetails = userDetailsService.loadUserByUsername("username");
            assertNotNull(userDetails);
            assertEquals("username", userDetails.getUsername());
            assertEquals("password", userDetails.getPassword());
            assertEquals(1, userDetails.getAuthorities().size());
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }
    }

    @Test
    void testLoadByUsername_DoesThrow() {
        when(userRepositiory.findByUsername("username")).thenReturn(null);

        // Call and assert the exception
        assertThrows(Exception.class, () -> {
            userDetailsService.loadUserByUsername("username");
        });
    }

    @Test
    void testLoadUserInfo_DoesSucceed() {
        when(userRepositiory.findByUsername("username")).thenReturn(mockUser);

        try {
            UserData userData = userDetailsService.loadUserInfo("username");
            assertNotNull(userData);
            assertEquals("1", userData.getId());
            assertEquals("username", userData.getUsername());
            assertEquals("password", userData.getPassword());
            assertEquals(0, userData.getNotes().size());
        } catch (Exception e) {
            fail(e.getLocalizedMessage());
        }
    }

    @Test
    void testLoadUserInfo_DoesThrow() {
        when(userRepositiory.findByUsername("username")).thenReturn(null);

        // Call and assert the exception
        assertThrows(Exception.class, () -> {
            userDetailsService.loadUserInfo("username");
        });
    }
}
