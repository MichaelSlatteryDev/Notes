package com.example.notes.notes_spring.Configurations;

import com.example.notes.notes_spring.Configurations.SecretKeyGeneratorInterface;

public class MockSecretKeyGenerator implements SecretKeyGeneratorInterface {

    private String key;

    public MockSecretKeyGenerator(String key) {
        this.key = key;
    }

    @Override
    public String generateSecretKey() {
        return key;
    }
}
