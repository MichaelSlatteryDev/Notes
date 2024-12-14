package com.example.notes.notes_spring.Models;

import com.example.notes.notes_spring.Documents.NoteEntity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NoteData {

    private String id;
    
    private String title;

    private String description;

    private Integer userId;

    public NoteData(NoteEntity entity) {
        this.id = entity.getId().toString();
        this.title = entity.getTitle();
        this.description = entity.getDescription();
        this.userId = entity.getUser().getId();
    }
}
