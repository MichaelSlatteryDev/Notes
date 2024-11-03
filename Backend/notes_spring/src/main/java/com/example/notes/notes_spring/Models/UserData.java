package com.example.notes.notes_spring.Models;

import java.util.List;
import java.util.stream.Collectors;

import com.example.notes.notes_spring.Documents.UserEntity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserData {

    private String id;

    private String username;

    private String password;

    private List<NoteData> notes;

    public UserData(UserEntity entity) {
        this.id = entity.getId().toString();
        this.username = entity.getUsername();
        this.password = entity.getPassword();
        this.notes = entity.getNotes().stream().map( noteEntity ->
            new NoteData(noteEntity)
        )
        .collect(Collectors.toList());
    }

    public UserData(String username, String password) {
        this.username = username;
        this.password = password;
    }
}