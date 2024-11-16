package com.example.notes.notes_spring.Repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.notes.notes_spring.Documents.NoteEntity;

@Repository
public interface NoteRepositry extends JpaRepository<NoteEntity, Integer> {
    List<NoteEntity> findAllByUserId(Integer id);
}