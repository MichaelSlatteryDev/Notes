package com.example.notes.notes_spring.Repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.notes.notes_spring.Documents.NoteEntity;

public interface NoteRepositry extends JpaRepository<NoteEntity, Integer> {}