package com.example.notes.notes_spring.Configurations;

import org.springframework.security.core.GrantedAuthority;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class MockAuthority implements GrantedAuthority {

    private String authority;

    @Override
    public String getAuthority() {
        return authority;
    }
}
