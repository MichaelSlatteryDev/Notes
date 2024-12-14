package com.example.notes.notes_spring.Controllers;

import org.springframework.web.bind.annotation.RestController;

import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Services.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;


@RestController
@RequestMapping("/register")
public class RegistrationContoller {

    @Autowired
    UserService service;

    @PostMapping
    public UserData createUser(@RequestBody UserData user) throws Exception {
        try {
            return service.createUser(user);
        } catch(Exception exception) {
            System.out.println(exception);
            throw exception;
        }
    }
    

}
