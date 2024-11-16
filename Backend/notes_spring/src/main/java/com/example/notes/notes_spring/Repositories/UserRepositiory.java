package com.example.notes.notes_spring.Repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.notes.notes_spring.Documents.UserEntity;

@Repository
public interface UserRepositiory extends JpaRepository<UserEntity, Integer> {
    Optional<UserEntity> findByUsername(String username);
}