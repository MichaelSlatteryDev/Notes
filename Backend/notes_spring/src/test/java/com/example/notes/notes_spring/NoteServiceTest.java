package com.example.notes.notes_spring;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Optional;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.NoteData;
import com.example.notes.notes_spring.Repositories.NoteRepositry;
import com.example.notes.notes_spring.Repositories.UserRepositiory;
import com.example.notes.notes_spring.Services.NoteService;

public class NoteServiceTest {

    @Mock
    private NoteRepositry noteRepositry;

    @Mock
    private UserRepositiory userRepositiory;

    @InjectMocks
    private NoteService noteService;

    private UserEntity mockUser;
    private NoteEntity mockNote;
    private NoteData mockNoteData;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        mockUser = new UserEntity(1, "username", "password", "USER", LocalDateTime.now(), LocalDateTime.now(), new ArrayList<NoteEntity>());
        mockNote = new NoteEntity(1, "Test Title", "Test Description", LocalDateTime.now(), LocalDateTime.now(), mockUser);
        mockNoteData = new NoteData("1", "Test Title", "Test Description", 1);
    }

    @Test
    void testGetAllNotes() {
        List<NoteEntity> noteList = Arrays.asList(mockNote);
        when(noteRepositry.findAll()).thenReturn(noteList);

        List<NoteEntity> result = noteService.getAllNotes();
        assertEquals(1, result.size());
        assertEquals("Test Title", result.get(0).getTitle());
    }

    @Test
    void testGetNoteById_NoteExists() {
        when(noteRepositry.findById(1)).thenReturn(Optional.of(mockNote));

        NoteEntity result = noteService.getNoteById(1);
        assertNotNull(result);
        assertEquals("Test Title", result.getTitle());
    }

    @Test
    void testGetNoteById_NoteDoesNotExist() {
        when(noteRepositry.findById(1)).thenReturn(Optional.empty());

        NoteEntity result = noteService.getNoteById(1);
        assertNull(result);
    }

    @Test
    void testCreateNote() {
        when(userRepositiory.getReferenceById(1)).thenReturn(mockUser);
        when(noteRepositry.save(any(NoteEntity.class))).thenReturn(mockNote);

        NoteData result = noteService.createNote(mockNoteData);
        assertNotNull(result);
        assertEquals("Test Title", result.getTitle());
        assertEquals(mockUser.getId(), result.getUserId());
    }

    @Test
    void testUpdateNote_NoteExists() {
        when(noteRepositry.existsById(1)).thenReturn(true);
        when(noteRepositry.getReferenceById(1)).thenReturn(mockNote);
        when(noteRepositry.save(any(NoteEntity.class))).thenReturn(mockNote);

        NoteData updatedNote = new NoteData("1", "Updated Title", "Updated Description", 1);
        NoteData result = noteService.updateNote(1, updatedNote);

        assertNotNull(result);
        assertEquals("Updated Title", result.getTitle());
    }

    @Test
    void testUpdateNote_NoteDoesNotExist() {
        when(noteRepositry.existsById(1)).thenReturn(false);

        NoteData updatedNote = new NoteData("1", "Updated Title", "Updated Description", 1);
        NoteData result = noteService.updateNote(1, updatedNote);

        assertNull(result);
    }

    @Test
    void testDeleteNote() {
        doNothing().when(noteRepositry).deleteById(1);

        noteService.deleteNote(1);

        verify(noteRepositry, times(1)).deleteById(1);
    }
}
