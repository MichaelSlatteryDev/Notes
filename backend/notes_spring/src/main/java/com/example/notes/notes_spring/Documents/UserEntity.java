package com.example.notes.notes_spring.Documents;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Table(name = "USER_TBL")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserEntity {

    @Id
    @GeneratedValue
    private Integer id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    private String role; // E.g "ADMIN,USER"

    @Column(updatable = false, nullable = false)
    private LocalDateTime createdAt;

    @Column(insertable = false)
    private LocalDateTime lastUpdatedAt;

    @OneToMany(mappedBy = "user")
    private List<NoteEntity> notes;
}
