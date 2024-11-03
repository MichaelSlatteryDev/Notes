package com.example.notes.notes_spring.Configurations;

import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

import org.springframework.stereotype.Component;

@Component
public class SecretKeyGenerator implements SecretKeyGeneratorInterface {

    @Override
    public String generateSecretKey() {
        try {
            KeyGenerator keygen = KeyGenerator.getInstance("HmacSHA256");
            SecretKey sk = keygen.generateKey();
            return Base64.getEncoder().encodeToString(sk.getEncoded());
        } catch (NoSuchAlgorithmException exception) {
            throw new RuntimeException(exception);
        }
    }
}
