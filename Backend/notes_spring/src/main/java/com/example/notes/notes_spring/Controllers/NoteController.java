package com.example.notes.notes_spring.Controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Models.NoteData;
import com.example.notes.notes_spring.Services.NoteService;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Validated
@RestController
@RequestMapping("/notes")
public class NoteController {
    @Autowired
    private NoteService noteService;

    @GetMapping
    public List<NoteData> getAllNotes() {
        List<NoteEntity> notes = noteService.getAllNotes();
        return notes.stream().map( noteEntity -> 
            new NoteData(noteEntity)
        )
        .collect(Collectors.toList());
    }

    @GetMapping("/{id}")
    public NoteData getNoteById(@PathVariable Integer id) {
        NoteEntity noteEntity = noteService.getNoteById(id);
        return new NoteData(noteEntity);
    }
    
    @PostMapping
    public NoteData createNote(@Valid @RequestBody NoteData note) {
        return noteService.createNote(note);
    }

    @PutMapping("/{id}")
    public NoteData updateNote(@PathVariable Integer id, @RequestBody NoteData updatedNote) {
        return noteService.updateNote(id, updatedNote);
    }

    @DeleteMapping("/{id}")
    public void deleteNote(@PathVariable Integer id) {
        noteService.deleteNote(id);
    }
}
