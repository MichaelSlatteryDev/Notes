package com.example.notes.notes_spring.Repositories;

// import java.math.BigInteger;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.notes.notes_spring.Documents.UserEntity;


public interface UserRepositiory extends JpaRepository<UserEntity, Integer> {
    Optional<UserEntity> findByUsername(String username);
}