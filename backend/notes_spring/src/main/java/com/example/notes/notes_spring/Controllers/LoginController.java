package com.example.notes.notes_spring.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.notes.notes_spring.Models.UserData;
import com.example.notes.notes_spring.Services.MyUserDetailsService;
import com.example.notes.notes_spring.Services.UserService;


@RestController
@RequestMapping()
public class LoginController {

    @Autowired
    MyUserDetailsService detailsService;

    @Autowired
    UserService verificationService;

    @PostMapping(value = "/login/{username}")
    public UserData handleLogin(@PathVariable String username) {
        return detailsService.loadUserInfo(username);
    }

    @PostMapping(value = "/verify")
    public String verifyUser(@RequestBody UserData user) {
        return verificationService.verify(user);
    }
}
