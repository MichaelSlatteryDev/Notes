package com.example.notes.notes_spring.Configurations;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

public class AuthenticationSuccessHandlerTest {

    private AuthenticationSuccessHandler successHandler;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private Authentication authentication;

    @BeforeEach
    void setUp() {
        successHandler = new AuthenticationSuccessHandler();
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        authentication = mock(Authentication.class);
    }

    @Test
    void testOnAuthenticationSuccess_AdminRole() throws IOException, ServletException {
        // Mocking the admin role
        Answer<List<MockAuthority>> adminAuthorities = setupDummyListAnswer(new MockAuthority("ROLE_ADMIN"));
        when(authentication.getAuthorities()).thenAnswer(adminAuthorities);

        // Execute onAuthenticationSuccess
        successHandler.onAuthenticationSuccess(request, response, authentication);

        verify(response).encodeRedirectURL("null/admin/home");
    }

    @Test
    void testOnAuthenticationSuccess_NonAdminRole() throws IOException, ServletException {
        // Mocking the admin role
        Answer<List<MockAuthority>> adminAuthorities = setupDummyListAnswer(new MockAuthority("ROLE_USER"));
        when(authentication.getAuthorities()).thenAnswer(adminAuthorities);

        // Execute onAuthenticationSuccess
        successHandler.onAuthenticationSuccess(request, response, authentication);

        verify(response).encodeRedirectURL("null/login");
    }

    private <N extends GrantedAuthority> Answer<List<N>> setupDummyListAnswer(N... values) {
        final List<N> someList = new ArrayList<N>();

        someList.addAll(Arrays.asList(values));

        Answer<List<N>> answer = new Answer<List<N>>() {
            public List<N> answer(InvocationOnMock invocation) throws Throwable {
                return someList;
            }   
        };
        return answer;
    }
}
