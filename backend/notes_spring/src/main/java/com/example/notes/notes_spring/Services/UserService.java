package com.example.notes.notes_spring.Services;

import java.time.LocalDateTime;
import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Repositories.UserRepositiory;

@Service
public class UserService {

    @Autowired
    private JWTService jwtService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepositiory repositiory;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserData createUser(UserData user) throws Exception {
        UserEntity newUser = new UserEntity(
            null,
            user.getUsername(),
            passwordEncoder.encode(user.getPassword()),
            "USER",
            LocalDateTime.now(),
            LocalDateTime.now(),
            new ArrayList<NoteEntity>());
        return new UserData(repositiory.save(newUser));
    }

    public String verify(UserData user) throws UsernameNotFoundException, AuthenticationException {
        Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword()));

        if (authentication.isAuthenticated()) {
            return jwtService.generateToken(user.getUsername());
        }

        throw new UsernameNotFoundException(user.getUsername());
    }
}
