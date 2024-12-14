package com.example.notes.notes_spring.Documents;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "NOTE_TBL")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class NoteEntity {

    @Id
    @GeneratedValue
    private Integer id;

    private String title;

    private String description;

    @Column(updatable = false, nullable = false)
    private LocalDateTime createdAt;

    @Column(insertable = false)
    private LocalDateTime lastUpdatedAt;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private UserEntity user;
}
