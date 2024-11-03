package com.example.notes.notes_spring;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.example.notes.notes_spring.Controllers.NoteController;
import com.example.notes.notes_spring.Documents.NoteEntity;
import com.example.notes.notes_spring.Documents.UserEntity;
import com.example.notes.notes_spring.Models.NoteData;
import com.example.notes.notes_spring.Services.NoteService;
import com.fasterxml.jackson.databind.ObjectMapper;

class NoteControllerTest {

    private MockMvc mockMvc;

    @Mock
    private NoteService noteService;

    @InjectMocks
    private NoteController noteController;

    private NoteEntity mockNoteEntity;
    private NoteData mockNoteData;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(noteController).build();

        // Mocking note data
        mockNoteEntity = new NoteEntity(1, "Test Title", "Test Description", LocalDateTime.now(), LocalDateTime.now(), new UserEntity());
        mockNoteData = new NoteData("1", "Test Title", "Test Description", 1);
    }

    @Test
    void testGetAllNotes() throws Exception {
        List<NoteEntity> notes = Arrays.asList(mockNoteEntity);
        when(noteService.getAllNotes()).thenReturn(notes);

        mockMvc.perform(get("/notes"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].title").value("Test Title"))
            .andExpect(jsonPath("$[0].description").value("Test Description"))
            .andDo(print());

        verify(noteService, times(1)).getAllNotes();
    }

    @Test
    void testGetNoteById() throws Exception {
        when(noteService.getNoteById(1)).thenReturn(mockNoteEntity);

        mockMvc.perform(get("/notes/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Test Title"))
            .andExpect(jsonPath("$.description").value("Test Description"))
            .andDo(print());

        verify(noteService, times(1)).getNoteById(1);
    }

    @Test
    void testCreateNote() throws Exception {
        when(noteService.createNote(any(NoteData.class))).thenReturn(mockNoteData);

        mockMvc.perform(post("/notes")
            .contentType(MediaType.APPLICATION_JSON)
            .content(asJsonString(mockNoteData)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Test Title"))
            .andExpect(jsonPath("$.description").value("Test Description"))
            .andDo(print());

        verify(noteService, times(1)).createNote(any(NoteData.class));
    }

    @Test
    void testUpdateNote() throws Exception {
        when(noteService.updateNote(eq(1), any(NoteData.class))).thenReturn(mockNoteData);

        mockMvc.perform(put("/notes/1")
            .contentType(MediaType.APPLICATION_JSON)
            .content(asJsonString(mockNoteData)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.title").value("Test Title"))
            .andExpect(jsonPath("$.description").value("Test Description"))
            .andDo(print());

        verify(noteService, times(1)).updateNote(eq(1), any(NoteData.class));
    }

    @Test
    void testDeleteNote() throws Exception {
        doNothing().when(noteService).deleteNote(1);

        mockMvc.perform(delete("/notes/1"))
            .andExpect(status().isOk())
            .andDo(print());

        verify(noteService, times(1)).deleteNote(1);
    }

    // Helper method to convert object to JSON string
    private static String asJsonString(final Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
