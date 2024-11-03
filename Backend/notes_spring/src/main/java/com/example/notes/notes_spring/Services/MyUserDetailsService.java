package com.example.notes.notes_spring.Services;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Repositories.UserRepositiory;

@Service
public class MyUserDetailsService implements UserDetailsService {
    @Autowired
    private UserRepositiory repositiory;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Optional<UserEntity> user = repositiory.findByUsername(username);
        if (user.isPresent()) {
            var userObj = user.get();
            return User.builder()
                    .username(userObj.getUsername())
                    .password(userObj.getPassword())
                    .roles(getRoles(userObj))
                    .build();
        } else {
            throw new UsernameNotFoundException(username);
        }
    }
    
    private String[] getRoles(UserEntity user) {
        if (user.getRole() == null) {
            return new String[]{"USER"};
        }
        return user.getRole().split(",");
    }

    public UserData loadUserInfo(String username) throws UsernameNotFoundException {
        Optional<UserEntity> user = repositiory.findByUsername(username);
        if (user.isPresent()) {
            return new UserData(user.get());
        } else {
            throw new UsernameNotFoundException(username);
        }
    }
}