package com.example.notes.notes_spring.Services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.NoteData;
import com.example.notes.notes_spring.Repositories.NoteRepositry;
import com.example.notes.notes_spring.Repositories.UserRepositiory;

@Service
public class NoteService {
    @Autowired
    private NoteRepositry noteRepositry;

    @Autowired
    private UserRepositiory userRepositiory;

    public List<NoteEntity> getAllNotes() {
        return noteRepositry.findAll();
    }

    public List<NoteEntity> getAllNotesForUser(String id) {
        return noteRepositry.findAllByUserId(Integer.parseInt(id));
    }

    public NoteEntity getNoteById(Integer id) {
        return noteRepositry.findById(id).orElse(null);
    }

    public NoteData createNote(NoteData note) {
        UserEntity user = userRepositiory.getReferenceById(note.getUserId());

        NoteEntity newNote = new NoteEntity(
            null,
            note.getTitle(),
            note.getDescription(),
            LocalDateTime.now(),
            LocalDateTime.now(),
            user
        );

        return new NoteData(noteRepositry.save(newNote));
    }

    public NoteData updateNote(Integer id, NoteData updatedNote) {
        if (noteRepositry.existsById(id)) {
            NoteEntity referenceNote = noteRepositry.getReferenceById(id);
            referenceNote.setTitle(updatedNote.getTitle());
            referenceNote.setDescription(updatedNote.getDescription());
            referenceNote.setLastUpdatedAt(LocalDateTime.now());
            return new NoteData(noteRepositry.save(referenceNote));
        }
        return null;
    }

    public void deleteNote(Integer id) {
        noteRepositry.deleteById(id);
    }
}
